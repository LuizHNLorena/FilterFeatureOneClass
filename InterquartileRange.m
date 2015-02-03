classdef InterquartileRange
    
    methods(Static)
        
        function [finalRank] = execute(datasetName)
            
            % Load Data
            dataset = load (datasetName);      
            
            % Dataset total columns
            columns = size(dataset,2);
            
            % Normalize the dataset
            normalizedDataset = InterquartileRange.MinMaxScaling(dataset);         
                        
            % Evaluating each individual atribute
            columnIterquartile = zeros(1,columns);
            for column = 1:columns
                columnIterquartile(column) = iqr (normalizedDataset(:,column));
            end
   
            % Obtaining the rank
            [~,finalRank] = sort(columnIterquartile,'ascend');
   
            clearvars columns columnIterquartile; 
            
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