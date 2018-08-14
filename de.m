clc
 close all
clear all
tic
img=imread('l.jpg');
f=eheq(img);
 toc
 figure,imshowpair(img,f, 'montage')