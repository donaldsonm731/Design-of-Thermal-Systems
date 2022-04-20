% Calc  heat energy from radiation
A_ceil = 2200;                                             % m^2
e = 0.2;                                                   % no units
sigma = 5.67*10^-8;                                        % W/m^2*k^4
T_ceil = 283;                                              % K
T_ice = 269;                                               % K

Q_dot_rad = A_ceil*e*sigma*(T_ceil^4 - T_ice^4)/1000 + 13; % kW

% Calculate Re
V_air = 0.4;                                               % m/s 
L = 60;                                                    % m
v_air = 1.426*10^-5;                                        % m^2/s

Re = V_air*L/v_air;                                        % no units
Pr = 0.7336;                                               % no units

% Calc. Nu
Nu = 0.664*Re^.5*Pr^(1/3);                                 % no units
kf = 2.18;                                                 % W/m^2 K

% Calc. heat energy from convection
h = Nu*kf/L;                                               % W/m K
A_ice = 1800;                                              % m^2
T_air = 283;                                               % K

Q_dot_conv = A_ice*h*(T_air-T_ice)/1000;                   % kW

% Calc heat transfer from conduction by setting it equal to radiation and
% convection so that we know how much heat to take out throug convection to
% keep the ice at -4 C.
Q_dot_cond = Q_dot_conv + Q_dot_rad;                       % kW

% From this you can calculate what the temperature of the water needs to be
% and the mass flow rate.
m_dot = 0:0.1:10;                                          % kg/s
T7 = 253:0.1:263;                                          % K
cp = 4.18*10^3;                                            % kJ/kg 

% These two for loops calculate the temperature of brine water after the 
% ice slab when using different values for mass flow rate of the brine and
% the input temperature of teh brine. In the workspace the columns are when
% the mass flow rate is changeing as temperature is held constant at a
% certain value. The rows are the values when temperature changes and the 
% mass flow rate stays the same.
for j = 1:length(m_dot)
for i = 1:length(m_dot)
        
T5(i,j) = Q_dot_cond / (m_dot(i)*cp) + T7(j);              % K

end
end

% Calc. work of  brine pump
T6 = 265;
v_w = 1.676*10^-3;                                         % Pa*s
l = 10;                                                    % m
D = 0.2;                                                   % m 
f = 0.038;                                                 % unitless
rho = 1.1478/1000 * 100^3;                                               % g/ cm^3
Ac = pi()*D^2/4;                                           % m^2
V_w = m_dot./(rho*Ac);                                     % m/s
W_dot_pump56 = m_dot.*cp.*(T5-T6) + V_w*f*l/D*0.5*rho*V_w.^2;     % kW

% Calc. work of  freon pump
T1 = 253;
T4 = 248;
v_w = 1*10^-5;                                         % Pa*s
l = 10;                                                    % m
D = 0.2;                                                   % m 
f = 0.038;                                                 % unitless
rho = 2;                                                    % g/ cm^3
Ac = pi()*D^2/4;                                           % m^2
V_w = m_dot./(rho*Ac);                                     % m/s
W_dot_pump14 = m_dot.*cp.*(T1-T4) + V_w.*f*l/D*0.5*rho.*V_w.^2;     % kW


% Calculating power output
P = W_dot_pump56 + W_dot_pump14;                                              % kW




