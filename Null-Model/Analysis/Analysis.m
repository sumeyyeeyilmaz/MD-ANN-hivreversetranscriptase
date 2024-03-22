clc
clear

load('Muts.mat')
load('map.mat')
load('YPRED.mat')
load('Morgan.mat')
load('Morgan1335.mat')


Data=readtable('External_Data.xlsx');
FC=string(Data.FoldChange);
ACT=Data.Activity;
WT=Data.WildType;
STRAIN=string(Data.Strain);
AT=string(Data.AssayType);

DC=string(Data.Drug_Compound);
IND=find( ~isnan(ACT) & ~isnan(WT) & ACT~=0);
IND2=find(~isnan(ACT) & ~isnan(WT) & ACT~=0);

for i=1:length(IND)
    if FC(IND(i))=='No'
        OUT(i)=ACT(IND(i))./WT(IND(i));
    else
        OUT(i)=ACT(IND(i));
    end
end
STR=STRAIN(IND);

red_map=[];
for e=1:512
    if sum(Morgan10(:,e))==0
        red_map=[red_map,e];
    end
end

for i=1:length(IND)
    L(i,1)=sum(Morgan(i,red_map));
end

NRM=Morgan(IND,:);
for i=1:size(NRM,1)
    for j=1:10
        TS(i,j)= tan_sim(Morgan10(j,:),NRM(i,:));
    end
end

TSS=max(TS');

W=Muts;
INP=zeros(1388,length(IND));
delind=[];
for i=1:length(IND)
    S=string(STR(i));
    S=convertStringsToChars(S);
    if i==1094
        www=2;
    end
    [V]=str_char_improved(S);
    for k=1:length(V)
        q=0;
        for j=1:1388
            if convertCharsToStrings(W{j})==convertCharsToStrings(V{k})           
                INP(j,i)=1;
                q=q+1;
            end
        end
    end
    if q~=length(V)
        delind=[delind,i];
    end
end
IND(delind)=[];
INP(:,delind)=[];
OUT(delind)=[];

e=0;
for q=1:length(IND2)
    for w=1:length(IND)
        if IND2(q)==IND(w)
            e=e+1;
            IND3(e)=w;
        end
    end
end
YPRED=YPRED(IND3);
IND=IND(IND3);
INP=INP(:,IND3);
OUT=OUT(IND3);

MORRD=Morgan(IND,map)';
FINP=[INP;MORRD];

FOUT=log10(OUT');
S=0;

res=YPRED;

Pred=log10(OUT');

INP=INP';
res=YPRED;
SI=unique(INP,'rows');

for j=1:length(IND)
    for i=1:size(SI,1)
        if norm(INP(j,:)-SI(i,:))==0
            GR(j,1)=i;
        end
    end
end

w=0;
p=0;
for i=1:size(SI,1)
    k=find(GR==i);
    if length(k)>=2
        p=p+1;
        S=0;
        RRES=YPRED;    
        ROUT=log10(OUT(k));
        Z=nchoosek(1:length(ROUT),2);
        f=0;
        for g=1:size(Z,1)
            if abs(ROUT(Z(g,1))-ROUT(Z(g,2)))>log10(2)
                f=f+1;
                CRES{p}(f)=RRES(Z(g,1))-RRES(Z(g,2));
                CERES{p}(f)=double((ROUT(Z(g,1))-ROUT(Z(g,2)))>0);
                CERES_VAL{p}(f)=double((ROUT(Z(g,1))-ROUT(Z(g,2))));
                WM{p}(1,f)=k(Z(g,1));
                WM{p}(2,f)=k(Z(g,2));
                WTS{p}(f)=tan_sim(NRM(k(Z(g,1)),:),NRM(k(Z(g,2)),:));
                CRESR{p}(1,f)=RRES(Z(g,1));
                CRESR{p}(2,f)=RRES(Z(g,2));
                CERESR{p}(1,f)=ROUT(Z(g,1));
                CERESR{p}(2,f)=ROUT(Z(g,2));
            end
        end
        if f~=0
            B2=CRES{p}';
            ObsInt=CERES{p}';
            Obs={};
            for ii=1:length(ObsInt)
                Obs{ii}=num2str(ObsInt(ii));
            end
        else
            p=p-1;
        end
    end
end

NRM=Morgan(IND,:);
for i=1:size(NRM,1)
    for j=1:10
        TS(i,j)= tan_sim(Morgan10(j,:),NRM(i,:));
    end
end

TSS=max(TS');

for i=1:size(SI,1)
    w=find(GR==i);
    MSS(i)=mean(TSS(w));
end

B2=[];
ObsInt=[];
WML=[];
WTN=[];
CVAL=[];
for i=1:p
    B2=[B2;CRES{i}'];
    ObsInt=[ObsInt;CERES{i}'];
    WML=[WML,WM{i}];
    WTN=[WTN,WTS{i}];
    CVAL=[CVAL,CERES_VAL{i}];
end
B2=(B2-min(B2))./(max(B2)-min(B2));
CVAL2=abs(CVAL);

B2=[];
for i=1:p
    B2=[B2;CRES{i}'];
end

[R_TS,a]=sort(WTN,'descend');
[R_CV,b]=sort(CVAL,'descend');
[R_TT,c]=sort(WTN+CVAL./max(CVAL),'descend');

LT=log10(OUT);
B2=res;
ObsInt=[];
ObsInt(LT>log10(3))=1;
ObsInt(LT<=log10(3))=0;
B2=(B2-min(B2))./(max(B2)-min(B2));

Obs={};
for ii=1:length(ObsInt)
    Obs{ii}=num2str(ObsInt(ii));
end
[X,Y,T,AUC] = perfcurve(Obs,B2,'1');

figure (1)
plot(X,Y,'LineWidth',1)
title(num2str(AUC))

YPP(res>=log10(3))=1;
YPP(res<log10(3))=0;
[Accuracy,Sensitivity,Specifity,Precision,Recall,F1_score]=class_perform(YPP,ObsInt);
correlation=corrcoef(log10(OUT'),res);