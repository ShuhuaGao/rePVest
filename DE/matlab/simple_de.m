function [sol, rmse] = simple_de(data, X, Np, Cr, F, G)
% SIMPLE_DE the simple DE algorithm
%   data: a struct with fields Vs, Is, and T
%       Vs: a list of voltages
%       Is: a list of currents
%       T: temperature in Kelvin
%   X: each row denotes the lower and upper bounds of a variable
%       The number of rows chooses the use of SDM or DDM.
%   Np, Cr, F, G: control parameters
%   RETURN
%       sol: solution vector, i.e., the estimated vector
%       rmse: RMSE of the solution 

[D, ~] = size(X);  % D is the dimension
assert(D == 5 || D == 7);
Vs = data.Vs;
Is = data.Is;
T = data.T;
low = X(:, 1);
up = X(:, 2);
evaluator = @evaluate_fitness;

% initialize a population
P = low + rand(D, Np) .* (up - low);
fitness = zeros(1, Np);
for j = 1:Np
    fitness(j) = evaluator(Vs, Is, P(:, j), T, D == 7);
end
fitness_new = fitness;
P_new = P;

% evolve
for g = 1:G
    for j = 1:Np
        indices =rand_choose(Np, 3, j);
        a = indices(1); b = indices(2); c = indices(3);
        v = P(:, a) + F * (P(:, b) - P(:, c));  % donor
        x = P(:, j); % target
        v = bounceback(v, x, low, up);   % apply bound constraints
        beta =randi(D);
        % crossover
        u = x;  % trial vector
        for d = 1:D
            if d == beta || rand() <= Cr
                u(d) = v(d);
            end
        end
        % evaluate fitness
        u_fit = evaluator(Vs, Is, u, T, D == 7);
        x_fit = fitness(j);
        % selection
        if u_fit <= x_fit
            P_new(:, j) = u;
            fitness_new(j) = u_fit;
        end
    end
    P = P_new;
    fitness = fitness_new;
end

% return the best solution
[min_sse, idx] = min(fitness);
sol = P(:, idx);
rmse = sqrt(min_sse / length(Vs));
end


function c = rand_choose(n, k, d)
% Randomly choose k unique integers from 1:n but without the integer d
c = randperm(n, k + 1);
for j = 1:k+1
    if c(j) == d
        c(j) = [];
        return;
    end
end
c = c(1:k);
end

function v = bounceback(v, x, low, up)
    for j = 1:length(v)
        if v(j) < low(j)
            v(j) = low(j) + rand() * (x(j) - low(j));
        elseif v(j) > up(j)
            v(j) = up(j) - rand() * (up(j) - x(j));
        end
    end
end

