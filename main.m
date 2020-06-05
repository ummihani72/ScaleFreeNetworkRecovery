
close all
clc

%%
% Initialize
% seed =[0 1 0 0 1;1 0 0 1 0;0 0 0 1 0;0 1 1 0 0;1 0 0 0 0];
% nodes = 2000;
% mlinks = 2;

%% Implementing BA model 
% % Create SFNetwork
% SFNetwork = CreateSFNetwork(nodes, mlinks, seed);
% 
% % Analysis of  generated SFNetwork
% [grad, plotvariables] = PlotGraphSFNetwork(SFNetwork, nodes);
% PlotNetworkGraph(SFNetwork);
% HighlightNetworkHub(SFNetwork)
% 
% % Calculate initial mean degree
% connections = single(sum(SFNetwork));
% initialmeandegree=sum(connections)/nodes;
% fprintf('The mean degree <k> of the generated scale free \n network is %.2f \n\n',initialmeandegree);

%% Initial Degree Attack (ID)
fprintf('Start ID Attack Simulation - > \n\n');
fractionremoved=0.13;
nodesleft=(1-fractionremoved)*nodes;
% Run attack simulation on the SFNetwork
[attackednetID, hubsidentityID] = AttackSimulationID(SFNetwork, nodes, fractionremoved);

% Analysis of attacked SFNetwork
[attackednetworkbinsID,clusterinfoID,attackednetworkgraphID]=PlotAttackedNetworkGraph(attackednetID, hubsidentityID);

%% Print ID attack results
% Calculating number of remaining clusters
numclustersID=length(clusterinfoID);
fprintf('Fraction f = %.2f \n',fractionremoved);
fprintf('There are %d clusters in the fragmented \n network after the ID attack\n',numclustersID);

% Calculate mean degree after ID attack
connectionsID = single(sum(attackednetID));
attackednetIDmeandegree = sum(connectionsID)/length(attackednetworkbinsID);
fprintf('The mean degree <k> of the network after \n the ID attack is is %.2f \n',attackednetIDmeandegree);

% Calculate largest cluster size after ID attack
largestclusterID=max(clusterinfoID(2,:));
perlargestclusterID=largestclusterID/nodesleft*100;
fprintf('The size of the largest cluster contains %d nodes \n which is %.2f percent of the remaining network \n\n',largestclusterID,perlargestclusterID);

%% Recovery of ID attack using global-global random recovery
% [RecoveredNetID,RecoveredNetworkGraphID,linkcountID]=RandomGlobalGlobalRecovery(SFNetwork,attackednetID,attackednetworkgraphID);
% 
% figure();
% plot(RecoveredNetworkGraphID);
% title('Recovered Network Graph After ID Attack - Random Global Global Recovery');
% 
% remainingnodes=nodes-(fractionremoved*nodes);
% meandegreerecoveredID=sum(sum(RecoveredNetID))/remainingnodes;
% [gradID, plotvariablesID] = PlotGraphSFNetwork(RecoveredNetID, remainingnodes);

%% Recovery of ID attack using neighbour-global random recovery
fprintf('Recovery of ID attack using neighbour-global random recovery\n');
clusterresultsID=zeros(2,10);
for aa=1:10
    recoveryrate=aa/10;
    [RecoveredNetID,RecoveredNetworkGraphID,linkcountID]=RandomNeighbourGlobalRecovery(SFNetwork,attackednetID,recoveryrate,hubsidentityID);

    [RecoveredNetworkbinsID,clusterinfoID,RecoveredNetworkGraphID]=PlotAttackedNetworkGraph(RecoveredNetID, hubsidentityID);

    fprintf('There are %d clusters and the largest cluster \n size is %d \n\n',length(clusterinfoID),max(clusterinfoID(2,:)));
    clusterresultsID(1,aa)=length(clusterinfoID);
    clusterresultsID(2,aa)=max(clusterinfoID(2,:))/nodesleft*100;
end

figure();
xID1=0:10:100;
yID1=[perlargestclusterID clusterresultsID(2,:)];
plot(xID1,yID1,'-o');
ylim([0 100]);
title('Largest Cluster Size in ID Attacked Network');
xlabel('Recovery Rate (%)');
ylabel('Largest Cluster Size(%)');

