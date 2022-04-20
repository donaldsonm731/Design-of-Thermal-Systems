% Calc  heat energy from radiation
A_ceil = 2200;                                             % m^2
e = 0.2;                                                   % no units
sigma = 5.67*10^-8;                                        % W/m^2*k^4
T_ceil = 283;                                              % K
T_ice = 269.5;                                             % K

Q_dot_rad = A_ceil*e*sigma*(T_ceil^4 - T_ice^4)/1000 + 13; % kW

% Calculate Re
V_air = 0.4;                                               % m/s 
L = 60;                                                    % m
v_air = 1.426*10^-5;                                       % m^2/s

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
          
% Now that the heat transfer from the ice has been calculated to keep the
% ice at 4 C, We will not assume that the amount of heat transfer is going 
%to be the same from the ice and the H.E. Tofind mass flow rate and other parameters by varying
% the pressure in the freon system.
% constants
P_23 = 1300;                                               % kpa
T3 = 34;                                                   % celsius
h4= 342 ;                                                  % kj/kg

p1= [208,227,247,268,291,315,341,369,398,430,463,498,535,574,615,686,705,...
    753,804,857];                                          % kPa
T1= [-18,-16,-14,-12,-10,-8,-6,-4,-2,0,2,4,6,8,10,12,14,16,18,20]+273;
                                                           % K
h1= [1422.7,1425.3,1427.9,1430.5,1433,1435.3,1437.6,1439.9,1442.2,1444.4,...
    1446.5,1448.5,1450.6,1452.5,1454.3,1456.1,1457.8,1459.5,1461.1,1462.6];
                                                           % kj/kg

% T2 is then calculated using isentropic relations and an h value is then
% looked up in the tables
T2= (((P_23./p1).^.237).*(T1));                            % K
h2=[1705,1691,1680,1667,1655,1642,1638,1628,1615,1605,1595,1585,1575,...
    1565,1555,1545,1539,1532,1525,1518];                   % kJ/ kg

% Now to  calculate the amount of heat transfer that the freon can do at
% the H.E.
Q_dot_HE = Q_dot_cond;                                     % kW

% Calc. mass flow rate of freon at with diff. enthalpies that correspond to
% changing values of pressure.
m_dot_fr = Q_dot_HE./(h1-h4);                              % kg/s

% Calc. the work of the freon pump.
l = 10;                                                    % m
D = 0.2;                                                   % m 
f = 0.038;                                                 % unitless
rho = 2;                                                   % g/ cm^3
Ac = pi()*D^2/4;                                           % m^2
V_b = m_dot_fr ./ (rho*Ac);                                % m/s

W_fp = m_dot_fr.*(h2-h1) + V_b .*f .*(l/D) .*0.5 .*rho .*(V_b.^2);
                                                           % kW

% Now to calc. the work from the brine pump. To do this and trying to make
% it more realistic I set the value for brine water temperature after the
% HE(T7) to be a little lower than what the freon would be after it takes
% the heat from the water(266 is a random number).
T7 = T1;                                                   % K
               
% Now to calc. the mass flow rate of the brine water assuming a fixed vale
% before the H.E.
T6 = 261:280;                                               % K
cp_b = 3.4;                                                % kJ/kg K
for i = 1:length(T6) 
    for j = 1:length(T7)
        m_dot_b(j,i) = Q_dot_HE./(cp_b*(T7(j)-T6(i)));                        % kg/s
    end
end
% Calc the temperature after the slab of ice so I can calc. the work
% from the brine pump w/ friction.
l = 10;                                                    % m
D = 0.2;                                                   % m 
f = 0.038;                                                 % unitless
rho = 1.1478/1000*100^3;                                   % kg/m^3
Ac = pi()*D^2/4;                                           % m^2
V_b = m_dot_b ./ (rho*Ac);                                 % m/s      

W_bp =(((m_dot_b./(rho*Ac)).^3).*Ac.*(f*l*rho/(2000*D)));
                                                           % kW
W_t = W_fp + W_bp;                                         % kW
figure
contourf(p1,T6,W_bp,20)
title('Brine Pump Power as a Function of P1 and T6')
xlabel('Pressure (kPa)')
ylabel('Temperature (K)')
c = colorbar;
c.Label.String = 'Brine Pump Work (kW)';

%figure
%plot(p1,W_t(:,2:2:20),'linewidth', 4)
%title('Power as a Function of Pressure at State 1')
%xlabel('Pressure (kPa)')
%ylabel('Power (kW)')
%axis([200 650 2100 2550])
%legend(['T6 = 262';'T6 = 264';'T6 = 266';'T6 = 268';'T6 = 270';...
       % 'T6 = 272';'T6 = 274';'T6 = 276';'T6 = 278';'T6 = 280'])

%figure
%plot(T6, W_bp(4:2:20,:),'linewidth', 4)
%title('Power of Brine Pump as a Function of Temperature at State 6')
%xlabel('Temperature (K)')
%ylabel('Power (kW)')
%axis([260 278 -8 8])
%legend(['p1 = 208';'p1 = 227';'p1 = 247';'p1 = 291';'p1 = 270';])
        





