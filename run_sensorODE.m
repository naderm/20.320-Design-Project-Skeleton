%% run_sensorODE.m
% The "run_sensorODE" script is the top-level code demonstrating how one 
% might simulate the "sensorODE" function. You may edit the following 
% script however you see fit except for the following command:
%
% %% Solve "sensorODE"
% [output,outputTime,input,inputTime] = sensorODE_solver(@sensorODE,...
%     sensorInput,chatter,stochasticity,maxInputAmpl,initCond);
%
% NOTES:
% This script calls the "sensorODE_solver" function. Please do not 
% make any changes to the "sensorODE_solver" code.
%
% NECESSARY FILES (they must all be in the same directory):
% - sensorODE.m
% - sensorODE_solver.m

%  Last Modified: Julia Joung, Oct 2015
%--------------------------------------------------------------------------

% Clear Workspace
close all; clear; clc;

%% Define Inputs 1 & 2
% The following matrix must be 1 x 2, where the concentration of antigen is
% in the left column and the affinity is in the right column.
sensorInput = [];
           
%% Define Initial Conditions for Each of Your Species
% The following vector must be Sn x 1, where Sn reflects the number of 
% states/species in your system.
initCond = [
    0;
];
           
%% Set Noise Flags
chatter       = false;
stochasticity = false;

%% Solve "sensorODE" - do not modify this.
% Output times will be in units of seconds.

[output,outputTime,input,inputTime] = sensorODE_solver(@sensorODE,...
    sensorInput,chatter,stochasticity,initCond);

%% Plot Results
% Simulate the sensor's response to the given (noise-free) input 
% concentrations. In your report, include the following plots:
%
% One figure that consists of 2 subplots with the following dynamic 
% outputs:
% 1.	The first subplot should depict all state dynamics as a function of
%       time. (How do the different species vary with time?)
% 2.	The second subplot should depict perforin output as a function of time.
% 
% Generate the subplot described above for the following conditions:
% 1.	Detect a low amount of neo-antigen (1 nM)
% 2.	Detect a high amount of neo-antigen (20 nM)
% 3.    Detect a high amount of background antigen (250 nM)

% For all plots, clearly label titles, axes (with units!), and legends. 
% 