%% Recovery of ID attack using random neighbour-neighbour recovery
fprintf('Recovery of ID attack using random neighbour-neighbour recovery\n');
clusterresultsID=zeros(2,10);
for cc=1:10
    recoveryrate=cc/10;
    [RecoveredNetID,RecoveredNetworkGraphID,linkcountID]=RandomNeighbourNeighbourRecovery(SFNetwork, attackednetID, recoveryrate, hubsidentityID);
    
    [RecoveredNetworkbinsID,clusterinfoID,RecoveredNetworkGraphID]=PlotAttackedNetworkGraph(RecoveredNetID, hubsidentityID);
    
    fprintf('There are %d clusters and the largest cluster \n size is %d \n\n',length(clusterinfoID),max(clusterinfoID(2,:)));
    clusterresultsID(1,cc)=length(clusterinfoID);
    clusterresultsID(2,cc)=max(clusterinfoID(2,:))/nodesleft*100;
end

figure();
xID2=0:10:100;
yID2=[perlargestclusterID clusterresultsID(2,:)];
plot(xID2,yID2,'-o');
ylim([0 100]);
title('Largest Cluster Size in ID Attacked Network');
%% Recovery of ID attack using 2 hop neighbour random recovery
fprintf('Recovery of ID attack using 2 hop neighbour random recovery\n');
clusterresultsID=zeros(2,10);
for ee=1:10
    recoveryrate=ee/10;
    [RecoveredNetID,RecoveredNetworkGraphID,linkcountID]=Random2HopNeighbourRecovery(SFNetwork, attackednetID, recoveryrate, hubsidentityID);
    
    [RecoveredNetworkbinsID,clusterinfoID,RecoveredNetworkGraphID]=PlotAttackedNetworkGraph(RecoveredNetID, hubsidentityID);
    
    fprintf('There are %d clusters and the largest cluster \n size is %d \n\n',length(clusterinfoID),max(clusterinfoID(2,:)));
    clusterresultsID(1,ee)=length(clusterinfoID);
    clusterresultsID(2,ee)=max(clusterinfoID(2,:))/nodesleft*100;
end

figure();
xID3=0:10:100;
yID3=[perlargestclusterID clusterresultsID(2,:)];
plot(xID3,yID3,'-o');
ylim([0 100]);
title('Largest Cluster Size in ID Attacked Network');
xlabel('Recovery Rate (%)');
ylabel('Largest Cluster Size(%)');
%     
%% Recalculated Degree Attack (RD)
fprintf('Start RD Attack Simulation - > \n\n');
[attackednetRD,hubsidentityRD] = AttackSimulationRD(SFNetwork, nodes, fractionremoved);

% Analysis of attacked SFNetwork
[attackednetworkbinsRD,clusterinfoRD,attackednetworkgraphRD]=PlotAttackedNetworkGraph(attackednetRD, hubsidentityRD);


%% Print RD attack results
% Calculating number of remaining clusters
numclustersRD=length(clusterinfoRD);
fprintf('Fraction f = %.2f \n',fractionremoved);
fprintf('There are %d clusters in the fragmented \n network after the RD attack\n',numclustersRD);

% Calculate mean degree after RD attack
connectionsRD = single(sum(attackednetRD));
attackednetRDmeandegree = sum(connectionsRD)/length(attackednetworkbinsRD);
fprintf('The mean degree <k> of the scale free network after \n the RD attack is %.2f \n',attackednetRDmeandegree);

% Calculate largest cluster size after RD attack
largestclusterRD=max(clusterinfoRD(2,:));
perlargestclusterRD=largestclusterRD/nodesleft*100;
fprintf('The size of the largest cluster contains %d nodes \n which is %.2f percent of the remaining network \n\n',largestclusterRD,perlargestclusterRD);

%% Recovery of RD attack using global random recovery
% [RecoveredNetRD,linkcountRD,RecoveredNetworkGraphRD]=RandomGlobalGlobalRecovery(SFNetwork,attackednetRD,attackednetworkgraphRD);
% 
% figure();
% plot(RecoveredNetworkGraphRD);
% title('Recovered Network Graph After RD Attack - Random Global Global Recovery');
% 
% meandegreerecoveredRD=sum(sum(RecoveredNetRD))/remainingnodes;
% [gradRD, plotvariablesRD] = PlotGraphSFNetwork(RecoveredNetRD,remainingnodes);

