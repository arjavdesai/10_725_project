function [localMap] = get_local_map(obstacles, V, VMap, rPos, model, alpha)
% function to find the local map given the robot position
% INPUTS:
%   obstacles: cell array of all obstacles in environment
%   V: array of all the obstacle vertices
%   VMap: map from V to obstacle id
%   rPos: robot position - 2x1
%   model: sensor model 'square', 'circle'
%   alpha: sensor model radius
    idx = sensorHorizonObstacles(V, VMap, rPos, model, alpha);
    max_size = max(cellfun('size', obstacles(idx), 2));
    localMap = -1*ones(length(idx), 2*(max_size+1));
    for i = 1:length(idx)
        sz = 2*size(obstacles{idx(i)},2);
        localMap(i, 1:sz) = reshape(obstacles{idx(i)}, 1, []);
        localMap(i, sz+1:sz+2)= localMap(i, 1:2);
    end
end % end of get_local_map_obstacles function

function [obstacle_id] = sensorHorizonObstacles(V, VMap, rPos, model, alpha)
% function to find the obstacles in the sensor horizon
% INPUTS:
%   V: 2xN array of all obstacle vertices
%   VMap: 1xN array mapping each vertex to obstacle id
%   rPos: 2x1 arrat - current robot position
%   alpha: the sensing radius
%   model: sensor model 'square', 'circle'
% OUTPUT:
%   obstacle_id: id's of obstacles in the sensor range

    switch model
        case 'square'
            xv = [(rPos(1)-alpha/2)*ones(1,2), ...
                  (rPos(1)+alpha/2*ones(1,2))];
            yv = [rPos(2)-alpha/2, rPos(2)+alpha/2, ...
                  rPos(2)+alpha/2, rPos(2)-alpha/2];
            xq = V(1,:);
            yq = V(2,:);
            [in, on] = inpolygon(xq, yq, xv, yv);
            VIdx = [find(in), find(on)];
            obstacle_id = unique(VMap(VIdx));
        case 'circle'
            D = pdist2(rPos', V');
            VIdx = D <= alpha;
            obstacle_id = unique(VMap(VIdx));
        otherwise
            error('Unsupported sensor model.')
    end
end % end of sensorHorizonObstacles
