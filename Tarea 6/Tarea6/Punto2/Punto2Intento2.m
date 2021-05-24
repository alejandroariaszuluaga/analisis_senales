

%%
%2.1

%Se leen imagenes con sus landmarks
I1 = imread('punto2/images/022_y_f_n_a.jpg');
land1=importdata('punto2/landmarks/022_y_f_n_a.mat');
%Se plotea la imagen con sus landmarks
figure
hold on

image(I1)
scatter(land1(:,1),-land1(:,2),10,'filled')
% plot(land1(:,1),land1(:,2))
% camroll(-180)
hold off
%Se leen imagenes con sus landmarks
I2 = imread('punto2/images/022_y_f_h_a.jpg');
land2=importdata('punto2/landmarks/022_y_f_h_a.mat');
%Se plotea la imagen con sus landmarks
figure
hold on

image(I2)
scatter(land2(:,1),land2(:,2),10,'filled')
camroll(-180)
hold off

%Se leen imagenes con sus landmarks
I3 = imread('punto2/images/022_y_f_f_b.jpg');
land3=importdata('punto2/landmarks/022_y_f_f_b.mat');
%Se plotea la imagen con sus landmarks
figure
hold on

image(I3)
scatter(land3(:,1),land3(:,2),10,'filled')
camroll(-180)
hold off

%Se leen imagenes con sus landmarks
I4 = imread('punto2/images/016_y_m_s_a.jpg');
land4=importdata('punto2/landmarks/016_y_m_s_a.mat');
%Se plotea la imagen con sus landmarks
figure
hold on

image(I4)
scatter(land4(:,1),land4(:,2),10,'filled')
camroll(-180)
hold off

%Se leen imagenes con sus landmarks
I5 = imread('punto2/images/004_o_m_a_a.jpg');
land5=importdata('punto2/landmarks/004_o_m_a_a.mat');
%Se plotea la imagen con sus landmarks
figure
hold on

image(I5)
scatter(land5(:,1),land5(:,2),10,'filled')
camroll(-180)
hold off

%%
%2.2
%PONGA EN ESTA STRING LA DIRECCIÓN DONDE TENGA GUARDADAS LOS LANDMARKS 
%Se recorren las carpetas del workspace
dinfo = dir('D:\UNIVERSIDAD\OCTAVO SEMESTRE\Análisis Inteligente de Señales y Sistemas\Tareas\Tarea6\archivosSoporteTarea6\punto2\landmarks');
filenames = fullfile({dinfo.folder}, {dinfo.name});
numfiles = length(filenames);
% disp(filenames);
figure
title('Landmarks','interpreter','latex')

xlabel('x','interpreter','latex')
ylabel('y','interpreter','latex')
hold all


% image(I5)
%Para cada file.mat ploteamos las formas una sobre otra
%En este arreglo se van a guardar las formas 
Forms=zeros(67,1,numfiles-2);
for K = 3 : numfiles
%    
    Wprob=zeros(67,1);
    thisfile = filenames{K};
    thisfile2=convertCharsToStrings(thisfile);

    W=importdata(thisfile2);
    Wre=W(:,1);
    Wim=W(:,2);
    
    scatter(W(:,1),-W(:,2),2.4,'filled','b');
    
    
    
    Forms(:,:,K)=complex(Wre,Wim);
    
   

   

   
end
xlim([0,320]);
ylim([-460,0]);
hold off

%%
% 2.3
%Dar norma 0 + normalizar
figure 
hold on
title('Landmarks con media 0 y normalizados','interpreter','latex')
xlabel('x','interpreter','latex')
ylabel('y','interpreter','latex')


for K = 3 : numfiles
%    
    thisfile = filenames{K};
    thisfile2=convertCharsToStrings(thisfile);
    W=importdata(thisfile2);
    ReW=W(:,1);
    ImW=W(:,2);
