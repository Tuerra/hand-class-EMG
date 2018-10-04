%calcolo modello della svm con label del training e del training set
model= svmtrain(labeltrainset, trainset, '-c 500 -h 0 -b 1');

%siccome nel modello i vettori di supporti sono memorizzati
%in una matrice sparsa, che non è supportata da simulink,
%sovrascrivo model.SVs con gli indici dei valori diversi da zero
%(la matrice sparsa verrà poi ricostruita all'interno di una funzione
%che viene chiamata da simulink all'interno di un matlab function block
%in simulink)
[sparse_i,sparse_j,sparse_val]=find(model.SVs);
sparse_matrix_indexes=[sparse_i,sparse_j,sparse_val];
model.SVs=sparse_matrix_indexes;