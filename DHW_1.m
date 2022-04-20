
% Febuary 6, 2020
% DOTS 
% Professor Weisensee 
% DHW 1

clc;
clear;
% This code calculates the efficiency of the max electrical power for a 
% thermal solar power plant from some given assumption in the system. 
% The process used to find this max output was to vary the Pressure at P2 
% since it was equal P3 which would optimize the power coming from the 
% turbine. Because we are varying P2 this caused some of the other variable 
% to change throughout the calculations so they were put into a for loop 
% and each iteration was recorded. In the end I found the optimized net 
% power output to 3.3854 MW at a pressure for P2 of 33.4 Bars (3340 KPa) 
% which made an efficiency of 60%.

% Known values in solar field
t1 = 240;    % [?C]
t2 = 480;    % [?C] source
t3 = 240;    % [?C]
m_dot = 150; % [KJ/Kg]
cp = 1.60;   % [KJ/Kg*k] source

% Values to find work in pump 1, which were all looked up.
v = 1/1760; % source specific volume [m^3/Kg]
l = 11;     % source length of pipe [m]
d = 0.70;     % source diameter of pipe [m]
f = 0.38;  % Friction factor got from moody diagram.
rho = 1760; % Source [Kg/ m^3]
V = 2;      % Source value m/s

% Calc. Work lost from pump in soloar field.
wp1 = v*(f*l/d*.5*rho*V^2); % [kW]

% Calc. heat rate from solar field, this q_dot is now assumed to all go 
%into the boiler and transfer to the water.
q_dot = m_dot*cp*(t2-t1) + wp1; % [KJ/s]

% Known values in the Rankine Cycle
T1 = 50;     % [?C]
P1 = .1235;  % [Bars] assumed that we are at saturated liquid.
S1 = 0.7037; % [KJ/Kg * k] 
H1 = 209.31; % [KJ/ Kg]
T3 = 240;    % [?C]
P4 = P1;     % [KPa] since condenser assumed constant pressure.
S2 = S1;     % [KJ/Kg * k] assumed pump is reversible adiabatic.
n = .85;     % isentropic efficiency of the turbine.

% We are trying to vary P2 to get maximum work.
P2 = .12:0.01:45; % I have to have pressure in Bars b/c of the XSteam func.
P3 = P2;

for i = 1:length(P2)
    
    H2(i) = XSteam('h_ps', P2(i), S2);  % [KJ/ Kg]
    H3(i) = XSteam('h_pT', P3(i), T3);  % [KJ/ Kg]
    
    S3(i) = XSteam('s_pT', P3(i), T3);  % [KJ/Kg * k] 
                                                                                                                                                                                                                                                               %S4(i) = XSteam('s_ph', P4, H4a(i));   % [KJ/Kg * k] 
    H4t(i) = XSteam('h_ps', P4, S3(i)); % [KJ/ Kg]
    H4a(i) = H3(i) - n*(H3(i)-H4t(i));  % [KJ/ Kg]
    
    M_dot(i) = q_dot/(H3(i)-H2(i));     % [KJ/Kg]
    
    Wt(i) = M_dot(i)*(H3(i)-H4a(i));    % [kW]
end

% Calc. work lost in pump in rankine cycle.
for i = 1:length(P2)
    
WP2(i) = M_dot(i)*(H2(i) - H1);

end

% Total Power out of sytem
P = Wt - wp1 - WP2;        % [kW]
P_max = max(P);            % Maximum Electrical Power output. [kW]
Pressure = P2(P == P_max); % Gets pressure at max power. [Bars]

% eff = P_max/q_dot;
eff =P_max/q_dot;
TE = 1 - (T1+273)/(T3+ 273);
M = M_dot(P == P_max);

plot(P2*100, P,'LineWidth', 2)
xlabel('Pressure [kPa]','FontSize', 15)
ylabel('Net Power [kW]','FontSize', 15)
title('Net Power as a Function of P2','FontSize', 15)

% Calc. values when P is maximized for the table
H2_max = H2(P == P_max);
H3_max = H3(P == P_max);
H4a_max = H4a(P == P_max);
S3_max = S3(P == P_max);
S4 = XSteam('s_ph', .1235, 2092.3);
T4 = XSteam('t_ps', .1235, 6.5207);
T2 = XSteam('t_ps', 1000, 0.7037); % for some reason any value above 1000
WP2_max = WP2(P == P_max);         % will result in T2 become NAN.