%     Se les de una media de 0 a las formas
    W(:,1)=ReW-sum(ReW)/length(ReW);
    W(:,2)=ImW-sum(ImW)/length(ImW);
    
    ReW=W(:,1);
    ImW=W(:,2);
    
    
    ReW = ReW/norm(ReW);
    ImW = ImW/norm(ImW);
    
    W=[ReW ImW];
    
    %Se guardan las formas en forma estándar en un arreglo de 3 dimensiones
    Forms(:,:,K)=complex(ReW,ImW);
%     Se plotean las formas una sobre la otra
    scatter(W(:,1),-W(:,2),2.4,'filled','b');
    
   
   
end
ylim([-0.5,0.5])

hold off
%%
% 2.3

%Hallar matriz S
for K=1:numfiles
    W=Forms(:,:,K);
    
    if K==1
        S= W*W';
   
    else
        S=S+W*W';
    end
    
  
end
%%
% 2.3
% Hallamos lso valores propios de la matriz S y la forma es el vactor propio asociado al valor propio más grande

[V,D] = eig(S);
MaxEigval=max(max(D));
Media=V(:,67);
% ploteamos la media
hold on
title('Media de Procrustes','interpreter','latex')
xlabel('x','interpreter','latex')
ylabel('y','interpreter','latex')

scatter(imag(Media),real(Media),15,'filled','r');

x=imag(Media)
y=real(Media)

% Ojo derecho
plot([x(2:9);x(2)],[y(2:9);y(2)],'r','LineWidth',1.2);
% Ojo izquierdo
plot([x(11:18);x(11)],[y(11:18);y(11)],'r','LineWidth',1.2);
% Ceja derecha
plot([x(19:26);x(19)],[y(19:26);y(19)],'r','LineWidth',1.2);
% Ceja izquierda
plot([x(27:34);x(27)],[y(27:34);y(27)],'r','LineWidth',1.2);
% Centro nariz
plot([x(35:38);x(38)],[y(35:38);y(38)],'r','LineWidth',1.2);
% Contorno nariz
plot([x(39:49);x(35);x(39)],[y(39:49);y(35);y(39)],'r','LineWidth',1.2)
% Contorno labios
plot([x(50:57);x(50)],[y(50:57);y(50)],'r','LineWidth',1.2);

plot([x(58:63);x(58)],[y(58:63);y(58)],'r','LineWidth',1.2);

plot([x(64:67);x(64)],[y(64:67);y(64)],'r','LineWidth',1.2);

ylim([-0.31,0.31])
xlim([-0.31,0.31])

hold off


%%
% 2.3
%Proyección sobre la media

for k=1:numfiles
    W=Forms(:,:,k);
   
    
    %Se proyecta W sobre la media
    Forms(:,:,k) = W*((W'*Media)/(W'*W));
                      
    
end

%%
% Ploteamos la media con las formas proyectadas
hold on
title('Media de Procrustes con formas proyectadas','interpreter','latex')
xlabel('x','interpreter','latex')
ylabel('y','interpreter','latex')

for k=1:numfiles
    W=Forms(:,:,k);
    scatter(imag(W),real(W),2.4,'filled','b');

end



scatter(imag(Media),real(Media),15,'filled','r');

x=imag(Media)
y=real(Media)

% Ojo derecho
plot([x(2:9);x(2)],[y(2:9);y(2)],'r','LineWidth',1.2);
% Ojo izquierdo
plot([x(11:18);x(11)],[y(11:18);y(11)],'r','LineWidth',1.2);
% Ceja derecha
plot([x(19:26);x(19)],[y(19:26);y(19)],'r','LineWidth',1.2);
% Ceja izquierda
plot([x(27:34);x(27)],[y(27:34);y(27)],'r','LineWidth',1.2);
% Centro nariz
plot([x(35:38);x(38)],[y(35:38);y(38)],'r','LineWidth',1.2);
% Contorno nariz
plot([x(39:49);x(35);x(39)],[y(39:49);y(35);y(39)],'r','LineWidth',1.2)
% Contorno labios
plot([x(50:57);x(50)],[y(50:57);y(50)],'r','LineWidth',1.2);

plot([x(58:63);x(58)],[y(58:63);y(58)],'r','LineWidth',1.2);

plot([x(64:67);x(64)],[y(64:67);y(64)],'r','LineWidth',1.2);



hold off