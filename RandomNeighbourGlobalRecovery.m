%%
% Purpose:
% The RandomNeighbourGlobalRecovery m-file is used to simulate a system recovery.
% The method used in this algorithm is random neighbour-global recovery. This
% means that affected neighbours of the attacked hubs randomly chooses another 
% node from the network. These nodes then forms a new link. This process  
% continues until a percentage of the affected neighbours has completed the 
% recovery process. 

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

% recoveryrate - double
%              - This is the percentage of the affected nodes that are
%              expected to successfully recover. 
%%
% Output Parameters:
% RecoveredNet - matrix
%              - This is the structure of an attacked network after   
%              simulating a system recovery. It shows the relationship
%              between the remaining nodes and links, which also includes 
%              the newly formed links.

% RecoveredNetworkGraph - graph
%                       - This is a graph of the network's nodes and links
%                      after going through the recovery simulation. It is 
%                      used to plot a visual representation of the recovered 
%                      network. 

% linkcount    - integer
%              - This indicates the number of new links formed during the
%              recovery process.

function [RecoveredNet,RecoveredNetworkGraph,linkcount]=RandomNeighbourGlobalRecovery(SFNetwork,attackednet,recoveryrate,hubsidentity)
%% Determine network graph parameters
network=attackednet;
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

%% Initialize variables
RecoveredNet=attackednet;
RecoveredNetworkGraph=graph(source,target); %full size network graph
numhubs=length(hubsidentity);
linkcount=0;

for aa=1:numhubs
%% Determining the two nodes to be used for recovery 
    % Identify index of the hub
    affectedhubindex=hubsidentity(2,aa);
    
    % Identify the neighbours of the hub
    intialconnections=SFNetwork(affectedhubindex,:);
    attackedconnections=attackednet(affectedhubindex,:);
    neighbourlinks=intialconnections-attackedconnections;
    initialneighbourindex=find(neighbourlinks);
    initialnumneighbours=length(initialneighbourindex);
    
    % Remove other hubs who happen to be neighbours as well
    finalneighbourindex=initialneighbourindex;
    for bb=1:initialnumneighbours
        if ismember(finalneighbourindex(bb),hubsidentity(2,:))
            finalneighbourindex(bb)=0;
        end
    end
    finalneighbourindex=nonzeros(finalneighbourindex)';
    finalnumneighbours=length(finalneighbourindex);
    recoverednumneighbours=ceil(recoveryrate*finalnumneighbours);

%% Simulating recovery
    for cc=1:recoverednumneighbours
        % Index of the affected neighbour
        neighbourindex=finalneighbourindex(cc);
        
        % Choosing a random global node
        rnode=randi(length(RecoveredNet));
        while RecoveredNet(neighbourindex,rnode)==1 && RecoveredNet(rnode,neighbourindex)==1 && ismember(rnode,hubsidentity(2,:))
            rnode=randi(length(RecoveredNet));
        end

        % Create new link between the chosen nodes
        RecoveredNet(neighbourindex,rnode)=1;
        RecoveredNet(rnode,neighbourindex)=1;
        linkcount=linkcount+1;
        
        % Add link into network graph
        RecoveredNetworkGraph=addedge(RecoveredNetworkGraph,neighbourindex,rnode);
    end
end
end