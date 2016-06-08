function [ minCost, minDat ] = runNetworkFlow( dat_in, excess_node, dnum, k_dat )
minCost = inf;
minDat = [];
for tr_num=1:dnum
    tr_num
    [cost, dat] = cs2_func(dat_in(1:k_dat,:), excess_node, [tr_num -tr_num]);
    if (cost < minCost)
        minCost = cost;
        minDat  = dat;
    elseif (minCost < cost)
        break;
    end
end



end

