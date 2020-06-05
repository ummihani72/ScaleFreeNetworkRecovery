%%
% Purpose:
% The HighlightNetworkHub m-file is used to plot a figure that is able to give
% a more visual understanding based on the matrix of a network structure.
% In addition to this, the largest hub in the network is being highlighted.

%%
% Input Parameters:
% SFNetwork    - matrix
%              - This is a structure of the Scale Free Network produced. It 
%              shows the relationship of all the nodes and show the links 
%              between the nodes.   

function HighlightNetworkHub(SFNetwork)
%% Determining the network's connections
network=SFNetwork;
networklength=length(network);
source=[];
target=[];

%% Determine network graph parameters
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

connections = single(sum(SFNetwork));
[maxnodedegree,index]=max(connections);
hubsource=[];
hubtarget=[];
for ii=1:length(source)
    if source(ii)==index
        hubsource(end+1)=source(ii);
        hubtarget(end+1)=target(ii);
    elseif target(ii)==index
        hubsource(end+1)=source(ii);
        hubtarget(end+1)=target(ii);
    end
end

%% Plotting network's topology with the largest hub highlighted
G=graph(source,target);
figure;
plot(G);
g=plot(G,'Layout','force');
highlight(g,hubsource,hubtarget);
highlight(g,index,'NodeColor','g');
highlight(g,hubsource,hubtarget,'EdgeColor','g');
title('Largest Hub in the Network');

end