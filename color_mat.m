load('matrix1')
load('matrix2')
C=C1+C2;
%C=C1;

wavelet='coif2';
window=100;
overlap='no';



switch wavelet
    case 'db2'
        switch window
            case 100
                if strcmp(overlap, 'no')
                    mat=C(1:7,1:7);
                elseif strcmp(overlap,'half')
                    mat=C(8:14,1:7);
                end
            case 200
                if strcmp(overlap, 'no')
                    mat=C(1:7,8:14);
                elseif strcmp(overlap,'half')
                    mat=C(8:14,8:14);
                end
            case 400
                if strcmp(overlap, 'no')
                    mat=C(1:7,15:21);
                elseif strcmp(overlap,'half')
                    mat=C(8:14,15:21);
                end
        end
    case 'db3'
        switch window
            case 100
                if strcmp(overlap, 'no')
                    mat=C(15:21,1:7);
                elseif strcmp(overlap,'half')
                    mat=C(22:28,1:7);
                end
            case 200
                if strcmp(overlap, 'no')
                    mat=C(15:21,8:14);
                elseif strcmp(overlap,'half')
                    mat=C(22:28,8:14);
                end
            case 400
                if strcmp(overlap, 'no')
                    mat=C(15:21,15:21);
                elseif strcmp(overlap,'half')
                    mat=C(22:28,15:21);
                end
        end
    case 'db4'
        switch window
            case 100
                if strcmp(overlap, 'no')
                    mat=C(29:35,1:7);
                elseif strcmp(overlap,'half')
                    mat=C(36:42,1:7);
                end
            case 200
                if strcmp(overlap, 'no')
                    mat=C(29:35,8:14);
                elseif strcmp(overlap,'half')
                    mat=C(36:42,8:14);
                end
            case 400
                if strcmp(overlap, 'no')
                    mat=C(29:35,15:21);
                elseif strcmp(overlap,'half')
                    mat=C(36:42,15:21);
                end
        end
    case 'coif2'
        switch window
            case 100
                if strcmp(overlap, 'no')
                    mat=C(1:7,22:28);
                elseif strcmp(overlap,'half')
                    mat=C(8:14,22:28);
                end
            case 200
                if strcmp(overlap, 'no')
                    mat=C(1:7,29:35);
                elseif strcmp(overlap, 'half')
                    mat=C(8:14,29:35);
                end
            case 400
                 if strcmp(overlap, 'no')
                    mat=C(1:7,36:42);
                elseif strcmp(overlap, 'half')
                    mat=C(8:14,36:42);
                end
        end
    case 'coif3'
        switch window
            case 100
                if strcmp(overlap, 'no')
                    mat=C(15:21,22:28);
                elseif strcmp(overlap,'half')
                    mat=C(22:28,22:28);
                end
            case 200
                if strcmp(overlap, 'no')
                    mat=C(15:21,29:35);
                elseif strcmp(overlap, 'half')
                    mat=C(22:28,29:35);
                end
            case 400
                if strcmp(overlap, 'no')
                    mat=C(15:21,36:42);
                elseif strcmp(overlap, 'half')
                    mat=C(22:28,36:42);
                end
        end
    case 'coif4'
        switch window
            case 100
                if strcmp(overlap, 'no')
                    mat=C(29:35,22:28);
                elseif strcmp(overlap,'half')
                    mat=C(36:42,22:28);
                end
            case 200
                if strcmp(overlap, 'no')
                    mat=C(29:35,29:35);
                elseif strcmp(overlap, 'half')
                    mat=C(36:42,29:35);
                end
            case 400
                if strcmp(overlap, 'no')
                    mat=C(29:35,36:42);
                elseif strcmp(overlap, 'half')
                    mat=C(36:42,36:42);
                end
        end
    case 'sym2'
        switch window
            case 100
                if strcmp(overlap, 'no')
                    mat=C(1:7,43:49);
                elseif strcmp(overlap, 'half')
                    mat=C(8:14,43:49);
                end
            case 200
                if strcmp(overlap, 'no')
                    mat=C(1:7,50:56);
                elseif strcmp(overlap, 'half')
                    mat=C(8:14,50:56);
                end                    
            case 400
                if strcmp(overlap, 'no')
                    mat=C(1:7,57:63);
                elseif strcmp(overlap, 'half')
                    mat=C(8:14,57:63);
                end                    
        end
    case 'sym3'
        switch window
            case 100
                if strcmp(overlap, 'no')
                    mat=C(15:21,43:49);
                elseif strcmp(overlap, 'half')
                    mat=C(22:28,43:49);
                end
            case 200
                if strcmp(overlap, 'no')
                    mat=C(15:21,50:56);
                elseif strcmp(overlap, 'half')
                    mat=C(22:28,50:56);
                end    
            case 400
                if strcmp(overlap, 'no')
                    mat=C(15:21,57:63);
                elseif strcmp(overlap, 'half')
                    mat=C(22:28,57:63);
                end
        end
    case 'sym4'
        switch window
            case 100
                if strcmp(overlap, 'no')
                    mat=C(29:35,43:49);
                elseif strcmp(overlap, 'half')
                    mat=C(36:42,43:49);
                end
            case 200
                if strcmp(overlap, 'no')
                    mat=C(29:35,50:56);
                elseif strcmp(overlap, 'half')
                    mat=C(36:42,50:56);
                end
            case 400
                if strcmp(overlap, 'no')
                    mat=C(29:35,57:63);
                elseif strcmp(overlap, 'half')
                    mat=C(36:42,57:63);
                end
        end
end

%{
S=sum(mat);             % facciamo un vettore con la somma di tutti gli elementi di una colonna
percen=zeros(length(mat));
for i=1:length(mat)
percen(:,i)=(mat(:,i)/S(i))*100; % facciamo la percentuale degli elementi in una colonna sulla colonna
end

im=imagesc(percen,[0 100]);    % creiamo un plot colorato in base ai valori nelle caselle
colormap(parula);           % cambiamo la colormap
colorbar
im.AlphaData=.6;
textStrings = num2str(percen(:), '%0.2f %%');       % Create strings from the matrix values
textStrings = strtrim(cellstr(textStrings));  % Remove any space padding
[x, y] = meshgrid(1:length(percen));  % Create x and y coordinates for the strings
hStrings = text(x(:), y(:), textStrings(:), 'HorizontalAlignment', 'center');
%}

cm=confusionchart(mat);
cm.Normalization='total-normalized';
title(['Wavelet: ',wavelet,'  Window: ',num2str(window),'ms  Overlap: ',overlap,''])

total=sum(mat,2);
di=diag(mat);
b=zeros(1,length(mat));
for i=1:1:length(mat)
    b(i)=(total(i)-di(i))/total(i);
end
BER=sum(b)/length(mat);
ber=num2str(BER, '%0.4f');
disp(ber)

