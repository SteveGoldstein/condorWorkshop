function final_lu(inFile, outFile, nzinit, pivotMethod,Ltol1,useTranspose)

    %%% Loads Matrix From Given File %%%
    sparse_data = load(inFile);
    T = spconvert(sparse_data);
    
    %%% Computes LU Factorization %%%
    if ~(ismcc || isdeployed)
        addpath('./lusol/matlab');
    end

    
    if nargin < 3
        nzinit = 1e7;
    else
       nzinit = str2double(nzinit);
    end

    if nargin < 4
        pivotMethod = 'TPP';
    end

    if nargin < 5
        [L,U,P,Q] = lusol(T,[],'nzinit', nzinit, 'pivot',pivotMethod);
    else
        Ltol1 = str2double(Ltol1);
        if logical(useTranspose)
            T = T';
        end
        [L,U,P,Q] = lusol(T,[],'nzinit', nzinit, 'pivot',pivotMethod, 'Ltol1', Ltol1);
    end
    
    %%% Computes Rank from LU Factorization %%%
    [m,n] = size(T);
    if min([m,n]')==1
        D = abs(U(1));
    else
        D = abs(diag(U));
    end

    tol = [1e-1 1e-2 1e-3 1e-4 1e-5 1e-6 1e-7 1e-8 1e-9 1e-10 1e-11];

    Rank = [];
    for t = tol
        I = find(D>t);
        R = length(I);
        Rank = horzcat(Rank, [R]);
    end

    ranks = sprintf('%d\t', Rank);
    
    inFile = regexprep(inFile, '^.*/','');
    inFile = regexprep(inFile, '\.dat$', '');

    fileID = fopen(outFile, 'w');

    fprintf (fileID, '%s\t%s\t%s\n', inFile, pivotMethod, ranks);
    fclose(fileID);

    %A = L*U-P*T*Q;
    %format long;
    %outMatrixFile = regexprep(outFile,'\.txt','.residual.mat');
    %save(outMatrixFile, 'U', '-mat');
end
