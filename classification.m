%questa funzione viene chiamata all'interno del matlab function block in
%simulink, perché è l'unico modo per poter utilizzare le matrici sparse in
%simulink (che di normale non sono supportate)
function out = classification(LABEL_1, COMPLETE_1, model)

    %ricostruisco la matrice sparsa dagli indici che erano stati estratti
    %in svm_train.m
    model.SVs=sparse(model.SVs(:,1),model.SVs(:,2),model.SVs(:,3));

    %eseguo la classficazione
    %LABEL_1=label con la quale calcolare l'accuratezza (può essere random
    %se non di interesse o non nota)
    %COMPLETE_1= il campione attuale da classificare
    %model= modello della svm calcolato nella fase di train
    [~,predict_label] = evalc('svmpredict(LABEL_1, COMPLETE_1, model)');
    
    %ritorno il valore della calssificazione
    out=predict_label;
    
    %display(out);
    
end