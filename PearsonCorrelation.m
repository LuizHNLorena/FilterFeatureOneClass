classdef PearsonCorrelation
   
    methods(Static)
        function [finalRank] = execute(datasetName)
            
            % Load Data
            dataset = load (datasetName);      
            
            % Dataset total columns
            columns = size(dataset,2);
            
            % Normalize the dataset
            normalizedDataset = PearsonCorrelation.MinMaxScaling(dataset);
            
            % Applying Pearson
            [RHO] = corr(normalizedDataset);
    
            % Evaluating each individual atribute
            pearsonSum = zeros(1,columns);
            for column=1:columns
                curRHO = RHO(:,column);
                pearsonSum(column) = sum(abs(curRHO))-1;
            end
            
            % Obtaining the rank
            [~,finalRank] = sort(pearsonSum,'ascend');
            
            clearvars RHO curRHO columns pearsonSum;
        end
        
        % MinMaxScaling: Function to Normalize values using Min-Max Scaling
        %                  x'=(x-x_min)/(x_max-x_min)
        function [ X ] = MinMaxScaling( X )
            [rows,columns]=size(X);
            for  column = 1:columns
                curX = X(:,column);
                minX = min(curX);
                maxX = max(curX);
                for row = 1:rows
                    if maxX == minX
                        X(row,column) = 0;
                    else
                        X(row,column) = (X(row,column) - minX)/(maxX - minX);      
                    end
                end
           end
        end
    end
    
end