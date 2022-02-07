clc;
close all;
clear;
K = ["200-front.jpg","200-back.jpg","100-Front.jpg","100-back.jpg","50-Front.jpg","50-back.jpg","20-front.jpg","20-back.jpg","10-Front.jpg","10-back.jpg","5-Front.jpg","5-back.jpg","1-Front.jpg","1-back.jpg","0.5-Front.jpg","0.5-back.jpg"];
V = [200,200,100,100,50,50,20,20,10,10,5,5,1,1,0.5,0.5];

all_back = imread('all-back.jpg');
all_front_back = imread('all-front-back.jpg');
one_rotated = imread('one-rotated.jpg');
desired_image = one_rotated;

img = rgb2gray(desired_image);
bw = img<254;
L = bwlabel(bw);
measurements = regionprops(L, 'BoundingBox','Orientation');

f = 1000000000;
sum = 0;
index = 0 ;
for k = 1 : length(measurements)
    desired_image = one_rotated;
    thisBB = measurements(k).BoundingBox;
    if thisBB(3) < 2 || thisBB(4) < 2
        continue;
    end
    if abs(measurements(k).Orientation) > 1
        rot = imcrop(desired_image,[measurements(k).BoundingBox(1),measurements(k).BoundingBox(2),measurements(k).BoundingBox(3),measurements(k).BoundingBox(4)]);
        rot2 = imrotate(rot,-measurements(k).Orientation,'crop');
        rot2(rot2==0)=255;
        rg = rgb2gray(rot2);
        bw1 = rg < 254;
        H = bwlabel(bw1);
        mesa = regionprops(H,'BoundingBox');
        thisBB = mesa(1).BoundingBox;
        desired_image = rot2;
        I2=imcrop(desired_image,[thisBB(1),thisBB(2),thisBB(3),thisBB(4)]);
        I2 = imresize(I2,[360,700]);
        I2 = rgb2gray(I2);
        featuresI2G = extractLBPFeatures(I2);
    else
        I2=imcrop(desired_image,[thisBB(1),thisBB(2),thisBB(3),thisBB(4)]);
        imgg = rgb2gray(I2);
        featuresI2G = extractLBPFeatures(imgg);
    end
    for n=1 : length(K)
        IC = imread(K(n));
        ICG = rgb2gray(IC);
        featuresIC = extractLBPFeatures(ICG);
        diff = (featuresI2G-featuresIC).^2;

        sum1 = 0;
        for i=1 : length(diff)
            sum1 = sum1 + diff(i);
        end
        if f > sum1
        f = sum1;
        index = n;
        end
    end
sum = sum + V(index); 
f=10000000;

end

display(sum);