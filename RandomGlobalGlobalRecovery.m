%%
% Purpose:
% The RandomGlobalGlobalRecovery m-file is used to simulate a system recovery.
% The method used in this algorithm is random global-global recovery. This
% means that two previously unlinked nodes are randomly chosen. These nodes
% then forms a new link. This process continues until all fragments of the
% attacked network are reconnected. 

%%
% Input Parameters:
% SFNetwork    - matrix
%              - This is a structure of the Scale Free Network produced. It 
%              shows the relationship of all the nodes and show the links 
%              between the nodes. 

% attackednet  - matrix
%              - This is a structure of the Scale Free Network after it the
%              the hubs are sufficiently removed. It shows the relationship 
%              between the remaining nodes and links.

% attackednetworkgraph - graph
%                      - This is a graph of the network's nodes and links
%                      after it is being attacked. It is used to plot a 
%                      visual representation of the attacked network. 

%%
% Output Parameters:
% RecoveredNet - matrix
%              - This is the structure of an attacked network after   
%              simulating a system recovery. It shows the relationship
%              between the remaining nodes and links, which also includes 
%              the newly formed links.

% linkcount    - integer
%              - This indicates the number of new links formed during the
%              recovery process.

% RecoveredNetworkGraph - graph
%                       - This is a graph of the network's nodes and links
%                      after going through the recovery simulation. It is 
%                      used to plot a visual representation of the recovered 
%                      network. 

function [RecoveredNet,RecoveredNetworkGraph,linkcount]=RandomGlobalGlobalRecovery(SFNetwork,attackednet,attackednetworkgraph)
RecoveredNet=attackednet;
RecoveredNetworkGraph=attackednetworkgraph;
linkcount=0;
numclusters=0;

attackedconnections=sum(attackednet);
remainingnodes=find(attackedconnections~=0);
numremainingnodes=length(remainingnodes);

while (numclusters~=1) % Check if network is still fragmented
%% Determining the two nodes to be used for recovery    
    % Remove attacked hubs in the network matrix
    remainingattackednetID=adjacency(RecoveredNetworkGraph);
    
    % Matrix indexes of all unlinked pair of nodes in attacked network
    [row,col] = find(remainingattackednetID==0);
    row=row';
    col=col';
    
    % Choosing a random pair of unlinked nodes
    rindex=randi(length(row));
    rnode1=row(rindex);
    rnode2=col(rindex);
    row(rindex)=[];
    col(rindex)=[];
    
%% Simulating recovery
    % Create a new link between the two nodes
    if RecoveredNet(rnode1,rnode2)~=1 && RecoveredNet(rnode2,rnode1)~=1
        RecoveredNet(rnode1,rnode2)=1;
        RecoveredNet(rnode2,rnode1)=1;
        linkcount=linkcount+1;
        
        % Add link into network graph
        RecoveredNetworkGraph=addedge(RecoveredNetworkGraph,rnode1,rnode2);
        
        % Cluster count the recovered network
        recoverednetworkbins = conncomp(RecoveredNetworkGraph);
        numclusters=max(recoverednetworkbins);
    end
end
end