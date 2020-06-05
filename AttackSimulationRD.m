%%
% Purpose: 
% The AttackSimulationRD m-file is used to simulate an intentional attack on 
% a Scale Free Network. It is done by the removal of the hubs 
% in the network that were identified by recalculating the networks degree
% distribution after every hub removal. The type of attack simluated is called 
% recalculated degree attack. 


%%
% Input Parameters:
% SFNetwork    - matrix
%              - This is a model of a Scale Free Network. It shows the
%              relationship of all the nodes and show the links between the
%              nodes.   

% nodes        - integer
%              - The desired network size, including the seed network size 
%              (i.e. Nodes minus seed network size equals the number of 
%              nodes to be added).

% fractionremoved - double
%               - This refers to the percentage of the total nodes that
%               needs to be removed
%%
% Output Parameters:
% attackednet  - matrix
%              - This is a structure of the Scale Free Network after it the
%              the hubs are sufficiently removed. It shows the relationship 
%              between the remaining nodes and links.

% hubsidentity - matrix
%              - This specify which nodes are the hubs of the scale free
%              network. The first row indicates the nodal degree of the hubs 
%              and the second row inicates the indexes of these hubs located 
%              in the scale free network.

%%
function [attackednet,hubsidentity] = AttackSimulationRD(SFNetwork, nodes, fractionremoved)

network=SFNetwork;
numtoattack=ceil(fractionremoved*nodes);
hubsidentity=[];

%%
for aa=1:numtoattack
    % Determine number of connections each node has
    connections = single(sum(network));
    
    % Identifying the largest hub
    [maxnodedegree,index]=max(connections);
    hubsidentity(1,end+1)=maxnodedegree;
    hubsidentity(2,end)=index;
    
    % Removing all the links attached to the hub
    network(index,:)=zeros(1,nodes);
    network(:,index)=zeros(nodes,1);
end

%%
attackednet=network;

end