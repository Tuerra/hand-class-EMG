%%% ======================================= %%%
%%% === 10-FOLD NESTED CROSS-VALIDATION === %%% (template script)
%%% ======================================= %%%

%%% prendo matrice feature (ogni riga è un feature vector, ultima colonna sono le labels)
feature = M;

% shuffle - mischio in ordine casuale le feature
featureShuffle = feature(randperm(length(feature)),:);

% divide in 10 folds
nFold = 10;
dimConfMatrix = [1 nFold];
confMatrix=cell(dimConfMatrix);
groupvalue=[ 1 2 3 4 5 6 7 ];
for start = 1:nFold
    
    %%% pongo train uguale a feature matrix, poi ELIMINO un valore ogni 10
    train = featureShuffle;
    train( start:nFold:end,: ) = [];
    
    %%% pongo val uguale a feature matrix, poi PRENDO un valore ogni 10
    val = featureShuffle( start:nFold:end,: );
    
    % normalize training samples
    sM = mean(train(:,1:end-1));
    sS = std(train(:,1:end-1));
    train(:,1:end-1) = train(:,1:end-1) - repmat(sM,size(train(:,1:end-1),1),1);
    train(:,1:end-1) = train(:,1:end-1) ./ repmat(sS,size(train(:,1:end-1),1),1);
    
    %%% loop interno di cross-validation per sciegliere migliori iper-parametri
    [bestC,bestG,bestErr,guessed] = crossValidate(train(:,end),train(:,1:end-1),'c',@err_BER,10);

    % normalize testing samples (use training sample stats)
    val(:,1:end-1) = val(:,1:end-1) - repmat(sM,size(val(:,1:end-1),1),1);
    val(:,1:end-1) = val(:,1:end-1) ./ repmat(sS,size(val(:,1:end-1),1),1);
    
    % train svm on trainset
    modelSVM = svmtrain(train(:,end), train(:,1:end-1),sprintf('-c %f -g %f',bestC,bestG));
    [predictedValue] = svmpredict(val(:,end), val(:,1:end-1), modelSVM);
    
    %%% costruisco la matrice di confusione
    [confMatrix{start},order] = confusionmat(val(:,end),predictedValue,'Order',groupvalue); %%% comando e implementazione da verificare!!
    
end
% sum the "cross-validation confusion matrices"
%%%%%%%%%%%% comandi  e implementazione da verificare!!
confMatrixSum=zeros(size(confMatrix{1}));
for i = 1:length(confMatrix)
    confMatrixSum = confMatrixSum + confMatrix{i};
end

% final confusion matrix with percentage
S=sum(confMatrixSum);
confMatrixPer=zeros(length(confMatrixSum));
for i=1:length(confMatrixSum)
confMatrixPer(:,i)=(confMatrixSum(:,i)/S(i))*100;
end

%% Balanced ERROR RATE

%facciamo ora il balanced error rate di questa matrice di confusione

a=confMatrixSum;
total=sum(a);
di=diag(a);
b=zeros(1,length(a));
for i=1:1:length(a)
    b(i)=(total(i)-di(i))/total(i);
end
BER=sum(b)/length(a);
%}


%% MATTHEWS CORRELATION COEFFICIENT
%{
L=length(confMatrixSum);
confMatrixSum=transpose(confMatrixSum);
%calcoliamo prima il numeratore
num=0;
for k=1:L
    for l=1:L
        for m=1:L
            num=confMatrixSum(k,k)*confMatrixSum(l,m)-confMatrixSum(k,l)*confMatrixSum(k,m)+num;
        end
    end
end

%quindi la prima parte del denominatore
Clk=0;
Cfg=0;
den1=0;
for k=1:L
    for l=1:L
        Clk=confMatrixSum(l,k)+Clk;
    end
    for g=1:L
        for f=1:L
            if f~=k 
                Cfg=confMatrixSum(g,f)+Cfg;
            end
        end
    end
    den1=Clk*Cfg + den1;
end 
den1=sqrt(den1);

%poi la seconda parte
Ckl=0;
Cfg=0;
den2=0;
for k=1:L
    for l=1:L
        Ckl=confMatrixSum(k,l)+Ckl;
    end
    
    for g=1:L
        for f=1:L
            if f~=k
                Cfg=confMatrixSum(f,g)+Cfg;
            end
        end
    end
    den2=Cfg*Ckl + den2;
end
den2=sqrt(den2);

MCC=num/(den1*den2);
%}

%% ACCURACY & MISCLASSIFICATION RATE
%{
a=confMatrixSum;
total=sum(sum(a));
num=sum(diag(a));
acc=(num/total)*100;

miscRate=((total-num)/total) * 100;
%}

%% GET VALUES
%{
[Result,RefereceResult]=confusion.getValues(confMatrixSum);
disp(Result)
disp(RefereceResult)
%}

load train.mat
%sound(y);
