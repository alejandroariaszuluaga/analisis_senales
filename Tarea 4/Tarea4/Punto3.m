% Tarea 4: Análisis de señales y sistemas.
clc;
clear;
close;

% Se lee la imagen.
I = imread('ladron.jpg');

% Orden del filtro
n=3;

%%
% b)
% Se diseña el filtro que vuleve la imagen borrosa.
b=ones(n)/(n*n);
% Se emplea el filtro con la funcion diseñada.
f=filtro(I,b);

% Se diseña el filtro de deteccion de bordes. 
db=[-3, -3, -3; -3, 24, -3; -3, -3, -3];
% Se emplea el filtro con la funcion diseñada.
g=filtro(I,db);

%%
% c

frec(f, 'Filtro borroso');
frec(g, 'Detección de bordes');
frec(I, 'Imagen original');

function[] = frec(f, titulo)
% Halla el espectro de feecuencia de una imágen y lo grafica.
    F = fft2(f);
    F=fftshift(log(1+abs(F)));
    figure, 
    imagesc(F), title(titulo) , colorbar
end

%%
function [f]=filtro(im, w)
imagen=im2double(im);

% Se definen las dimensiones de la imagen, se declaran variables auxiliares.
M=size(imagen,1);
N=size(imagen,2);
n=size(w,1);
a=(n+1)/2;
b=(n-1)/2;
f=zeros(M-n-1, N-n-1);

% Primero se recorre cada pixel de la imagen.
for x=1:M
    for y=1:N
        % Se declara la variable aux de la suma.
        suma=0;
        % Se establecen los limites del filtro.
        for k=-b:b
            for l=-b:b
                % Si el filtro se encuentra en un pixel, se aplica.
                if x+k>0 && y+l>0 && k+x<=M && l+y<=N
                    suma=suma+w(k+a,l+a)*(imagen(x+k, y+l));
                end
            end
        end
        % Se le da el valor al pixel de acuerdo a la suma realizada.
        f(x,y)=suma;
    end 
end
% Se pasa al espacio de la imagen.
f=im2uint8(f);

% Se grafica.
figure;
subplot(1,2,1)
imshow(im)
subplot(1,2,2)
imshow(f)
end
          