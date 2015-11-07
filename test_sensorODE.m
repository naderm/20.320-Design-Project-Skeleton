%% test_sensorODE.m
% Tests that the sensorODE_solver code runs without compile errors
%--------------------------------------------------------------------------

% Clear Workspace
close all; clear; clc;

%% Define Inputs 1 & 2
% The following matrix must be 1 x 2, where the concentration of antigen is
% in the left column and the affinity is in the right column.
sensorInput = [1e-9, 5e-10]; % Units of M

%% Define Initial Conditions for Each of Your Species
% The following vector must be Sn x 1, where Sn reflects the number of 
% states/species in your system.
initCond = [
    0;
];
           
%% Test Static
chatter       = false;
stochasticity = false;

[output,outputTime,input,inputTime] = sensorODE_solver(@sensorODE,...
    sensorInput, chatter, stochasticity, initCond);

options = odeset('MaxStep', 1);
[output,outputTime,input,inputTime] = sensorODE_solver(@sensorODE,...
    sensorInput, chatter, stochasticity, initCond, options);

%% Test Chatter
chatter       = true;
stochasticity = false;

[output,outputTime,input,inputTime] = sensorODE_solver(@sensorODE,...
    sensorInput, chatter, stochasticity, initCond);

%% Test Stochasticity
chatter       = false;
stochasticity = true;

[output,outputTime,input,inputTime] = sensorODE_solver(@sensorODE,...
    sensorInput, chatter, stochasticity, initCond);

figure(1);
hold on;
plot(inputTime, input);
plot(outputTime, output);
hold off;

sensorInput = [1, 0.5]; % Units of nM

[output,outputTime,input,inputTime] = sensorODE_solver(@sensorODE,...
    sensorInput, chatter, stochasticity, initCond);

figure(2);
hold on;
plot(inputTime, input);
plot(outputTime, output);
hold off;
