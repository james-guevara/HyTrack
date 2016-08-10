function tiff_write(Y,name)
% Y should be 3D, name should end in .tif, note the append mode
T = size(Y,3);
for t = 1:T
    imwrite(uint16(Y(:,:,t)),name,'WriteMode','append');
end


