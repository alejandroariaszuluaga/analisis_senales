% Tarea 4: Análisis de señales y sistemas.
clc;
clear;
close;

% Se lee la imagen original.
I = imread('paisaje.tif');
% Se aplica la función implementada para graficar el histograma y la FDA.
histograma(I);

% Se realiza la equialización de la imagen.
[J] = histeq(I);
% Se aplica la función implementada para graficar el histograma y la FDA.
histograma(J);

function [] = histograma(imagen)
% Halla el histograma y la función de desidad de probabilidad acumulada de
% una imagen.
%   Input: imagen: imagen que se desea analizar.
%   Output: Se grafica el histograma y la FDA.

% M filas, N columnas de la imgagen.
M=size(imagen,1);
N=size(imagen,2);

% Se halla el histograma de la imagen original, y se guarda en hist.
hist=zeros(1,256);
for m=1:M
    for n=1:N
        % Se recorren todas las escalas de gris 0-255.
        for h=0:255
            % Al recorrer la imagen, se clasifica la intensidad de cada
            % pixel.
            if imagen(m,n)==h
                % Lleva la cuenta de los pixeles con intensidad h.
                hist(h+1)=hist(h+1)+1;
            end
        end
    end
end

% Se normalizan los valores del histograma.
hist=hist/(M*N);

L=length(hist);
% Se crea la variable de la FDA.
d_acum=hist;
for i=2:L
    % Se halla la FDA partiendo de los valores normalizados del histograma.
    d_acum(1,i)=d_acum(1,i)+d_acum(1,i-1);
end

% Se grafican los resultados.
figure

subplot(1,3,1)
imshow(imagen)

subplot(1,3,2)
stem((0:255), hist, 'Marker', 'none');
title("Histograma de la imagen")
xlabel("Escala de grises"), ylabel("P");
xlim([0,255])

subplot(1,3,3)
plot((0:255), d_acum, 'Marker', 'none');
title("Función de distribución acumulada")
xlabel("Escala de grises"), ylabel("P");
xlim([0,255])
end