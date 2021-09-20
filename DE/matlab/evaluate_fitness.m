function sse = evaluate_fitness(Vs, Is, theta, T, model)
% EVALUATE_FITNESS compute the sum of squared error (SSE) as fitness
%   Vs: a list of voltages
%   Is: a list of currents
%   theta: parameter vector. Note that the unit of I0, I01, and I02 is muA. 
%       - SDM: Iph, I0, n, Rs, Rp
%       - DDM: Iph, I01, I02, n1, n2, Rs, Rp
%   T: temperature in Kelvin
%   model: 0 - SDM, 1 - DDM

N = length(Vs);
sse = 0.0;
if model == 0
    Iph = theta(1);
    I0 = theta(2);
    n =  theta(3);
    Rs =  theta(4);
    Rp = theta(5);
    for j = 1:N
        I_model = SDM(Vs(j), Is(j), Iph, I0, n, Rs, Rp, T);
        sse = sse + (I_model - Is(j))^2;
    end
elseif model == 1
    Iph = theta(1);
    I01 = theta(2);
    I02 = theta(3);
    n1 =  theta(4);
    n2 =  theta(5);
    Rs =  theta(6);
    Rp = theta(7);
    for j = 1:N
        I_model = DDM(Vs(j), Is(j), Iph, I01, I02, n1, n2, Rs, Rp, T);
        sse = sse + (I_model - Is(j))^2;
    end
else
    error("model can only be 0 (SDM) or 1 (DDM)");
end

end


function I_model = SDM(V, I, Iph, I0, n, Rs, Rp, T)
    k = 1.3806503e-23;     %  Boltamann constant
    q = 1.60217646e-19;   % electron charge 
    tmp = V+ I*Rs;
    I_model = Iph - I0*1e-6*(exp(q*tmp/(n*k*T)) - 1) - tmp/Rp;
end

function I_model = DDM(V, I, Iph, I01, I02, n1, n2, Rs, Rp, T)
    k = 1.3806503e-23;     %  Boltamann constant
    q = 1.60217646e-19;   % electron charge 
    tmp = V+ I*Rs;
    c = k*T/q;
    I_model = Iph - I01*1e-6*(exp(tmp/(n1*c)) - 1) - I02*1e-6*(exp(tmp/(n2*c)) - 1) - tmp/Rp;
end

