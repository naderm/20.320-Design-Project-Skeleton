%% test_sensorODE.m
% Tests that the sensorODE_solver code runs without compile errors
%--------------------------------------------------------------------------

% Clear Workspace
close all; clear; clc;

%% Define Inputs 1 & 2
% The following matrix must be 1 x 2, where the concentration of antigen is
% in the left column and the affinity is in the right column.
sensorInput = [1, 1];
           
%% Define Initial Conditions for Each of Your Species
% The following vector must be Sn x 1, where Sn reflects the number of 
% states/species in your system.
initCond = [0];
           
%% Test Static
chatter       = false;
stochasticity = false;

[output,outputTime,input,inputTime] = sensorODE_solver(@sensorODE,...
    sensorInput,chatter,stochasticity,initCond);

%% Test Chatter
chatter       = true;
stochasticity = false;

[output,outputTime,input,inputTime] = sensorODE_solver(@sensorODE,...
    sensorInput,chatter,stochasticity,initCond);

%% Test Stochasticity
chatter       = false;
stochasticity = true;

[output,outputTime,input,inputTime] = sensorODE_solver(@sensorODE,...
    sensorInput,chatter,stochasticity,initCond);

plot(outputTime, output)
