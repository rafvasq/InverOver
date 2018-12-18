function [xy, totalDist, dmat] = MappingFunction(xy, pop, popSize, p, n)

    % Number of swaps to make
    changes = ceil(n*p);
    
    for i=1:changes    
        % Selecting two random cities and swaping
        randx = ceil(size(xy, 1) *rand());
        randy = ceil(size(xy, 1) *rand());
        temp = xy(randx, :);
        xy(randx, :) = xy(randy, :); % change @ x
        xy(randy, :) = temp; % change @ y

        % Recalculating the distance matrix
        nPoints = size(xy,1);
        a = meshgrid(1:nPoints);
        dmat = reshape(sqrt(sum((xy(a,:)-xy(a',:)).^2,2)),nPoints,nPoints);
    end 
    
    % Evaluating every solution in the population (calculating total distances)
    for p = 1:popSize
        d = dmat(pop(p,nPoints),pop(p,1));
        for k = 2:nPoints
            d = d + dmat(pop(p,k-1),pop(p,k));
        end
        totalDist(p) = d;
    end

end