%% Recovery of RD attack using neighbour-global random recovery
fprintf('Recovery of RD attack using neighbour-global random recovery\n');
clusterresultsRD=zeros(2,10);
for bb=1:10
    recoveryrate=bb/10;
    [RecoveredNetRD,RecoveredNetworkGraphRD,linkcountRD]=RandomNeighbourGlobalRecovery(SFNetwork,attackednetRD,recoveryrate,hubsidentityRD);
    
    [RecoveredNetworkbinsRD,clusterinfoRD,RecoveredNetworkGraphRD]=PlotAttackedNetworkGraph(RecoveredNetRD, hubsidentityRD);
    
    fprintf('There are %d clusters and the largest cluster \n size is %d \n\n',length(clusterinfoRD),max(clusterinfoRD(2,:)));
    clusterresultsRD(1,bb)=length(clusterinfoRD);
    clusterresultsRD(2,bb)=max(clusterinfoRD(2,:))/nodesleft*100;
end

figure();
xRD1=0:10:100;
yRD1=[perlargestclusterRD clusterresultsRD(2,:)];
plot(xRD1,yRD1,'-o');
ylim([0 100]);
title('Largest Cluster Size in RD Attacked Network');
xlabel('Recovery Rate (%)');
ylabel('Largest Cluster Size(%)');

%% Recovery of RD attack using random recovery between neighbours
fprintf('Recovery of RD attack using random recovery between neighbours\n');
clusterresultsRD=zeros(2,10);
for dd=1:10
    recoveryrate=dd/10;
    [RecoveredNetRD,RecoveredNetworkGraphRD,linkcountRD]=RandomNeighbourNeighbourRecovery(SFNetwork, attackednetRD, recoveryrate, hubsidentityRD);
    
    [RecoveredNetworkbinsRD,clusterinfoRD,RecoveredNetworkGraphRD]=PlotAttackedNetworkGraph(RecoveredNetRD, hubsidentityRD);
    
    fprintf('There are %d clusters and the largest cluster \n size is %d \n\n',length(clusterinfoRD),max(clusterinfoRD(2,:)));
    clusterresultsRD(1,dd)=length(clusterinfoRD);
    clusterresultsRD(2,dd)=max(clusterinfoRD(2,:))/nodesleft*100;
end

figure();
xRD2=0:10:100;
yRD2=[perlargestclusterRD clusterresultsRD(2,:)];
plot(xRD2,yRD2,'-o');
ylim([0 100]);
title('Largest Cluster Size in RD Attacked Network');
xlabel('Recovery Rate (%)');
ylabel('Largest Cluster Size(%)');
%% Recovery of RD attack using 2 hop neighbour random recovery
fprintf('Recovery of RD attack using 2 hop neighbour random recovery\n');
clusterresultsRD=zeros(2,10);
for ff=1:10
    recoveryrate=ff/10;
    [RecoveredNetRD,RecoveredNetworkGraphRD,linkcountRD]=Random2HopNeighbourRecovery(SFNetwork, attackednetRD, recoveryrate, hubsidentityRD);
    
    [RecoveredNetworkbinsRD,clusterinfoRD,RecoveredNetworkGraphRD]=PlotAttackedNetworkGraph(RecoveredNetRD, hubsidentityRD);
    
    fprintf('There are %d clusters and the largest cluster \n size is %d \n\n',length(clusterinfoRD),max(clusterinfoRD(2,:)));
    clusterresultsRD(1,ff)=length(clusterinfoRD);
    clusterresultsRD(2,ff)=max(clusterinfoRD(2,:))/nodesleft*100;
end

figure();
xRD3=0:10:100;
yRD3=[perlargestclusterRD clusterresultsRD(2,:)];
plot(xRD3,yRD3,'-o');
ylim([0 100]);
title('Largest Cluster Size in RD Attacked Network');
xlabel('Recovery Rate (%)');
ylabel('Largest Cluster Size(%)');
    
    %%
fprintf('Sucess\n');