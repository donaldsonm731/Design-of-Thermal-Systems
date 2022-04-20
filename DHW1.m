Mo_dot = 150;
v = 0.001012; %xsteam(v_pT,12.35,50); % Specific Volume of water[m^3/kg]
k = 1.327;

P1 = 12.35*0.01; % [KPa]
T1 = 50; % [C]
s1 = XSteam('s_pT', P1, T1);
h1 = 209.31;

s2 = s1;
T2 = zeros;
P2 = zeros;

for i = 13:200
    
P2(i) = i*0.01; % [KPa]

T2(i) = XSteam('T_ps', s2, P2(i));

end

T3 = 240;
s3 = 0;
for i = 13:200

P3(i) = P2(i);
h3(i) = XSteam('h_pT', P3(i), T3); % Get from the steam table with T= , P3 = P2.

end

P4 = P1;
s4 = s3;
for i = 13:200


h4(i) = XSteam('h_pT', P4, T4(i));

h2 = (v*(P2(i)-P1)) + h1;

Q_dot(i) = M_dot*(h3(i) - h4(i));

end


plot(Q_dot, P2)