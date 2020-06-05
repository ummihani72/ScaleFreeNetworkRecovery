%%
% Purpose:
% The PlotGraphSFNetwork m-file is used to plot the degree distribution of
% the scale free network on a log scale graph. 

%%
% Input Parameters:
% SFNetwork    - matrix
%              - This is a structure of the Scale Free Network produced. It 
%              shows the relationship of all the nodes and show the links 
%              between the nodes.   

% nodes        - integer
%              - The desired network size, including the seed network size 
%              (i.e. Nodes minus seed network size equals the number of 
%              nodes to be added).

%% 
% Output Parameters:
% grad         - double
%              - This is the calculated gradient value of the best fit
%              curve in the log scale graph. This value corresponds to the
%              gamma value in the power law equation that scale free
%              network obeys. Refer to equation 4 in the report.

% plotvariables- matrix
%              - This is the x and y values of the log scale degree
%              distribution graph of the scale free networks. The x values
%              refer to the number of links a node has and the y values
%              refer to number of nodes.

function [grad, plotvariables] = PlotGraphSFNetwork(SFNetwork, nodes)
%% Initialize arrays for data collection    
% Initialize array that will hold how many nodes have each degree
frequency = single(zeros(1,length(SFNetwork)));

% Initialize array that will hold the graphing quanitites
nodaldegree=[];

% Finds out how many connections each node has
connections = single(sum(SFNetwork));

%% collecting data from the original SFNetwork
% Getting frequency array
for ii = 1:nodes
    if connections(1,ii) ~= 0
        frequency(1,connections(1,ii)) = frequency(1,connections(1,ii)) + 1; % Increment
    end
end

% Getting nodal degree array
jj=1;
for ii = 1:length(frequency)
    if frequency(1,ii) ~= 0           % Disregard nodal degrees with no frequency
       nodaldegree(jj)=ii;            % Degrees of nodes in SFNetwork
       jj=jj+1;
    end
end
frequency=nonzeros(frequency)';
plotvariables=[nodaldegree;frequency];

%% plotting original scale free network graph (log scale)
% Plot the number of nodes vs number of links on a log scale
x = nodaldegree;
y = frequency;
figure();
SFGraph = loglog(x,y,'r+');

% Setting limits on x and y axis
xlim([.9 (max(sum(SFNetwork)) + 10)]);
ylim([.9 length(SFNetwork)]);

% Labelling of graph
SFGraph = xlabel('Number of links');
SFGraph = ylabel('Number of Nodes');
SFGraph = title('Generated Scale Free Network - Log Scale');

% Calculating equation constants
hold on;
coefficients = polyfit(log(x), log(y), 1);
m = coefficients(1);
k = coefficients(2);
BestFitLine=x.^m.*exp(k);

% Plot best fit line
SFGraph = loglog(x,BestFitLine);
hold off;

% Calculate gradient of best fit line
grad = (log(BestFitLine(2))-log(BestFitLine(1)))/(log(x(2))-log(x(1)));

end