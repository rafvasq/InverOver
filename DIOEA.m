eil51 = [37 52
49 49
52 64
20 26
40 30
21 47
17 63
31 62
52 33
51 21
42 41
31 32
5 25
12 42
36 16
52 41
27 23
17 33
13 13
57 58
62 42
42 57
16 57
8 52
7 38
27 68
30 48
43 67
58 48
58 27
37 69
38 46
46 10
61 33
62 63
63 69
32 22
45 35
59 15
5 6
10 17
21 10
5 64
30 15
39 10
32 39
25 32
25 55
48 28
56 37
30 40 ];

total_iterations = 1000;
frequency = 1000;
p = 0.9;

fitness_average = [];
sol_count = 0;
dlist = [];
dlist_count = 0;
radius = 40;
velocity = 20;
center = [ 34.9412   39.0196 ]; %[ 166.5667  363.3000 ]; 
time=0:0.001:100; %time vector in seconds
th=0:pi/50:2*pi;
xunit=radius*cos(th) + center(1);
yunit=radius*sin(th) + center(2);
dlist = [dlist ; size(eil51,1) + 1, xunit(1), yunit(1), 1];
scatter(eil51(:, 1), eil51(:, 2)); % plotting the cities
title('Cities');
for t=2:316
    xunit=radius*cos(velocity*time(t) )+ center(1); 
    yunit=radius*sin(velocity*time(t) )+ center(2); 
    eil51_1 = [eil51; xunit(1), yunit(1)];
    dlist = [dlist ; size(eil51,1) + 1, xunit(1), yunit(1), 3];
end

xy          = eil51;
%dlist      = [];
popSize     = 100;
[n,dims]    = size(xy);
dmat        = [];
globalMin = Inf;
totalDist = zeros(1,popSize);
errors = zeros(1, size(dlist, 1));
stop = 0;

% Calculating distance matrix
if isempty(dmat)
    nPoints = size(xy,1);
    a = meshgrid(1:nPoints);
    dmat = reshape(sqrt(sum((xy(a,:)-xy(a',:)).^2,2)),nPoints,nPoints);
end

% Initialize the Population
pop = zeros(popSize,n);
pop(1,:) = (1:n);
for k = 2:popSize
    pop(k,:) = randperm(n);
end

% Evaluate Each Population Member (Calculate Total Distance)
for p = 1:popSize
    d = dmat(pop(p,n),pop(p,1));
    for k = 2:n
        d = d + dmat(pop(p,k-1),pop(p,k));
    end
    totalDist(p) = d;
end

while stop == 0 %sol_count < 5
    %tic()
    
    %
    %[fitness_average_inver, distHistory_inv, toctime_inv] = InverOver(xy, dmat, pop, popSize, totalDist, frequency, p, total_iterations);
    [fitness_average_inver, distHistory_inv, toctime_inv] = GSInverOver(xy, dmat, pop, popSize, totalDist, frequency, p, total_iterations);
    
    while ~isempty(dlist)
        if(dlist(1, 4) == 1) % if type is INSERT
            [xy, dmat, pop, totalDist] = Insert([dlist(1,2), dlist(1,3)], xy, dmat, pop, popSize, totalDist);
            
        end
        if(dlist(1, 4) == 2) % if type is DELETE
            [xy, dmat, pop, totalDist] = Delete(dlist(1,1), xy, dmat, pop, popSize, totalDist);
        end
        if(dlist(1,4) == 3) % if type is CHANGE
            [xy, dmat, pop, totalDist] = Delete(dlist(1,1), xy, dmat, pop, popSize, totalDist);
            [xy, dmat, pop, totalDist] = Insert([dlist(1,2), dlist(1,3)], xy, dmat, pop, popSize, totalDist);
        end
        dlist(1, :) = [];
        f = figure(1);
        hold on;
        [minDist,minIndex] = min(totalDist);
        clf(f);
        globalMin = minDist;
        optRoute = pop(minIndex,:);
        rte = optRoute([1:size(dmat,1) 1]);
        plot(xy(rte,1),xy(rte,2),'r.-');
        title(sprintf('Total Distance = %1.4f', minDist));
        pause(0.05);
        [minDist,minIndex] = min(totalDist);
        dlist_count = dlist_count + 1;
    end
    
    stop = 1;
    
    [minDist,minIndex] = min(totalDist);
    % Find the Best Route in the Population
    if minDist < globalMin 
        sol_count = 0;
        globalMin = minDist;
        optRoute = pop(minIndex,:);
        rte = optRoute([1:size(optRoute) 1]);
    else
        sol_count = sol_count + 1;
    end
    
end

figure('Name','DIOEA | Results','Numbertitle','off');
subplot(2,1,1);
plot(fitness_average_inver);
title('Average Solution at Each Generation');

subplot(2,1,2);
plot(errors,'b','LineWidth',2);
title('Relative Error at Each Generation');