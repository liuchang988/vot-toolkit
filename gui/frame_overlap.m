function overlap = frame_overlap(t1, t2)

if iscell(t1)
    if ismatrix(t1(1))
        traj = t1(1);
    else
        traj = t1(2);
    end
else
    traj = {t1};
end

if iscell(t2)
    if ismatrix(t2(1))
        gt = t2(1);
    else
        gt = t2(2);
    end
else
    gt = {t2};
end

[overlap, ~] = calculate_overlap(traj, gt, []);


end
    

