function normalizedData = Preprocess_Normalization(InputData)
    
%     %% This normalization use a "Standardization (Z-score)" method as this equation
%     % : x_norm = (x - x_mean)/STD
%     scalingFactor = 0.5;
%     x_mean = mean(InputData);
%     STD  = std(InputData);
%     [r, c] = size(InputData);
%     normalizedData = scalingFactor.*(InputData - ones(r, c).*x_mean)./STD;
    
    %% This normalization use a "Maximum Divider" method
    scalingFactor = 0.5;
    x_max = max(abs(InputData));
    normalizedData = scalingFactor.*(InputData./x_max);
    
end