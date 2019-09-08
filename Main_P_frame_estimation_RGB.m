close all
clear all
N=8;
M=8;
img_f_r = imread('01.image_ref.jpg');
% Extract the individual red, green, and blue color channels.
R_f_r = img_f_r(:,:,1);
G_f_r = img_f_r(:,:,2);
B_f_r = img_f_r(:,:,3);
ti_r=size(img_f_r);
zer_r=zeros(ti_r,'uint8');
img_R_r=zer_r;
img_V_r=zer_r;
img_B_r=zer_r;

img_R_r(:,:,1)=R_f_r;
img_V_r(:,:,2)=G_f_r;
img_B_r(:,:,3)=B_f_r;

% figure(2)
% subplot(131)
% imshow(img_R_r)
% title('Composante R_r')
% subplot(132)
% imshow(img_V_r)
% title('Composante V_r')
% subplot(133)
% imshow(img_B_r)
% title('Composante B_r')

img_f_t= imread('02.image_target.jpg');
% Extract the individual red, green, and blue color channels.
R_f_t = img_f_t(:,:,1);
G_f_t = img_f_t(:,:,2);
B_f_t = img_f_t(:,:,3);

ti_t=size(img_f_t);
zer_t=zeros(ti_t,'uint8');
img_R_t=zer_t;
img_V_t=zer_t;
img_B_t=zer_t;

img_R_t(:,:,1)=R_f_t;
img_V_t(:,:,2)=G_f_t;
img_B_t(:,:,3)=B_f_t;

% figure(3)
% subplot(131)
% imshow(img_R_t)
% title('Composante R_t')
% subplot(132)
% imshow(img_V_t)
% title('Composante V_t')
% subplot(133)
% imshow(img_B_t)
% title('Composante B_t')

% f_r=rgb2gray(img_f_r);
% f_t=rgb2gray(img_f_t);
th=0 ;

[R_f_e,R_tot_sad,R_tot_sado,R_comp,V1_R,V2_R] = blockmatching(R_f_r,R_f_t,N,M,th) ;
[G_f_e,G_tot_sad,G_tot_sado,G_comp,V1_G,V2_G] = blockmatching(G_f_r,G_f_t,N,M,th) ;
[B_f_e,B_tot_sad,B_tot_sado,B_comp,V1_B,V2_B] = blockmatching(B_f_r,B_f_t,N,M,th) ;

rgbImage_f_e = cat(3, R_f_e, G_f_e,B_f_e);
Estimated_Frame = uint8(rgbImage_f_e);

 figure,subplot(1,2,1),imshow(img_f_t); 
 title('Target Image'); 
 subplot(1,2,2),imshow(Estimated_Frame); 
 title('Predicted Image');
% f_t = double(f_t(1:row,1:col));
% f_r = double(f_r(1:row,1:col));
 
imwrite(Estimated_Frame, '03.image_predicted.jpg');
imfinfo('03.image_predicted.jpg');
imfinfo('01.image_ref.jpg');


% imwrite(mat2gray(f_t), 'original target image.jpg');
% imwrite(mat2gray(f_e), 'original estimate image.jpg');
% imwrite(mat2gray(f_r), 'original refference image.jpg');
% imfinfo('original target image.jpg')
% imfinfo('original estimate image.jpg');
% imfinfo('original refference image.jpg');

Author : Tharindu Ekanayake 
tharindu@gmail.com

