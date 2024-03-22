clc
clear
load('YPRED_5')
load('foldIndexes.mat')

load("Final.mat"); 
F=Final;


external=Final(18037:end,:);
E=external;
[m, ~] = size(external);
predictionsAdjusted=zeros(m,1);
for j=1:5
predictionsAdjusted(foldIndexes{j})=out{j};

end
YPRED=predictionsAdjusted;
 save('YPRED.mat', 'YPRED');




       