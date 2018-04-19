clear all; close all; clc;

load('sinais/ecg_grupo1/ECG_1.mat','fs','x');

x = x(: ,1);
n = 0 : length(x) -1;
t = n/fs;

% plot(t, x)
% grid on;
% xlabel('tempo (segundos)');
% ylabel('x(t)');

%Cálculo da Tranformada de Fourier
X = fft(x) - mean(x);

%criando eixo de frenquênci
f = linspace(-0.5, 0.5, length(X))*fs;

%plotando
figure
subplot(2,1,1)
plot(t,x);
xlabel('tempo (segundos)')
ylabel('x_c(t)')

subplot(2,1,2)
plot(f, fftshift(abs(X)));
xlabel('frequência (Hz)')
ylabel('|X_c(f)|')

%aplicando filtro em x(t)
N = 160;
Wn = [59 61]*2/fs;
window = blackman(N+1);

h = fir1(N,Wn,'stop',window);

plot(h);


