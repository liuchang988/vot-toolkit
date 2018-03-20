function gui_plotc(app, x, y, varargin)

    x = [x(:); x(1)];
    y = [y(:); y(1)];

    plot(app.moniter, x, y, varargin{:});
    
end
