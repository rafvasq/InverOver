function [city_list, dmat, pop, totalDist] = Insert(new_city, city_list, dmat, pop, popSize, totalDist)
    
    % find closest city in current city_list
    distances = sqrt(sum(bsxfun(@minus, city_list, new_city).^2,2));
    closest_city = find(distances==min(distances));
    
    % update city list and distance matrix
    city_list = [city_list; new_city(1), new_city(2)];
    nPoints = size(city_list,1);
    a = meshgrid(1:nPoints);
    dmat = reshape(sqrt(sum((city_list(a,:)-city_list(a',:)).^2,2)),nPoints,nPoints);
    
    pop = [pop zeros(popSize, 1)];
    
    for i = 1:popSize
        current_route = pop(i, :);
        [r, route_length] = size(current_route);
        
        closest_city_index = find(current_route == closest_city);
        prev_route = [current_route(1:closest_city_index-1), route_length, current_route(closest_city_index:end-1)];
        next_route = [current_route(1:closest_city_index), route_length, current_route(closest_city_index+1:end-1)];
        
        % calculating total distance of the routes
        d = dmat(prev_route(route_length), prev_route(1));
        d1 = dmat(next_route(route_length), next_route(1));
        for k = 2:route_length
            d = d + dmat(prev_route(k-1),prev_route(k));
            d1 = d1 + dmat(next_route(k-1),next_route(k));
        end
        prev_total_dist = d;
        next_total_dist = d1;
        
        if prev_total_dist < next_total_dist
            totalDist(i) = prev_total_dist;
            pop(i, :) = prev_route;
        else
            totalDist(i) = next_total_dist;
            pop(i, :) = next_route;
        end
    end
end