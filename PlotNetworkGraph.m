%%
% Purpose:
% The PlotNetworkGraph m-file is used to plot a figure that is able to give
% a more visual understanding based on the matrix of a network structure

%%
% Input Parameters:
% SFNetwork    - matrix
%              - This is a structure of the Scale Free Network produced. It 
%              shows the relationship of all the nodes and show the links 
%              between the nodes.   

function PlotNetworkGraph(SFNetwork)
%% Initialize variables
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

%% Plotting network's topology
G=graph(source,target);
figure;
plot(G,'Layout','force');
title('Network Graph');

end