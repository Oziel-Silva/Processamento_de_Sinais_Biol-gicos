clear all; close all; clc;

load('../sinais/ecg_grupo1/ECG_1.mat','fs','x');

x = x(: ,1);
x = x - mean(x);
n = 0 : length(x) -1;
t = n;


%Cálculo da Tranformada de Fourier
X1 = fft(x) ;

%criando eixo de frenquências
f = linspace(-0.5, 0.5, length(X1))*fs;

%plotando sinal no domínio do tempo e frequência

figure
subplot(2,1,1)
plot(t,x);
xlabel('tempo (segundos)')
ylabel('x_c(t)')
 
subplot(2,1,2)
plot(f, fftshift(abs(X1)));
xlabel('frequência (Hz)')
ylabel('|X_c(f)|')

%criando os filtros
N = 1000; % ordem dos filtros
stop60 = [59 61]/(fs/2);
stop120 = [119 121]/(fs/2);
stop180 = [179 179.999]/(fs/2);
freqCorte5 = 0.8/(fs/2);

%escolha da janela
window = blackman(N+1);

h1 = fir1(N,stop60,'stop',window);
h2 = fir1(N,stop120,'stop',window);
h3 = fir1(N,stop180,'stop',window);
h4 = fir1(N,freqCorte5,'high',window);


y1 = filter(h1,1,x); % filtro para retirar o 60 Hz
y2 = filter(h2,1,y1); % filtro para tirar o 120 Hz
y3 = filter(h3,1,y2); % filtro para tirar o 180 Hz
y4 = filter(h4,1,y3); % filtro para tirar o a linha de base

%transformada de Fourier do sinal após filtragem
X_jw = fftshift(abs(fft(y4)));

figure
subplot(2,1,1)
plot(t,y4);
xlabel('tempo (segundos)')
ylabel('x_c(t)')
 
subplot(2,1,2)
plot(f, (X_jw));
xlabel('frequência (Hz)')
ylabel('|X_jw(f)|')

%separando os picos QRS (10 amostras de QRS)
qrs{1} = y4(2352 : 2385)';
qrs{2} = y4(2647 : 2673)';
qrs{3} = y4(2928 : 2959)';
qrs{4} = y4(3216 : 3242)';
qrs{5} = y4(3498 : 3526)';
qrs{6} = y4(3793 : 3821)';
qrs{7} = y4(4028 : 4054)';
qrs{8} = y4(4385 : 4418)';
qrs{9} = y4(4690 : 4718)';
qrs{10} = y4(4984 : 5008)';

for k= 1: 10
QRS{k} = abs(fft(qrs{k}, 1000)).^2;
end

mean_qrs = zeros(1,1000);

% tirando a média
for i = 1 : 1000
    for k = 1 : 10
        v = QRS{k};
        v = v(i);
        mean_qrs(i) = mean_qrs(i) + v/10; 
    end
end
f= linspace (-0.5, 0.5, length(mean_qrs))*fs; 
figure

plot(f,fftshift(mean_qrs));
a = axis();
axis ([0 50 a(3) a(4)]);
