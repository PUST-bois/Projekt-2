function dmc_error = dmc_eval(N, Nu, D, Dz, lambda)
%% Obliczanie parametrow off-line
load s.mat

u_pp = 0;
y_pp = 0;
z_pp = 0;



if N > size(s_z)
    s_z(length(s_z):N) = s_z(length(s_z)-1);
end
if N > size(s_u)
    s_u(length(s_u):N) = s_u(length(s_u)-1);
end

% Macierz M
M = zeros(N,Nu);
for i = 1:size(M,1)
    for j = 1:size(M,2)
        if i>=j
            M(i,j) = s_u(i-j+1);
        end
    end
end
% Macierz Mp
Mp = zeros(N,D-1);
for i = 1:size(Mp,1)
    for j = 1:size(Mp,2)
        if i+j<D
            Mp(i,j) = s_u(i+j) - s_u(j);
        else
            Mp(i,j) = s_u(D) - s_u(j);
        end
    end
end
% Macierz Mzd
Mzd = zeros(N,Dz-1);
for i = 1:size(Mzd,1)
    for j = 1 :size(Mzd, 2)
        if i+j<Dz
            Mzd(i,j) = s_z(i+j) - s_z(j);
        else
            Mzd(i,j) = s_z(Dz) - s_z(j);
        end
    end
end
Mzd = [s_z(1:N)' Mzd];

% Macierz K
K = ((M'*M + lambda*eye(Nu))^-1)*M';
ke = sum(K(1,:));
ku = zeros(D-1,1);
for i = 1:D-1
    ku(i) = K(1,:) * Mp(:,i);
end
kz = zeros(Dz, 1);
for i = 1:Dz
    kz(i) = K(1,:) * Mzd(:,i);
end

%% Symulacje dla zerowego zaklocenia

t_sim = 500;

y = zeros(t_sim, 1);
u = zeros(t_sim, 1);
z = zeros(t_sim, 1);
y_zad = zeros(t_sim, 1);
y_zad(200:end) = 1;
e = zeros(t_sim, 1);
du = zeros(t_sim, 1);
dz = zeros(t_sim, 1);

for k=3:t_sim
   
    if k-7 <= 0
        y(k) = symulacja_obiektu6y(u_pp,u_pp,z_pp,z_pp, y(k-1),y(k-2));
    else
        y(k) = symulacja_obiektu6y(u(k-6),u(k-7),z_pp, z_pp, y(k-1),y(k-2));     
    end
    % Uchyb
    e(k) = y_zad(k)-y(k);
    
    % Obliczanie sum
    sum_ku = 0;
    for i = 1:D-1
        if k-i > 1
            sum_ku = sum_ku + ku(i) * du(k-i);
        end
    end
    sum_kz = 0;
    for i = 1:Dz
        if k-i-1 > 1
            sum_kz = sum_kz + kz(i) * dz(k-i-1);
        end
    end
    
    % Obliczanie przyrostu sterowania
    du(k) = ke*e(k) - sum_ku - sum_kz;
    % Obliczenie przyrostu zaklocenia
    dz(k) = z(k) - z(k-1);
   
    %Obliczenie sterowania
    u(k) = u(k-1) + du(k);
    
end

% Wskaznik jakosci E
dmc_error = sum((y_zad-y).^2);
figure;
subplot(2, 1, 1);
yticks([0, 0.5, 1, 1.5])
plot(0:t_sim-1, y, 'r')
hold on
plot(0:t_sim-1, y_zad, '--b')
hold off
subplot(2, 1, 2);
plot(0:t_sim-1, u, 'g')

