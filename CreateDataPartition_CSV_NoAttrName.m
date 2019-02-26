function [trainInput, trainOutput, testInput, testOutput, testSize] = CreateDataPartition_CSV_NoAttrName(filename, trainSize)

    % Read data from the given file's name
    % Note : The format of .csv file must be like this.
    % _____________________________________________________________________
    %       Output Label (Class)    |   Input Data[0] ... Input Data[N]
    %                               |
    %                               |
    raw = csvread(filename);
    % r => dimension of input vector (or feature vector)
    % c => size of data set
    [r, c] = size(raw);
    
    % Randomize the data set before partition
    for i = 1 : 3
        random_index = randperm(r);
        raw = raw(random_index, :);
    end
    
    % Partition a data for training set and testing set as below...
    % ----------------------------------------|----------------------------
    %             Train set                   |         Test set
    %----------------------------------------------------------------------
    testSize      = r - trainSize;
    trainInput    = raw(1 : trainSize,   2:c);
    testInput     = raw(trainSize+1 : r, 2:c);
    trainOutput   = raw(1 : trainSize  , 1);
    testOutput    = raw(trainSize+1 : r, 1);  

end