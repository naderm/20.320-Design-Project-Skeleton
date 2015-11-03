function dydt = sensorODE(t,y,u)
% Vector 'y' contains initial conditions for each state value.
% Vector 'u' contains the input value as defined in 
% run_sensorODE.m. You do not need to modify 'u' within the code. 
% The function output should be a vector describing only dydt.


%% Define parameter rate constants


%% Define initial conditions for your species

    
% Define input conditions - don't change this
% 3 scenarios to look at: low/high neo-antigen, high background antigen
% in1 = concentration of antigen 
% in2 = affinity of antigen
in1 = u(1);
in2 = u(2);

%% Determine ODEs of the system and set dydt
% dydt should be a vector of the same size as y
dydt = [
    0;
];

end