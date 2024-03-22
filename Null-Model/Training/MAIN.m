clc
clear

load("Final.mat"); 
F=Final;

external=Final(18037:end,1:1389);
E=external;
stanford=Final(1:18036,1:1389);
ms=5;
[rows, ~] = size(external);
numFolds = 5;
foldIndices = crossvalind('Kfold', rows, numFolds);

foldIndexes = cell(numFolds, 1);

for k = 1:numFolds
    foldIndexes{k} = find(foldIndices == k);
end

Xtrain = cell(numFolds, 1); 
Ytrain = cell(numFolds, 1); 
Xtest = cell(numFolds, 1);
Ytest = cell(numFolds, 1);
out = cell(numFolds, 1);
for m = 1:numFolds
    disp(m)
    external = E;   
    testFoldIndex = foldIndexes{m,1}; 
    Test=external(testFoldIndex,:);
    Xtest{m}=Test(:,2:end);
    Ytest{m}=Test(:,1);

    trainData = [stanford; external]; 
    
    Xtrain{m}= trainData(:, 2:end); 
    Ytrain{m} = trainData(:, 1); 

    out{m} = training(Xtrain{m}, Ytrain{m},Xtest{m},Ytest{m}, ms,m);
end

save('YPRED5.mat','out')
save('foldIndexes.mat','foldIndexes')
