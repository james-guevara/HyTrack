function [trackAssociations, minCost] = tracking_push_relabel_two( trackletData )
c_en = 1e6;
c_ex = 1e6;
c_ij = 1e6;

[~,~,N] = size(trackletData);
dnum = N;
n_nodes = 2*dnum+2;
n_edges = 0;
% dat_in - each row represents an edge from node in column 1 to node in
% column 2 with cost in column 3
dat_in = zeros(1e7,3);
k_dat = 0;
for i = 1:dnum
    k_dat = k_dat + 3;
    dat_in(k_dat-2,:) = [1      2*i     c_en        ];
    dat_in(k_dat-1,:) = [2*i    2*i+1   dres.c(i)   ];
    dat_in(k_dat,:)   = [2*i+1  n_nodes c_ex        ];
end
for i=1:dnum
    f2 = dres.nei(i).inds;
    for j = 1:length(f2)
        k_dat = k_dat + 1;
        dat_in(k_dat,:) = [2*f2(j)+1 2*i c_ij];
    end
end
% Add two columns: 0 for min capacity in column 4 and 1 for max capacity in
% column 5 for all edges.
dat_in = [dat_in repmat([0 1],size(dat_in,1),1)];
% Push flow in the first node and collect it in the last node.
excess_node = [1 n_nodes];

minCost = inf;
minDat  = [];
for tr_num=1:dnum
    [cost, dat] = cs2_func(dat_in(1:k_dat,:), excess_node, [tr_num - tr_num]);
    if (cost < minCost)
        minCost = cost;
        minDat  = dat;
    elseif (minCost < cost)
        break;
    end
end

trackAssociations = minDat;


end

