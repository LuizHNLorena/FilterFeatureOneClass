classdef InformationScore
    
    methods(Static)
        
        function [finalRank] = execute(datasetName)
           
            % Load Data
            dataset = load (datasetName);      
            
            % Dataset total columns
            columns = size(dataset,2);
            
            % Normalize the dataset
            normalizedDataset = InformationScore.MinMaxScaling(dataset);         
            
            % STEP 1)
            % Entropy for the dataset with all atributes
            
            % Create a similarity matrix using RBF kernel function 
            similarityMatrix = InformationScore.constructRBF(normalizedDataset);
            newSimilarityMatrix = 0.5 + (similarityMatrix/2);
            totalEntropy = - InformationScore.calculateEntropy(newSimilarityMatrix);
            
            % STEP 2)
            % Evaluating each attribute contribution to entropy
            solution(1:columns)=0;
            for i = 1:columns
                if(i==1)
                    finalMatrix= normalizedDataset(:,2:columns);   
                elseif(i==columns)
                    finalMatrix = normalizedDataset(:,1:columns-1);   
                else
                    leftMatrix  = normalizedDataset(:,1:i-1);
                    rightMatrix = normalizedDataset(:,i+1:columns);
                    finalMatrix = [leftMatrix rightMatrix];
                end
                similarityMatrix = InformationScore.constructRBF(finalMatrix);
                newSimilarityMatrix = 0.5 + (similarityMatrix/2); 
                entropy = - InformationScore.calculateEntropy(newSimilarityMatrix);
                solution(i)=totalEntropy-entropy;
            end
            
            % Obtaining the rank
            [~,finalRank] = sort(solution,'ascend');
            
            clearvars columns similarityMatrix newSimilarityMatrix finalMatrix leftMatrix rightMatrix solution entropy totalEntropy; 
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
        
        % function [K] = RBFKernel(X,rbf_var)
        %   X - each row is an instance
        %   rbf_var - the variance
        function [K] = constructRBF(X, rbf_var)
            XP = sum((X.^2),2);   
            tmpW = XP*ones(1,length(XP)) - 2*(X*X') + ones(length(XP),1)*XP';
            clearvars XP X;
            if nargin < 2
                rbf_var = prctile(tmpW(tmpW>0),20)^0.5;
            end
            tmpW = (tmpW+tmpW')/2;
            K = exp( -1/(rbf_var^2)*  tmpW );
        end 
        
        % function [entropy] = calculateEntropy(X)
        %   X - each row is an instance
        function [entropy] = calculateEntropy(X)
            [rows,columns]=size(X);
            entropy=0;
            for row = 1:rows
                for  column = 1:columns
                    if(X(row,column)~=1)
                        entropy = entropy + X(row,column)*log2(X(row,column))+(1-X(row,column))*log2(1-X(row,column));
                    end
                end
            end
        end   
    end
end