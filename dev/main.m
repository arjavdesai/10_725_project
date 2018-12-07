%% main function for 10-725 project

function [] = main()
    % load environment
    load('env1.mat'); % TODO: environment represented as cell array of obstacles

    % process environment - done
    [V, VMap] = obstacle_vertex_to_id(env.obstacles);

    % constants
    sensorModel = 'square';
    sensorAlpha = 10;

    % define start position
    rPos =[];

    % define goal position
    gPos = [];

    % iterate
    while (~robot_at_goal)

        % local map - PX2(N+1) matrix - done
        localMap = get_local_map(env.obstacles, V, VMap, rPos, sensorModel, sensorAlpha);
        
        % free space via raytracing -- dhruv
        
        % convex decomposition of free space -- done
        
        
        % is goal in convex decomposition -- arjav
        
        % yes - trajectory to intermediate goal -- arjav
            % exit
        % no - find intermediate goal
            % trajectory to intermediate goal
    end % end of while loop

end % end of main function