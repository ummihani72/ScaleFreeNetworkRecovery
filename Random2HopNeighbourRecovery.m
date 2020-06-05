%%
% Purpose:
% The Random2HopNeighbourRecovery m-file is used to simulate a system recovery.
% The method used in this algorithm is random 2 hop neighbour recovery. This
% means that affected neighbours of the attacked hubs randomly chooses a 2 hop
% neighbour. These nodes then forms a new link. This process continues 
% until a percentage of the affected neighbours has completed the recovery
% process. 

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

% hubsidentity - matrix
%              - This specify which nodes are the hubs of the scale free
%              network. The first row indicates the nodal degree of the hubs 
%              and the second row inicates the indexes of these hubs located 
%              in the scale free network.
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

function [RecoveredNet,RecoveredNetworkGraph,linkcount]=Random2HopNeighbourRecovery(SFNetwork, attackednet, recoveryrate, hubsidentity)
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
linkcount=0;
numhubs=length(hubsidentity);

%% Determining the two nodes to be used for recovery 
for aa=1:numhubs
    % Identify index of the hub
    affectedhubindex=hubsidentity(2,aa);
    
    % Determining the neighbours of the hub
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

    for cc=1:recoverednumneighbours
        % Index of the neighbour
        neighbourindex=finalneighbourindex(cc);
        
        % Choosing another random neighbour
        rneighbour=neighbourindex;
        numtwohopneighbour=0;
        loopcount=0;
        while rneighbour==neighbourindex || numtwohopneighbour==0
            rindex1=randi(finalnumneighbours);
            rneighbour=finalneighbourindex(rindex1);
            
            % Find valid two hop neighbour
            twohopneighbour=find(attackednet(rneighbour,:));
            numtwohopneighbour=length(twohopneighbour);
            
            loopcount=loopcount+1;
            if loopcount > finalnumneighbours % Exit while loop if all nodes are checked
                break;
            end
        end
        
        if loopcount > finalnumneighbours % Exit for loop if all nodes are checked
            continue;
        end
        
        % Check if the chosen two hop neighbour is actually the chosen neighbour as well
        if length(twohopneighbour)==1
            if twohopneighbour==neighbourindex
                continue;
            end
        end
        
        % Choosing two hop neighbour
        rtwohop=neighbourindex;
        while rtwohop==neighbourindex
            rindex2=randi(length(twohopneighbour));
            rtwohop=twohopneighbour(rindex2);
        end

%% Simulating recovery
        % Create a new link between the two random neighbours
        if RecoveredNet(neighbourindex,rtwohop)~=1 && RecoveredNet(rtwohop,neighbourindex)~=1
            RecoveredNet(neighbourindex,rtwohop)=1;
            RecoveredNet(rtwohop,neighbourindex)=1;
            linkcount=linkcount+1;
            
            % Add link into network graph
            RecoveredNetworkGraph=addedge(RecoveredNetworkGraph,neighbourindex,rtwohop);
        end
    end
end
end