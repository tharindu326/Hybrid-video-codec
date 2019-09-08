# Hybrid-video-codec
Partial prediction in Matlab. Full search method to block matching. P frame prediction using motion vectors 

Motion vectors and Frame estimaton 

This is a hybrid video codec. First i frames encoded using DCT and enthropy coding(Haffman) sed to the buffer and then decoded again at 
the video decoder inorder to creat Motion vectors using target image and refference image.
THen the displacement of the target and the predicted were encoded and send it to the channel.
Then again the predicted images was encoded and decoded to creat next predicted one.
Like wise continuously Frames were predicted by using previous predicted frames to the format IPPPPP

DECODER and ENCODER

Firt Perform DCT on images and quantised using crominance Mat of JPEG and then encoded using Haffman encoding 
For the Decoder invers if this done.


Open Source Licence

Feel free to use this codes and let me know your comments.

[Author] Tharindu Ekanayake _ tharindu326@gmail.com

Ref:
Still Image and Video Compression with MATLAB
By K. S. Thyagarajan
