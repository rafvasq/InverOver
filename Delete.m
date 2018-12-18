function [city_list, dmat, pop, totalDist] = Delete(delete_city, city_list, dmat, pop, popSize, totalDist)

    % remove city from the city list
    city_list(delete_city, :) = [];
    
    % update distance matrix
    nPoints = size(city_list,1);
    a = meshgrid(1:nPoints);
    dmat = reshape(sqrt(sum((city_list(a,:)-city_list(a',:)).^2,2)),nPoints,nPoints);
    
    [r, route_length] = size(dmat); % dmat should be updated with new city
    temp_pop = zeros(popSize, route_length);
    
    for i = 1:popSize
        current_route = pop(i, :);
        
        delete_city_index = find(current_route == delete_city);
        new_route = [current_route(1:delete_city_index-1), current_route(delete_city_index+1:end)];
        
        % calculating total distance of the routes
        [r, route_length] = size(new_route);
        d = dmat(new_route(route_length), new_route(1));
        for k = 2:route_length
            d = d + dmat(new_route(k-1),new_route(k));
        end
        total_dist = d;
        
        totalDist(i) = total_dist;
        temp_pop(i, :) = new_route;
    end
    
    pop = temp_pop;
end