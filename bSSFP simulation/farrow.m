function a = farrow(x0, y0, z0, x1, y1, z1, color, width)
                                   % Number of cone lines
                    % Arrow color
    arrowwidth = width;                             % Arrow width
    arrowcolor=color;
                         % Start buffer data 
    X = [x0, x1];                          % (tail --> head)
    Y = [y0, y1];                          % 'nan' separates lines
    Z = [z0, z1];
    
 
    a = line(X, Y, Z, ...                       % Output 'farrow'
        'linewidth', arrowwidth, ...
        'color', arrowcolor); 
end
