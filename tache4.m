clear;clc; close all;

% Load images.
buildingDir = fullfile(toolboxdir('vision'), 'visiondata', 'building');
buildingScene = imageDatastore(buildingDir);

% Display images to be stitched
A = readimage(buildingScene, 1);
B = readimage(buildingScene, 2);


%uint8 to double
A = double(A);
B = double(B);

subplot(121), imshow(uint8(A));
subplot(122), imshow(uint8(B));


% figure,imshow(uint8(A));
% [in_x,in_y] = getpts;
% OUT = [in_x in_y];
% close all;
% 
% figure,imshow(uint8(B));
% [out_x,out_y] = getpts;
% IN = [out_x out_y];
% 
% close all;


load('building.mat')

H = homography_solve(IN',OUT');


%matrice de resultat final
resultat = ones(1,1,3);

%fonction homographie M
M = zeros(1,1,2);
x_max = size(B,2); 
y_max = size(B,1);

for i=1:x_max
    for j=1:y_max
        Pp = homography_transform([i;j], H);        
        p = round(Pp);        
        M(i,j,:) = [p(1),p(2)];       
        
    end
end

%calcul du decalage negatif
Mx = M(:,:,1);
xm = - min(min(Mx(:)),0);
My = M(:,:,2);
ym = - min(min(My(:)),0);



% copie de A dans resultat
for i=1:size(A,1)
    for j=1:size(A,2)
        resultat(i+ym,j+xm,:)=A(i,j,:);
    end
end


% B dans resultat selon M
for i=1:x_max
    for j=1:y_max
        
        p(1) = M(i,j,1) ;    
        p(2) = M(i,j,2) ; 
        
        resultat(p(2)+ym+1,p(1)+xm+1,:) = B(j,i,:);
        
    end
end

figure, imshow(uint8(resultat));




