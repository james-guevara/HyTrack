function [ Y_new ] = showNucleiStack( Y, posStack )
%   posStack is cell of positions. Each cell: first column are x
%   coordinates, second column are y coordinates
T = size(Y,3);
Y_new = zeros(size(Y));
for t=1:T
        if (~isempty(posStack{t}))
            Y_new(:,:,t) = showNuclei(Y(:,:,t),posStack{t});
        else
            Y_new(:,:,t) = Y(:,:,t);
        end
end



end

