function [trainInput, trainOutput, testInput, testOutput, testSize] = CreateDataPartition_Excel_NoAttrName(filename, trainSize)

    % Read data from the given file's name
    % Note : The format of .csv file must be like this.
    % _____________________________________________________________________
    %       Output Label (Class)    |   Input Data[0] ... Input Data[N]
    %                               |
    %                               |
    [num, txt, raw] = xlsread(filename);
    % r => dimension of input vector (or feature vector)
    % c => size of data set
    [r, c] = size(raw);
    
    % Randomize the data set before partition
    for i = 1 : 3
        random_index = randperm(r);
        raw = raw(random_index, :);
        txt = txt(random_index, :);
        num = num(random_index, :);
    end
    
    % Partition a data for training set and testing set as below...
    % ----------------------------------------|----------------------------
    %             Train set                   |         Test set
    %----------------------------------------------------------------------
    testSize      = r - trainSize;
    trainInput    = num(1 : trainSize,   :);
    testInput     = num(trainSize+1 : r, :);
    trainOutput   = txt(1 : trainSize  , 1);
    testOutput    = txt(trainSize+1 : r, 1); 
    trainOutput = string(trainOutput);
    testOutput = string(testOutput);
end