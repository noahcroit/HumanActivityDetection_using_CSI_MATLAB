%% Create data set for machine learning 

% Read .csv file of data set
% filename = 'data_for_ML_sleep.csv';
% filename = 'ecoli.csv';
filename = 'feature_of_csi (jok) - labeled.csv';

% Partition a data for training set and testing set
numberOfTrain = 80;
[feature_data_train, output_data_train, feature_data_test, output_data_test, numberOfTest] = CreateDataPartition_Excel_NoAttrName(filename, numberOfTrain);



%% Re-label the binary output (N, P) as [-1, 1] 
%  This section only apply to the data which is for the binary classification problem.
for n = 1:numberOfTrain
    if output_data_train(n) == 'J'
        output_data_train(n) = 1;
    elseif output_data_train(n) == 'N'
        output_data_train(n) = -1;
    else
        output_data_train(n) = 0;
    end
end
for n = 1:numberOfTest
    if output_data_test(n) == 'J'
        output_data_test(n) = 1;
    elseif output_data_test(n) == 'N'
        output_data_test(n) = -1;
    else
        output_data_test(n) = 0;
    end
end


%% Preprocessing the data

% Normalization : train data
feature_normalized_data_train = Preprocess_Normalization(feature_data_train);

% Normalization test data
feature_normalized_data_test = Preprocess_Normalization(feature_data_test);



%% Initialize and training to all candidated machine learning model
% Candidated N-models are created with a different SVM parameters in order to select
% the "best model" from N models

% Initialize the candiated model
N = 9;
modelList = cell(N, 1);
modelList{1} = CreateModel_SVM(feature_data_train, output_data_train, [-1, 1], 'rbf', 0.25);
modelList{2} = CreateModel_SVM(feature_data_train, output_data_train, [-1, 1], 'linear', 0.25);
modelList{3} = CreateModel_SVM(feature_data_train, output_data_train, [-1, 1], 'polynomial', 0.25);
modelList{4} = CreateModel_SVM(feature_data_train, output_data_train, [-1, 1], 'rbf', 0.55);
modelList{5} = CreateModel_SVM(feature_data_train, output_data_train, [-1, 1], 'linear', 0.55);
modelList{6} = CreateModel_SVM(feature_data_train, output_data_train, [-1, 1], 'polynomial', 0.55);
modelList{7} = CreateModel_SVM(feature_data_train, output_data_train, [-1, 1], 'rbf', 0.85);
modelList{8} = CreateModel_SVM(feature_data_train, output_data_train, [-1, 1], 'linear', 0.85);
modelList{9} = CreateModel_SVM(feature_data_train, output_data_train, [-1, 1], 'polynomial', 0.85);



%% Cross validation for select the best model
% Initialize the cross validation method, parameters and data partition for validation

cv_method = 'KFold';
numberOfObservation = numberOfTrain;
k = 10;
cv_partition = cvpartition(numberOfObservation, cv_method, k);

% Find loss function of each candidated ML model by using cross-validation 
loss = zeros(N, 1);
for m = 1:N
    % Select the candidated ML model
    candidatedModel = modelList{m};
    
    % Apply cross-validation to SVM model 
    CV_model = crossval(candidatedModel, 'CVPartition', cv_partition);
    
    loss(m) = kfoldLoss(CV_model);
end

% Select the best ML model
[min_loss, min_loss_index] = min(loss);
model_best = modelList{min_loss_index};
         
                        
                        
%% Test the resulted ML model with a different data set (test data)

predictOutput = predict(model_best, feature_data_test);
pass_count = 0;
fail_count = 0;
for n = 1 : length(predictOutput)
    if (predictOutput(n) == str2double(output_data_test(n)))
        pass_count = pass_count + 1;
    else
        fail_count = fail_count + 1;
    end
end
disp('best loss = ');
disp(min_loss);
disp('pass count = ');
disp(pass_count);
disp('fail count = ');
disp(fail_count);




