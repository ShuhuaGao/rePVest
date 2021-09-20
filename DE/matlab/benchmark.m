% Benchmark the runtime of the simple DE
clear;

%% Read data
% assume we are in the "matlab" directory
data_dir = "../src/data";
VI_RT = readmatrix(fullfile(data_dir, "RTFrance.csv"));
VI_PW = readmatrix(fullfile(data_dir, "Photowatt25.csv"));
data_RT.Vs = VI_RT(:, 1);
data_RT.Is = VI_RT(:, 2);
data_RT.T = 33 + 273.15;  % temperature in Kalvin of the RTC France case
data_PW.Vs = VI_PW(:, 1);
data_PW.Is = VI_PW(:, 2);
data_PW.T = 45 + 273.15;  % temperature in Kalvin of the Photowatt case

%% Search range
bounds_RT_sdm = [0 1; 0 1; 1 2; 0 0.5; 0 100];
bounds_RT_ddm = [0 1; 0 1; 0 1; 1 2; 1 2; 0 0.5; 0 100]; 
bounds_PW_sdm = [0 2; 0 50; 1 50; 0 2; 0 2000]; 
bounds_PW_ddm = [0 2; 0 0.01; 0 50; 1 50; 1 50; 0 2; 0 2000];

%% Algorithm hyperparameters
Np = 50;  % number of individuals
F = 0.6;
Cr = 0.9;
G_sdm = 800;
G_ddm = 2000;

%% Measure runtime
ntrials = 30;
% 1. SDM + RT
tic;
for j = 1:ntrials
    [sol, rmse] = simple_de(data_RT, bounds_RT_sdm, Np, Cr, F, G_sdm);
end
t = toc;
fprintf("SDM+RT: %.2f s\n", t / ntrials);
% 2. SDM + PW
tic;
for j = 1:ntrials
    [sol, rmse] = simple_de(data_PW, bounds_PW_sdm, Np, Cr, F, G_sdm);
end
t = toc;
fprintf("SDM+PW: %.2f s\n", t / ntrials);
% 3. DDM + RT
tic;
for j = 1:ntrials
    [sol, rmse] = simple_de(data_RT, bounds_RT_ddm, Np, Cr, F, G_ddm);
end
t = toc;
fprintf("DDM+RT: %.2f s\n", t / ntrials);


