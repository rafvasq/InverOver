clear

% File includes randomly created population, distance matrix and the eil51 
load('scenario.mat');

% Scenario construction
total_iterations = 10000;
frequency = 1000;
p = 0.9;

% Running updated GS-inver-over
[fitness_average_gs, distHistory_gs, toctime_gs] = GSInverOver(xy, init_distance_mat, init_pop, popSize, init_totalDist, frequency, p, total_iterations);

% Running simple inver-over
[fitness_average_inver, distHistory_inv, toctime_inv] = InverOver(xy, init_distance_mat, init_pop, popSize, init_totalDist, frequency, p, total_iterations);

% Data visualization
figure('Name','DIOEA','Numbertitle','off');
subplot(3,1,1);
plot(fitness_average_gs);
hold on
plot(fitness_average_inver, '--');
title('Average Solution at Each Generation');
legend({'GS','IO'},'Location','northeast')
subplot(3,1,2);
plot(distHistory_gs);
hold on
plot(distHistory_inv, '--');
title('Minimum Solution at Each Generation');
legend({'GS','IO'},'Location','northeast')
subplot(3,1,3);
plot(toctime_gs);
hold on
plot(toctime_inv, '--');
title('Time Elapsed at Each Generation');
legend({'GS','IO'},'Location','northeast')