function [V, VMap] = obstacle_vertex_to_id(obstacles)
% function to preprocess the map
% INPUTS: 
%   obstacles: cell array of obstacles
% OUTPUTS:
%   V: 2xN vertex matrix
%   VMap: 1xN, map vertex to obstacle ids
    V = [];
    VMap = [];
    for i = 1:length(obstacles)
        sz = size(obstacles{i},2);
        V = [V, obstacles{i}];
        VMap = [VMap, i*ones(1, sz)];
    end
end % end of obstacle_vertex_to_id function