%%
% Purpose:
% The PlotAttackedNetworkGraph m-file is used to plot a figure that is able to give
% a more visual understanding of the network after it is attacked. The
% visuals will help to understand the fragmentation of the network as the
% clusters are easily identified.

%%
% Input Parameters:
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
% Output Parameters:
% attackednetworkbins   - array
%                       - This classifies which cluster each node from the
%                       attacked network belongs to. 

% clusterinfo           - matrix
%                       - This shows how many nodes are connected within
%                       one cluster. 

% attackednetworkgraph  - graph
%                       - This is a graph of the network's nodes and links
%                       after it is being attacked. It is used to plot a 
%                       visual representation of the attacked network. 

function [attackednetworkbins,clusterinfo,attackednetworkgraph]=PlotAttackedNetworkGraph(attackednet, hubsidentity)

network=attackednet;

% Remove hubs from the attacked network
nodestoremove=sort(hubsidentity(2,:),'descend');
for aa=1:length(nodestoremove)
    network(nodestoremove(aa),:)=[];
    network(:,nodestoremove(aa))=[];
end

% Initialise variables for network graph
networklength=length(network);
source=[];
target=[];
for ii=1:networklength
    for jj=1:networklength
        if network(ii,jj)==1
            source(end+1)=ii;
            target(end+1)=jj;
            network(ii,jj)=0;
            network(jj,ii)=0;
        end
    end
end

%% Plotting fragmented network visualization after simulated attack
G = graph(source,target);
figure;
plot(G);
title('Fragmented Scale Free Network');

%%
% Identify which cluster the remaining network belongs to
attackednetworkbins = conncomp(G);

% Analyse clusters and its size
clusterinfo = zeros(2,max(attackednetworkbins));
clusterinfo(1,:)=1:max(attackednetworkbins);
for cc=1:length(attackednetworkbins)
    clusterinfo(2,attackednetworkbins(cc))=clusterinfo(2,attackednetworkbins(cc))+1;
end

attackednetworkgraph=G;

end
