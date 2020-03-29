%% ZAD1
%wyznaczanie y_pp dla u_pp = 1.1
u_pp = 0.0;
z_pp = 0.0;

t_sim = 300;
y = [2;2];

for k=2:t_sim
    y_temp = symulacja_obiektu6y(u_pp,u_pp,z_pp,z_pp,y(k),y(k-1));
    y = [y;y_temp];
end

figure(1)
stairs(0:t_sim,y)
title('Przebieg sygna³u wyjœciowego dla ustalonego U_{PP}')
xlabel('k')
ylabel('y')

y_pp = y(end);


%% ZAD2
t_sim2 = 300;

%-----------U part-------------
u_step_tim = 0;
u_step_val = [1,1.5,2,-1,-1.5, -2];
u_track_num = length(z_step_val);

u_base = ones(1,u_step_tim)*u_pp;
y_u_all = [];
for track = 1:u_track_num
    u_step = ones(1,t_sim2 - u_step_tim) * u_step_val(track);
    u = [u_base, u_step];
    
    y = ones(1,t_sim2)*y_pp;
    for k = 3:t_sim2
        if k-7 <= 0
            y(k) = symulacja_obiektu6y(u_pp,u_pp,z_pp,z_pp, y(k-1),y(k-2));
        else
            y(k) = symulacja_obiektu6y(u(k-6),u(k-7),z_pp, z_pp, y(k-1),y(k-2));      
        end
    end
    y_u_all = [y_u_all; y];
end


%-----------Z part-------------
z_step_tim = 0;
z_step_val = [1,1.5,2,-1,-1.5, -2];
z_track_num = length(z_step_val);

z_base = ones(1,u_step_tim)*z_pp;
y_z_all = [];
for track = 1:z_track_num
    z_step = ones(1,t_sim2 - z_step_tim) * z_step_val(track);
    z = [z_base, z_step];
    
    y = ones(1,t_sim2)*y_pp;
    for k = 3:t_sim2
        if k-7 <= 0
            y(k) = symulacja_obiektu6y(u_pp,u_pp,z_pp,z_pp, y(k-1),y(k-2));
        else
            y(k) = symulacja_obiektu6y(u_pp,u_pp,z(k-3),z(k-4), y(k-1),y(k-2));      
        end
    end
    y_z_all = [y_z_all; y];
end


figure(2)
hold on
for track = 1:u_track_num
    stairs(y_u_all(track,:))
end

figure(3)
hold on
for track = 1:z_track_num
    stairs(y_z_all(track,:))
end