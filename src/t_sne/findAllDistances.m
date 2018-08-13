function D = findAllDistances(data)

    N = length(data(:,1));
    
    D = zeros(N);
    for i=1:N
        for j=(i+1):N
            D(i,j) = norm(data(i,:)-data(j,:));
            D(j,i) = D(i,j);
        end
    end