 close all
 clear all
 img=imread('Lenna_(test_image).PNG');

  gray_img=rgb2gray(img);
  imshow(gray_img); title('original gray image(A)');
  imwrite( gray_img,'original gray image.png');
% DCT_img=dct2(gray_img);
% figure
% imshow(DCT_img*0.01);title('DCT GRAY imAGE');
% inverse_DCT_img=idct2(DCT_img);
% figure
% imshow(inverse_DCT_img/255); title('IDCT GRAY image');


Function_DCT=@(block_struct) dct2(block_struct.data);
Function_IDCT=@(block_struct) idct2(block_struct.data);

%%%%%%%%%%%%%%%%%%%%%DCT%%%%%%%%%%%%%%%
%distinct blok processing for image after DCT
block_DCT = blockproc(gray_img, [8 8], Function_DCT);

%how many bits keep after done the DCT
depth = find(abs(block_DCT) < 50)
block_DCT(depth)= zeros(size(depth));

figure
imshow(block_DCT);title('original gray image after DCT(B)');
imwrite(block_DCT, 'original gray image after DCT.png');
%%%%%%%%%%%%%IDCT%%%%%%%%%%%%%%%%
%distinct blok processing for image after IDCT
block_IDCT = blockproc(block_DCT, [8 8], Function_IDCT) / 255;

figure
imshow(block_IDCT);title('original gray image after IDCT @ encoder.png');
imwrite(block_IDCT, 'original gray image after IDCT @ encoder.png');

% img_afterIDCT = ind2rgb(block_IDCT);
% figure
% imshow(img_afterIDCT);title('original  image after IDCT');
% imwrite(block_IDCT, 'original  image after IDCT.png');


% imfinfo('original gray image.png');
% imfinfo('original  image after IDCT.png');

compression_ratio = numel(block_DCT)/numel(depth);

%quantization

% A Standard Quantization Matrix

q_mtx =     [16 11 10 16 24 40 51 61; 
            12 12 14 19 26 58 60 55;
            14 13 16 24 40 57 69 56; 
            14 17 22 29 51 87 80 62;
            18 22 37 56 68 109 103 77;
            24 35 55 64 81 104 113 92;
            49 64 78 87 103 121 120 101;
            72 92 95 98 112 100 103 99];
        
   %PErforming Quantization by Dividing with q_mtx on blocks of 8 by 8
   Function_Quantization = @(block_struct) round((block_struct.data) ./ q_mtx);        
   DCT_quantized = blockproc(block_DCT,[8 8],Function_Quantization);

figure
imshow(DCT_quantized,[]);title('original gray image_DCT after quantied(C)');
   
[g,~,intencity_val]=grp2idx(DCT_quantized(:));
frequency = accumarray(g,1);% frequencies of thresholds 

[intencity_val frequency];
probability = frequency./(512*512) ;
T = table(intencity_val,frequency,probability);%table(element | count| prob
%T(1:length(frequency),:);

%%%%%%%%%%%%%%%%% huffman coding %%%%%%%%%%%%%%%%
Array_probability=table2array(T(:,3))
Array_intensity=table2array(T(:,1))
dict_codes= huffmandict(Array_intensity,Array_probability);
full_code_img = huffmanenco(DCT_quantized(:),dict_codes);
file3 = fopen('full_text_code.txt','w');
[r,~]=size(full_code_img);
for c=1:r
    fprintf(file3, '%d',full_code_img(c));
end
fclose(file3);

%%%%%%%%%%%%%%%%%%% Huffman decoding %%%%%%%%%%%%%%%%%%%%%%%

Decoded_quontized_img_array = huffmandeco(full_code_img,dict_codes);
Decoded_quontized_img_mat=reshape(Decoded_quontized_img_array,[512,512])
%checking
isequal(DCT_quantized,Decoded_quontized_img_mat)
figure
imshow(Decoded_quontized_img_mat,[]);title('original gray image after decode @ huffman decoder(C)');

%%%%%%%%%%%%%% dequantization %%%%%%%%%%%%
%Performing Inverse Quantization By Multiplying with q_mtx on Blocks of 8
%by 8
Decoded_dequontized_img_mat = blockproc(Decoded_quontized_img_mat,[8 8],@(block_struct) q_mtx .* block_struct.data);
figure
imshow(Decoded_dequontized_img_mat,[]);title('original gray image after dequantized(B)');
%%%%%%%%%%%IDCT in decoder %%%%%%%%%%%%%%%%

block_IDCT_decoder = blockproc(Decoded_dequontized_img_mat, [8 8], Function_IDCT) / 255;

figure
imshow(block_IDCT_decoder);title('original gray image after IDCT @ decoder(A)');

imwrite(block_IDCT_decoder, 'original gray image after IDCT @ decoder.png');

imfinfo('original gray image.png')
imfinfo('original gray image after IDCT @ encoder.png')
imfinfo('original gray image after IDCT @ decoder.png')


Author : Tharindu Ekanayake 
tharindu@gmail.com


