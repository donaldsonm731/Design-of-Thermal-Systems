
% Change these parameters depending on if on ground or at cruising altitude 
% STP if ground, T1 = 222 K, P1 = 23.8 kPa if at cruising speed.
T1 = 300;             % K
P1 = 100;             % kPa;

Wp = 400*1000*9.81; % Newtons
cp = 1000;            % kj/K
cv = 718;             % kj/K
k = cp/cv; 

Pe = 20;
E = 45000;            % kj/kg of fuel
T3 = 1500;            % K
P4 = P1;              % kPa
P5 = P1;              % kPa

rp = 2:70;           % compression ratio
P2 = P1 .*rp;         % kPa
P3 = P2;
% Use compression ratio and polytropic relations to get T2, T4, T5.
T2 = T1 .* rp.^((k-1)/k);      % K
% E.B. across turbine/ compressor
T4 = T3 + T1 - T2 + Pe/cp;     % K
% Polytropic relation
T5 = T3 * (P5./P3).^((k-1)/k); % K
% E.B. across nozzle
V5 = sqrt(2*cp.*(T4 - T5));    % m/s

% Mass flow from balance b/w weight of plane and thrust equation (NASA)
M_dot_a = Wp ./ V5;
% Work from turbine is the power needed + work from compressor
Wt = M_dot_a .* cp .* (T2-T1) + Pe;
Q_dot = M_dot_a .* cp .*(T4-T2) + Wt;

% you can calc. mass flow of fuel from heat needed in system
M_dot_f = Q_dot/E;
M_ratio = M_dot_a ./ M_dot_f;

fprintf('\nVelocity out = %g [m/s]\n', V5(rp == max(rp)))
fprintf('Total Mass flow = %g [kg/s]\n', M_dot_a(rp == max(rp)) + M_dot_f(rp == max(rp)))
fprintf('Rp = %g\n', max(rp))
fprintf('Mass Flow Ratio = %g \n', M_ratio(rp == max(rp)))
fprintf('Mass flow of f = %g [kg/s]\n', M_dot_f(rp == max(rp)))
fprintf('Mass flow of air = %g [kg/s]\n', M_dot_a(rp == max(rp)))

subplot(2,1,1)
plot(rp, V5)
title('Nozzle Velocity as a function of Compression Ratio')
xlabel('Compression Ratio [kpa/kpa]')
ylabel('Nozzle Velocity [m/s]')
subplot(2,1,2)
plot(rp, M_ratio)
title('Mass Flow Ratio as a function of Compression Ratio')
xlabel('Compression Ratio [kpa/kpa]')
ylabel('Mass Flow Ratio [(kg/s)/(kg/s)]')
