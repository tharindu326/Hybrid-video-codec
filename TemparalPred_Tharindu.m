%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Block Matching Motion Estimation Method
%%%% Inputs 

% f_r ---> Reference Image 
% f_t ---> Target Image
% N ---> Block Size 
% M ---> Search Window 
% th ---> Threshold Value ( such a way that we can neglect the motion
          % vectors less than threshold value ( it is set to zero to consider all MVs
% Outputs 

% f_e ---> Estimated Image
% dfd ---> Displaced Frame Difference
% fd ---> Frame Difference
% tot_sad ---> Total SAD value 
% tot_sado ---> Total SAD value at v=0 
% comp --> Number of Iterations/Computations Performed 



function [f_e,tot_sad,tot_sado,comp,V2,V1]=blockmatching_093(f_r,f_t,N,M,th) 

% Make image size divisible by 8
[X,Y,nframes] = size(f_t);
if mod(X,N)~=0
    row1 = floor(X/N)*N;  % cut off the extra rows if not divisible by N
    row = row1 +8 ;
    need_row = (row-X)/2 ;
else
    row = X;             % else keep as it is
    need_row = 0 ;
end
if mod(Y,N)~=0
    col1 = floor(Y/N)*N;   % cut off the extra cols if not divisible by N
    col=col1+8 ;
    need_col = (col-Y)/2;
else
    col = Y;              % else Keep as it is
     need_col = 0 ;
end
clear X Y Z

row
col
% padding the traget img and reference image to devisible by 8
f_t = double(padarray(f_t,[need_row need_col],'replicate','both'));
f_r = double(padarray(f_r,[need_row need_col],'replicate','both'));

size(f_t)
size(f_r)

% prediction frame Initialisation

f_e = double(zeros(row,col)); 

a=1;
b=1; 
%Initiating the Total SAD variable
tot_sad=0; 
tot_sado=0; 
it=1; 
%Number of Computations 
comp=1;
tic ;
for i=1:N:row 
    for j=1:N:col 
        %Initializing Motion Vectors and SAD matrices 
        v1_min=0; 
        v2_min=0; 
        sad=[];
        v1_mat=[]; 
        v2_mat=[]; 
        it=1; 
 %Searching for the optimal motion vector over the entire search range M 
 for v1=-M:M 
     for v2=-M:M 
         %Incrementing the number of Computations 
         comp=comp+1;
         %Determining the Row start points for Target and Reference Blocks to be compared for Motion Estimation
         start_t_i=i; 
         start_r_i=v1+i;
         %Determining the Row end points for Target and Reference Blocks
         if(start_t_i+N>row) 
             end_t_i=row;
             end_r_i=v1+row; 
         else end_t_i=start_t_i+N-1; 
             end_r_i=start_r_i+N-1; 
         end; 
         %Determining the Column Start Points for Target and Reference Blocks 
         start_t_j=j;
         start_r_j=j+v2; 
         %Determining the Column end points for Target and Reference Blocks 
         if(start_t_j+N>col) 
             end_t_j=col; 
             end_r_j=v2+col; 
         else
             end_t_j=start_t_j+N-1;
             end_r_j=start_r_j+N-1; 
         end;
         if(end_r_i<row && end_r_j<col && start_r_i>0 && start_r_j>0)
             %Calculating the SAD value for the current motion vector
             dif=f_t(start_t_i:end_t_i,start_t_j:end_t_j)-f_r(start_r_i:end_r_i,start_r_j:end_r_j); 
             dif=abs(dif);
             sadx=sum(sum(dif));
             if(it==1) sad=sadx;
                 v1_mat=v1;
                 v2_mat=v2;
                 it=it+1;
             else
                 sad=[sad ;sadx];
                 v1_mat=[v1_mat; v1];
                 v2_mat=[v2_mat; v2];
             it=it+1; 
             end;
         end;
     end;
 end; 
 % Finding the Motion vectors for Minimum SAD value 
 if(isempty(sad)==0) 
    pos=find(sad==min(sad)); 
    v1_min=v1_mat(pos(1),1); 
    v2_min=v2_mat(pos(1),1); 
 end; 
 %Calculating SAD(0) 
 sado=abs(f_t(start_t_i:end_t_i,start_t_j:end_t_j)-f_r(start_t_i:end_t_i,start_t_j:end_t_j)); 
 sado=sum(sum(sado)); 
 tot_sado=tot_sado+sado; 
 %Checking for the Threshold Condition 
 if(min(sad)>=sado-th*N*N)
     v1_min=0;
     v2_min=0; 
     tot_sad=tot_sad+sado; 
 else
     tot_sad=tot_sad+min(sad);
 end;
 %Storing the determined motion vectors in an array
 V1(a,b)=v1_min; 
 V2(a,b)=v2_min; 
 b=b+1; 
 %Calculating the start and end points in the Predicted and to be
 %assigned Reference Block 
 start_r_j=j+v2_min; 
 start_r_i=v1_min+i; 
 if(start_r_j+N-1>col && start_t_j+N-1<=col) 
     end_r_j=2*start_r_j+N-col -1; 
     end_t_j=col; 
 end; 
 if(start_t_j+N-1>col&&start_r_j+N-1<=col) 
     end_r_j=start_r_j+start_t_j+N-col -2;
     end_t_j=col; 
 end; 
 if(start_t_j+N-1>col && start_r_j+N-1>col ) 
     end_t_j=col; 
     end_r_j=start_r_j+end_t_j-start_t_j;
 end; 
 if(start_t_j+N-1<=col )
     end_r_j=start_r_j+N-1; 
     end_t_j=start_t_j+N-1; 
 end; 
 if(start_r_i+N-1>row || start_t_i+N-1<=row) 
    end_r_i=2*start_r_i+N-row -1; 
    end_t_i=row; 
 end; 
if(start_t_i+N-1>row || start_r_i+N-1<=row) 
    end_r_i=start_r_i+start_t_i+N-row -2;
    end_t_i=row; 
end; 
if(start_t_i+N-1>row && start_r_i+N-1>row ) 
    end_t_i=row ;
    end_r_i=start_r_i+end_t_i-start_t_i;
end; 
if(start_t_i+N-1<=row )
    end_t_i=start_t_i+N-1; 
    end_r_i=start_r_i+N-1;
end;
    f_e(start_t_i:end_t_i,start_t_j:end_t_j)=f_t(start_r_i:end_r_i,start_r_j:end_r_j); 
    end;
    b=1;
    a=a+1; 
end; 

% f_t = double(f_t(1:row,1:col));
% f_r = double(f_r(1:row,1:col));

%Getting the Displaced Difference Frame Image
dfd=imsubtract(f_e,f_t); 
%Getting the minimum value so as to properly match -ve values for better
%display 
min_dfd=min(min(dfd));
dfd=dfd+abs(min_dfd);
%Getting the Frame Difference 
fd=imsubtract(f_r,f_t); 
%Getting the minimum value so as to properly match -ve values for better 
%display
min_fd=min(min(fd)); 
fd=fd+abs(min_fd);
% 
% size(f_e)
% size(f_t)
% 
% 
figure,subplot(1,2,1),imshow(mat2gray(f_t)); 
title('Target Image'); 
subplot(1,2,2),imshow(mat2gray(f_e)); 
title('Predicted Image');

figure,subplot(1,2,1),imshow(mat2gray(dfd));
title('Displaced Frame Difference'); 
subplot(1,2,2),imshow(mat2gray(fd)); 
title('Frame Difference');

DFD=mat2gray(dfd);
imwrite(DFD , 'Displaced Difference P1-F_t.jpg');

figure,quiver(V2,V1);
set(gca,'xaxislocation','top','yaxislocation','left','xdir','default','ydir','reverse'); 
title('Motion Vector Field');
xlabel('Columns'); 
ylabel('Rows'); 
toc ;
end





