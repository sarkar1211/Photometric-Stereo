function L = calc_L(hlPosition, center, radius)

% finding the length of the highlight vector
hlVector = hlPosition - center;
lengthHighlight = norm(hlVector);

% finding the value of z
z = sqrt(radius^2 - lengthHighlight^2);

% normalizing R vector
N = [hlVector(1) -hlVector(2) z];

N = N / norm(N);

% finding the L vector
R = [0 0 1];
L = -(2*dot(N,R)*N - R);
end