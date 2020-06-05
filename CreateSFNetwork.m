%%
% Purpose:
% The CreateSFNetwork m-file is used to simulate the B-A algorithm and returns 
% a scale-free networks of given node sizes

%%
% Input Parameters:
% nodes        - integer
%              - The desired network size, including the seed network size 
%              (i.e. Nodes minus seed network size equals the number of 
%              nodes to be added).

% mlinks       - integer
%              - The number of links a new node can make to the 
%              existing network nodes.

% seed         - matrix
%              - This is the original network to which the B-A algorithm links 
%              additional nodes with a specific preferential attachment procedure

%% 
% Output Parameters:
% SFNetwork    - matrix
%              - This is a structure of the Scale Free Network produced. It 
%              shows the relationship of all the nodes and show the links 
%              between the nodes.            

%%
function SFNetwork = CreateSFNetwork(nodes, mlinks, seed)

seed = full(seed);              % Convert the matrix to full storage 
seedlength = length(seed);      % Length of max dimension

rand('state',sum(100*clock));

Net = zeros(nodes, nodes, 'single');    % Initialize net matrice
Net(1:seedlength,1:seedlength) = seed;  % Insert seed into the net
sumlinks = sum(sum(Net));               % Total number of links in net

while seedlength < nodes
    seedlength = seedlength + 1;
    linkage = 0;
    while linkage ~= mlinks
        rnode = ceil(rand * seedlength);
        deg = sum(Net(:,rnode)) * 2;
        rlink = rand * 1;
        if rlink < deg / sumlinks && Net(seedlength,rnode) ~= 1 && Net(rnode,seedlength) ~= 1
            Net(seedlength,rnode) = 1;
            Net(rnode,seedlength) = 1;
            linkage = linkage + 1;
            sumlinks = sumlinks + 2;
        end
    end
end

SFNetwork = Net;

end