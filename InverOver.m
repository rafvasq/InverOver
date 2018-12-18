function [fitness_average, distHistory, toctime] = InverOver(city_list, dmat, pop, popSize, totalDist, frequency, p, total_iterations)

    % Initialization
    iter_count  = 0;
    city_       = -1;
    numIter = total_iterations;
    distHistory = zeros(1,numIter);
    fitness_average = zeros(1,numIter);
    toctime = zeros(1,numIter);
    
    while iter_count < numIter 
        
        % Counter
        iter_count = iter_count + 1;
        
        % Mapping Function
        if mod(iter_count, frequency) == 0
            [city_list, totalDist, dmat] = MappingFunction(city_list, pop, popSize, p, 10);
        end
        
        tic();
        for i = 1:popSize
            current_route = pop(i, :);
            [r, route_length] = size(current_route);
            city_index = ceil(route_length*rand());           % Randomly select the index for city C from route*
            city = current_route(city_index);                 % The City C from route*

            % getting previous and next cities in the route for later
            % if it's the first city, previous is the last city
            if city_index == 1
                prev_city = current_route(route_length);
                next_city = current_route(city_index + 1);
            % if it's the last city, next is the first city
            elseif city_index == route_length 
                prev_city = current_route(city_index - 1);
                next_city = current_route(1);
            else
                prev_city = current_route(city_index - 1);
                next_city = current_route(city_index + 1);
            end

            while city_ ~= prev_city && city_ ~= next_city
                if rand() <= 0.4
                    selected_city_index = ceil(route_length*rand());   
                    while(selected_city_index == city_index)
                        selected_city_index = ceil(route_length*rand());
                    end
                    city_ = current_route(selected_city_index);      
                else
                    temp_route_index = ceil(popSize*rand());
                    temp_route = pop(temp_route_index, :);
                    city_index_temp_route = find(temp_route == city);

                    if(city_index_temp_route == route_length)  % if the city is the last in the route
                        city_ = temp_route(1);   % set C* to the first city in the route (closed path)
                    else
                        city_ = temp_route(city_index_temp_route + 1);    % set C* to the next city in the route
                    end
                    selected_city_index = find(current_route == city_);   
                end

                if city_ == prev_city || city_ == next_city
                    break;
                end
                
                % Inversing
                if(city_index > selected_city_index)
                    temp = zeros(1, city_index - selected_city_index);
                    temp_num = city_index;
                    count = 0;
                    for j=selected_city_index+1:city_index
                        count = count + 1;
                        temp(count) = current_route(j);
                    end
                    for j=1:size(temp, 2)
                       current_route(temp_num) = temp(j);
                       temp_num = temp_num - 1;
                    end
                end
                if(selected_city_index > city_index)
                    temp = zeros(1, selected_city_index - city_index);
                    temp_num = selected_city_index;
                    count = 0;
                    for j=city_index+1:selected_city_index
                        count = count + 1;
                        temp(1,count) = current_route(j);
                    end
                    for j=1:size(temp, 2)
                       current_route(temp_num) = temp(j);
                       temp_num = temp_num - 1;
                    end
                end
                city = city_;
            end

            % Calculating total distance of the newly made route
            d = dmat(current_route(route_length), current_route(1));
            for k = 2:route_length
                d = d + dmat(current_route(k-1),current_route(k));
            end
            new_total_dist = d;
            
            % Keeping the new route if it's better
            if new_total_dist < totalDist(i)
                totalDist(i) = new_total_dist;
                pop(i, :) = current_route;
            end 
        end
        
        % Collecting data about run-time
        if(iter_count == 1)
            toctime(iter_count) = toc();
        else
            toctime(iter_count) = toctime(iter_count-1) + toc();
        end
        
        % Getting average distances each generation
        fitness_average(iter_count) = mean(totalDist);
        
        % Finding the Best Route in the Population
        [minDist,~] = min(totalDist);
        distHistory(iter_count) = minDist;
        
      
    end
end