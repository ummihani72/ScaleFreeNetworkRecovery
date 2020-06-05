%%
% Purpose: 
% The AttackSimulationID m-file is used to simulate an intentional attack on 
% a Scale Free Network. It is done by the removal of the hubs 
% in the network that were identified according to the network's initial topology. 
% The type of attack simluated is called the intial degree attack. 

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
%                 - This refers to the percentage of the total nodes that
%                 needs to be removed
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
function [attackednet,hubsidentity] = AttackSimulationID(SFNetwork, nodes, fractionremoved)

% Calculate number of nodes to attack
numtoattack=ceil(fractionremoved*nodes);

% Finds out how many connections each node has
connections = single(sum(SFNetwork));

% Identifying all the hubs to be removed
hubsidentity=zeros(2,numtoattack);
for ii=1:numtoattack
    [maxnodedegree,index]=max(connections);
    hubsidentity(1,ii)=maxnodedegree;
    hubsidentity(2,ii)=index;
    connections(:,index)=0;
end
    
% Attacking all the hubs
attackednet = SFNetwork;
for ii=1:numtoattack
    attackednet(hubsidentity(2,ii),:)= zeros(1,nodes);
    attackednet(:,hubsidentity(2,ii))= zeros(nodes,1);
end

end
