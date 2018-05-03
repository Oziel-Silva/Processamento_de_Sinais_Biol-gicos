clear all; close all; clc;

load('../sinais/ecg_grupo1/ECG_1.mat','fs','x');

x = x(: ,1);
n = 0 : length(x) -1;
t = n;


%Cálculo da Tranformada de Fourier
X1 = fft(x) - mean(x);

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
qrs1 = y4(2352 : 2385)';
qrs2 = y4(2647 : 2673)';
qrs3 = y4(2928 : 2959)';
qrs4 = y4(3216 : 3242)';
qrs5 = y4(3498 : 3526)';
qrs6 = y4(3793 : 3821)';
qrs7 = y4(4028 : 4054)';
qrs8 = y4(4385 : 4418)';
qrs9 = y4(4690 : 4718)';
qrs10 = y4(4984 : 5008)';

QRS1 = (abs(fft([qrs1 zeros(1 ,abs(length(qrs1) - 1000))]))).^2;
QRS2 = (abs(fft([qrs2 zeros(1 ,abs(length(qrs2) - 1000))]))).^2;
QRS3 = (abs(fft([qrs3 zeros(1 ,abs(length(qrs3) - 1000))]))).^2;
QRS4 = (abs(fft([qrs4 zeros(1 ,abs(length(qrs4) - 1000))]))).^2;
QRS5 = (abs(fft([qrs5 zeros(1 ,abs(length(qrs5) - 1000))]))).^2;
QRS6 = (abs(fft([qrs6 zeros(1 ,abs(length(qrs6) - 1000))]))).^2;
QRS7 = (abs(fft([qrs7 zeros(1 ,abs(length(qrs7) - 1000))]))).^2;
QRS8 = (abs(fft([qrs8 zeros(1 ,abs(length(qrs8) - 1000))]))).^2;
QRS9 = (abs(fft([qrs9 zeros(1 ,abs(length(qrs9) - 1000))]))).^2;
QRS10 = (abs(fft([qrs10 zeros(1 ,abs(length(qrs10) - 1000))]))).^2;

mean_qrs = zeros(1,1000);

% tirando a média
for i = 1 : 1000
    mean_qrs(i) = (QRS1(i) + QRS2(i) + QRS3(i) +QRS4(i) + QRS5(i) + QRS6(i) + QRS7(i) + QRS8(i) + QRS9(i) + QRS10(i) )/10; 
end
figure
plot(mean_qrs)
