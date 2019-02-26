function [trainInput, trainOutput, testInput, testOutput, testSize] = CreateDataPartition(filename, trainSize)
    
    % Read data from the given file's name
    % Note : The format of .csv file must be like this
    % _____________________________________________________________________
    %        Input Data[0] ... Input Data[N]       | Output Label (Class)
    % _____________________________________________________________________
    %                                              |
    %                                              |
    %                                              |
    [num, txt, raw] = xlsread(filename);
    [r_raw, c_raw] = size(raw);
    txt = txt(2:r_raw, :);
    c = c_raw - 1; % dimension of input vector (or feature vector)
    r = r_raw - 1; % size of data set

    % Randomize the data set before partition
    random_index = randperm(r);
    txt = txt(random_index, :);
    num = num(random_index, :);
    
    % Partition a data for training set and testing set as below...
    % ----------------------------------------|----------------------------
    %             Train set                   |         Test set
    %----------------------------------------------------------------------
    testSize      = r - trainSize;
    trainInput    = num(1 : trainSize, :);
    testInput     = num(trainSize+1 : r, :);
    trainOutput   = txt(1 : trainSize  , c_raw);
    testOutput    = txt(trainSize+1 : r, c_raw);

end