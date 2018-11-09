function [] = visenv(envfile, visfile)
    envdata = readfile(envfile);
    visdata = readfile(visfile);

    hold on;
    for o = 2:length(envdata)
        obs = cell2mat(envdata(o));
        plot(obs(1, :), obs(2, :), 'k', 'linewidth', 1); hold on
    end

    for p = 1:length(visdata)-1
        pt = cell2mat(visdata(p));
        scatter(pt(1), pt(2), 15, [0 0.5 0], 'filled');
    end
    pt = cell2mat(visdata(p+1));
    scatter(pt(1), pt(2), 15, 'ro', 'filled');
    vpts = cell2mat(visdata);
    vpts(:, end) = [];
    plot(vpts(1, :), vpts(2, :), 'Color', [0 0.5 0], 'linewidth', 2);
    xlim([0 200])
    ylim([0 200])
end

function [data] = readfile(filename)
    fid = fopen(filename);

    fline = fgetl(fid);
    data = {};
    while ischar(fline)
        fline = sscanf(fline, '%g,')';
        data{end+1} = reshape(fline, 2, numel(fline)/2);
        fline = fgetl(fid);
    end
    fclose(fid);
end
