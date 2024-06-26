function [Accuracy,Sensitivity,Specifity,Precision,Recall,F1_score]=class_perform(YP,YD)

PS=length(find(YD==1));
NS=length(find(YD==0));
TP=0;TN=0;
for i=1:length(YD)
   
    if YD(i)==1 && YP(i)==1
        TP=TP+1;
        
    elseif YD(i)==0 && YP(i)==0 
        TN=TN+1;
        
    end
    
end
Accuracy=length(find(YP-YD==0))./length(YD);
Sensitivity=TP/PS;
Specifity=TN/NS;

Precision = TP / (sum(YP==1));
Recall= TP / (sum(YD==1));
F1_score=2.*(Precision.*Recall)./(Precision+Recall);
end

    