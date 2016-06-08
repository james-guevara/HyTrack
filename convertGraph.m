function [dat_in, excess_node, dnum, k_dat] = convertGraph( oldG )
G = -oldG;

N = size(G,1)-2;
dnum = N;
n_nodes = 2*dnum+2;
dat_in = zeros(1e7,3);

%% Get neighbors for each tracklet
% Remember to take into account self-linking (i,i)th elements.
nei = cell(N,1);
for n=1:N
    tmpTracks = G(n,:);
    tmpInds   = find(tmpTracks);
    numTracks = numel(find(tmpTracks));
    for i=1:numTracks
        if ( tmpInds(i) ~= n && tmpInds(i) <= N )
            nei{tmpInds(i),1} = [nei{tmpInds(i),1} n];
        end
    end
end


%%
% Make dat_in
k_dat = 0;
for i=1:dnum
    k_dat = k_dat + 3;
    dat_in(k_dat-2,:) = [1      2*i     G(N+1,i)*1e16];
    % dat_in(k_dat-1,:) = [2*i    2*i+1   G(i,i)  ];
    dat_in(k_dat-1,:) = [2*i    2*i+1   1*1e6  ];
    dat_in(k_dat,:)   = [2*i+1  n_nodes G(i,N+2)*1e16];
end
for i=1:dnum
    f2 = nei{i};
    for j=1:length(f2)
        k_dat = k_dat + 1;
        dat_in(k_dat,:) = [2*f2(j)+1    2*i    G(f2(j),i)*1e6];
    end
end

dat_in = [dat_in repmat([0 1],size(dat_in,1),1)];
inds = find(dat_in(:,1));
dat_in = dat_in(inds,:);
excess_node = [1 n_nodes];



%%
% minCost = inf;
% minDat  = [];
% for tr_num=1:dnum
%     [cost, dat] = cs2_func(dat_in(1:k_dat,:), excess_node, [tr_num - tr_num]);
%     if (cost < minCost)
%         minCost = cost;
%         minDat  = dat;
%     elseif (minCost < cost)
%         break;
%     end
% end


end

