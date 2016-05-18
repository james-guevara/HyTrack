function Y = tiff_read(name)
info = imfinfo(name);
T = numel(info);
d1 = info(1).Height;
d2 = info(1).Width;
Y = zeros(d1,d2,T);
for t = 1:T
    temp = im2double(imread(name, t, 'Info',info));
    Y(:,:,t) = temp(1:end,1:end);
end

