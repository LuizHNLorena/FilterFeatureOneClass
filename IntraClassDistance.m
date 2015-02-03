classdef IntraClassDistance
   
    methods(Static)    
        
        function [finalRank] = execute(datasetName)
            
            % Load Data
            dataset = load (datasetName);      
            
            % Normalize the dataset
            normalizedDataset = IntraClassDistance.MinMaxScaling(dataset);
            
            % Dataset total rows and columns
            [rows,columns] = size (dataset); 
            
            % Vector that stores the mean value for each column
            columnMean = mean(normalizedDataset);
            
            % Computing the Euclidian distance - part 1
            distances = zeros(1,columns);
            for column = 1:columns
                distances(column)=0;
                for row = 1: rows
                    distances(column) = distances(column) + (columnMean(column) - normalizedDataset(row,column))^2;
                end
            end
            
            % Computing the Euclidian distance - part 2
            distances = sqrt(distances);
            
            % Sum of the distance of each column
            globalDistance = sum(distances);
            
            % The following steps simulate the removal of each individual atribute(column)
            % (2 steps)
            
            % (step 1) Distance without tail columns
            best = zeros(1,columns);
            for column = 1:columns
                if column > 1
                    best(1) = best(1) + distances(column);
                end
                if column < columns
                    best(columns) = best(columns) + distances(column);
                end
            end

            % (step 2) Distance without intermediate columns
            for column = 2:columns-1
                for i = 1:column-1
                    best(column) = best(column) + distances(i);
                end
                for i = column+1:columns
                    best(column) = best(column) + distances(i);
                end
            end

            % Check if with all columns is better than with less
            check = 0;
            for column = 1:columns
                if best(column) < globalDistance
                    check = 1;
                    break;
                end
            end
            
            if check == 1
                [~,finalRank] = sort(best,'ascend');
            else    
                finalRank = linspace(1,columns,columns);
            end
            
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