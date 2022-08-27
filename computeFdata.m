function [Fdata] = computeFdata(W_M, L, D, T)
%   Returns the matrix that can be treated as an object property. 

Fdata = [1 3 -W_M/2;
    2 6 -W_M/2;
    3 9 L/5;
    4 12 L/5;
    5 15 L/5;
    6 18 L/5;
    7 21 L/5;
    3 7 -D/5;
    4 10 -D/5;
    5 13 -D/5;
    6 16 -D/5;
    7 19 -D/5;
    1 1 T/2;
    2 4 T/2;
];

end

