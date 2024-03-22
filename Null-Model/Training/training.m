function [out] = training(Xtrain,Ytrain,Xtest,~,ms,fold)

allPredictions = cell(ms, 1);
Xtrain=Xtrain';
Ytrain=Ytrain';
Xtest=Xtest';
for m = 1:ms
    BESTPER = 10^5;
    predictions = cell(5, 1); 
    
    for s = 1:10
        x = Xtrain;
        t = Ytrain;
fprintf("%0.3d, %0.3d and %0.3d \n",fold,m,s)
        trainFcn = 'trainscg';  
        hiddenLayerSize = 5;
        net = fitnet(hiddenLayerSize, trainFcn);
        net.input.processFcns = {'mapminmax'};
        net.divideParam.trainRatio = 90/100;
        net.divideParam.valRatio = 0/100;
        net.divideParam.testRatio = 10/100;
        net.trainParam.min_grad = 10^-10;
        net.trainParam.epochs = 500;
        net.trainParam.showWindow = 0;
        [net,tr] = train(net,x,t,'useParallel','yes');

        y = net(x);
        e = gsubtract(t,y);
        performance = perform(net,t,y);

        trainTargets = t .* tr.trainMask{1};
        valTargets = t .* tr.valMask{1};
        testTargets = t .* tr.testMask{1};

        testPerformance = perform(net,testTargets,y);

        if testPerformance < BESTPER
            BESTPER = testPerformance;
            BESTNET = net;
            predictions = net(Xtest); 
        end   
        
    end
     
    allPredictions{m} = predictions;
   
end

out = allPredictions{1}; 
numSamples = length(out); 

for k = 2:ms 
    out = out + allPredictions{k}; 
end

out = out / ms; 
end