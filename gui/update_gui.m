function update_gui(state, data)
    
%     hf = sfigure(data.figure);
%     set(hf, 
%         'Name', sprintf('%s (%d/%d t=%.3fs)',
%         data.sequence.name, 
%         data.index, 
%         data.sequence.length, 
%         state.time), 
%         'NumberTitle', 'off');
    app = data.app;
    
    image_path = get_image(data.sequence, data.index);
    
    gt = get_region(data.sequence, data.index);
    tracker_result = state.region;

    imshow(image_path, 'Parent', app.moniter);
    hold(app.moniter, 'on');
    gui_draw_region(gt, [1 0 0], 2, app);
    gui_draw_region(tracker_result, [0 1 0], 1, app);
    hold(app.moniter, 'off');
    
    overlap = frame_overlap(gt, tracker_result);
    cle = calc_cle(gt, tracker_result);
    
    statusText = sprintf("%s:%d/%d", data.sequence.name, data.index, data.sequence.length);
    app.status.Value = statusText;
    
    analyseText = sprintf('overlap:%f  CLE:%f', overlap, cle);
    app.analyse.Value = analyseText;
    
    drawnow;
    
    
    
    