function [] = runIRIS()
	lb = [0;0];
    ub = [200; 200];
    goal = [100000; 100000];
    N = 10;
   
    data_path = '~/sandbox/10_725_project/dev/data/env4.csv';
    dat_path = '~/sandbox/10_725_project/dev/data/env4.dat';
	
	obstacles = transpose(dlmread(data_path, ','));
    start = obstacles(:, end);
    obstacles(:, end) = [];
    obstacles2 = [];
    p = linspace(0, 1, 20);
    for i = 1:size(obstacles, 2)-1
        obstacles2 = [obstacles2, obstacles(:, i) + p.*[obstacles(:, i+1) - obstacles(:, i)]];
    end
    obstacles = obstacles2;
	obstacles = reshape(obstacles, 2, 1, []);
    
    C_store = cell(N, 1);
    d_store = cell(N, 1);
    start_store = cell(N-1, 1);
    figure()
    visenv(dat_path, data_path); hold on
    for i  = 1:N
    
    	if i == 1
    		u = start + 1*(goal-start)./(norm(goal-start));
    		plot([start(1), u(1)], [start(2), u(2)], 'k', 'linewidth', 2); hold on
    	end
    
        if i > 1
            if rand(1) > 0.1
                start = find_new_start(C_store, d_store, start_store);
            else
                start = find_new_start_gb(C, d, start, goal);
            end
            
        end
        [A, b, C, d, result] = iris.test.test_points_2d(obstacles, start, lb, ub);
        iris.drawing.draw_2d(A, b, C, d, result.obstacles, lb, ub); hold on;
        if i == 1
            scatter(start(1), start(2), 150, 'ro', 'filled');
        else
            scatter(start(1), start(2), 'go', 'filled');
        end
            drawnow
        
        C_store{i} = C;
        d_store{i} = d;
        start_store{i} = start;
    end
end % end of runIRIS function

function [start] = find_new_start(Cs, ds, ss)
    xx = [];    
    for i = 1:length(Cs)
        if isempty(Cs{i})
            break;
        end
        C = Cs{i};
        d = ds{i};
        th = linspace(0,2*pi,100);
        y = [cos(th);sin(th)];
        x = bsxfun(@plus, C*y, d);
        xx = [xx, x];
    end
    maxD = 0;
    for i = 1:length(ss)
        if isempty(ss{i})
            break;
        end
        Dx = transpose(pdist2(xx', ss{i}'));
        [maxd, maxd_idx] = max(Dx + randn(size(Dx))*10);
        if maxd > maxD
            maxD = maxd;
            start = xx(:, maxd_idx);
        end
    end
end % end of find_new_start function

function [start] = find_new_start_gb(C, d, start, goal)
	u = find_u(start, goal);
	start = C*u + d;
end % end of function find_new_start_gb

function [u] = find_u(start, goal)
	u = (goal-start)./(norm(goal-start));
end
