clc
clear all
close all

%% Leer imágenes
% Cargar matriz U
U=imread('ladron.jpg');
U=double(U)/256; % Valor de pixeles queda entre 0 y 1
% Cargar matriz V
V=imread('ladronborroso.jpg');
V=double(V)/256; % Valor de pixeles queda entre 0 y 1

%% Resolver problema de optimización
% Inicialización del punto de inicio en 0
h_0 = zeros(6,1);
% Función para resolver problema de optimización, donde
% la función objetivo es la norma de Frobenius al cuadrado
% de la diferencia entre la imagen filtrada y la matriz V
comps_h = fminsearch(@frob_norm, h_0)

%% Evaluar resultado
% Definición de kernel con los valores finales de la solución
h_final = [comps_h(1), comps_h(2), comps_h(3); 0, 0, 0; comps_h(4), comps_h(5), comps_h(6)];
% Filtrado de la imagen con kernel final
H_U = imfilter(U, h_final);
% Gráficas
figure
subplot(1,3,1)
imshow(U)
title('Imagen Original')
subplot(1,3,2)
imshow(V)
title('Imagen Borrosa')
subplot(1,3,3)
imshow(H_U)
title('Imagen Filtrada')
