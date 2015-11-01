function [output,outputTime,input,inputTime] = ...
    sensorODE_solver(sensorODE_fh,inputStates,chatter,stochasticity,...
    initCond, options)
% THIS FUNCTION SHOULD NOT BE MODIFIED
% The "sensorODE_solver" function solves the "sensorODE" model.
%
% USAGE:
% [output,outputTime,input,inputTime] = 
%   sensorODE_solver(sensorODE_fh,inputStates,chatter,stochasticity,...
%   maxInputAmpl,initCond)
% 
%
% FUNCTION INPUTS:
%   sensorODE_fh - (1 x 1 function handle) 
%      Function handle to the sensor model (where you stored the ODEs).
%
%   inputStates - (1 x 2 number)  
%      The antigen input to the model. Represents the concentration and affinity
%      of antigen detected by the liposome.
%
%   chatter - (1 x 1 logical) 
%      This is a flag denoting the presence of noise due to instrument
%      chatter. 
%      Note: If "stochasticity" is "true" this variable must be false.
%
%   stochasticity - (1 x 1 logical) 
%      This is a flag denoting the presence of noise due to stochastic 
%      fluctuations.
%      Note: If "chatter" is "true" this variable must be false.
% 
%   initCond - (Sn x 1 number)
%      This vector denotes the initial state conditions for the "sensorODE"
%      function, where Sn reflects the number of state variables in the 
%      system. 
%      This is the vector with the initial conditions for each of your 
%      species in your ODE model.
%
%   options - (1 x 1 options)
%       Optional argument to pass options to ode23s. This can be used to change
%       the solver tolerance in cases where your output is accidentally dropping
%       into negative values.
%
%
% FUNCTION OUTPUTS:
%   output - (Sn x T numbers) 
%      A matrix depicting the solution to your ODEs where Sn is the number
%      of states or differential equations in the model, and T is the
%      length of the time vector.
%
%   outputTime - (1 x T numbers) 
%      A vector of the simulated time values (for the ODE system).
%
%   input - (1 x T numbers) 
%      A vector of the sensor's input values.
%
%   inputTime - (1 x T numbers) 
%      A vector of the simulated time values (for the interpolated input).
%
%
% DESCRIPTION:
%   This function solves the ODE system characterizing the sensor's
%   dynamics. The "sensorODE" function should be of the form:
%   "dydt=sensorODE(t,y,u)" where "u" reflects the input values at a given 
%   simulations time, t.
%
%   Noise due to chatter is a Bernoulli process random variable
%   where the probability of unsuccessful transmission is set to 0.02.
%   Therefore, the static Boolean type input will "chatter" 2-percent of 
%   the time, flipping between 'true' and 'false', or vice versa. 
%
%   Noise due to stochastic effects is defined as a white Gaussian 
%   variable with a mean of 0 and a variance of 1-percent of the magnitude
%   of the input.
%
%
% LAST MODIFIED:
% Oct 2015 by Julia Joung
%
%--------------------------------------------------------------------------

%% Check input arguments
narginchk(2,7)

% Error flags if something is wrong:
if ~isa(sensorODE_fh, 'function_handle')
    error('sensorODE_solver:sensorODE_fhChk',...
          '%s is not a valid fuction handle.',...
          func2str(sensorODE_fh))
end

if ~isequal(size(inputStates,2),2)
    error('sensorODE_solver:inputStatesChk',...
    'The ''inputStates'' argument must be a 1 x 2 matrix')
end

if ~islogical(chatter)
    error('sensorODE_solver:chatterChk',...
        'The ''chatter'' flag must be set to ''true'' or ''false''.')
end

if ~islogical(stochasticity)
    error('sensorODE_solver:stochasticityChk',...
        'The ''stochasticity'' flag must be set to ''true'' or ''false''.')
end

if chatter && stochasticity
    error('sensorODE_solver:chatterAndstochasticityChk',...
'The ''chatter'' and ''stochasticity'' flags may not be ''true'' simultaneously.')
end

%% Define simulation time characteristics
nSteps = size(inputStates,1); % = 1
tStep = 180; % in seconds (3 minutes)
tMax  = tStep*nSteps; % = 180
tSpan = [0,tMax-1];

%% Define input characteristics
inputTime = 0:1:tSpan(end);

%% Create input vectors
input = [];
for aStep = 1:nSteps % = 1
    thisStepVector = repmat(inputStates(aStep,:),tStep,1);
    input = [input thisStepVector']; % have a vector over time for inputs
end

if chatter
    noiseProb = 0.02;
    randV = rand(size(inputStates,1),tMax);
    input(randV<noiseProb) = ~input(randV<noiseProb);
end

if stochasticity
    noiseMean = 0;
    noiseVar = .01/max(inputStates(1,:));
    input = abs(input+(noiseMean + sqrt(noiseVar)*randn(2,tMax)));
end

if nargin < 7
    options = odeset();
end

%% Define the initial conditions and run ODE solver with noise
y0 = initCond;
[outputTime,output] = ode23s(@(t,y) sensorODEVectorInputs(sensorODE_fh,...
    t,y,inputTime,input),tSpan,y0, options);

end

function dydt = sensorODEVectorInputs(sensorODE_fh,t,y,inputTime,input)
in1 = interp1(inputTime,input(1,:),t);
in2 = interp1(inputTime,input(2,:),t);
dydt = sensorODE_fh(t,y,[in1;in2]);
end
