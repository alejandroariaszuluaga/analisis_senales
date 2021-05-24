% Se abre el archivo de texto con los coeficientes de la transformada de coseno

fileID=fopen('comprimida.txt');

tline=fgetl(fileID);

% Se lee el archivo de texto como una tabla

T=readtable('comprimida.txt');
% Se convierte la tabla a una matriz
C=table2array(T);
% Se visualizan los coeficientes
imagesc(C);
title('Coeficientes $C(u,v)$ de la transformada','interpreter','latex');
xlabel('$v$','interpreter','latex');
ylabel('$u$','interpreter','latex');
colorbar


%%
%Se define la dimensión de la imagen a reconstuir
M=630;
N=945;
%Se define la matriz de la imagen a reconstruir
IM=zeros(M,N);
% Se definen los alpha u y a´pha v
alphu=(sqrt(2/(M-1)))*ones(50,1);
alphu(1)=1/sqrt(M-1);

alphv=(sqrt(2/(N-1)))*ones(100,1);
alphv(1)=1/sqrt(N-1);

%Se implementa la DCT inversa
for x=1:1:630
    x2=x-1;
    M2=M;
    N2=N;
    
    for y=1:1:945
        y2=y-1;
        
        sum=0;
        for u=1:1:50
            u2=u-1;
            
            for v=1:1:100
                
                v2=v-1;
                arg1=(pi*u2*(2*x2+1))/(2*M2);
                arg2=(pi*v2*(2*y2+1))/(2*N2);
                sum=sum+alphu(u)*alphv(v)*C(u,v)*cos(arg1)*cos(arg2);
            end
            
        end
        
       
      
        
        IM(x,y)=sum;  
        
        
    end
    
end
%%
%Se imprime la imagen reconstruida
figure()
hold on
title('Reconstrucción de la imagen en escala de grises f(x,y)','interpreter','latex')
xlabel('$x$','interpreter','latex');
ylabel('$y$','interpreter','latex');
imshow(IM);


