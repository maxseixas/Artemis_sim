close all; clear all;
%For ephermeris data:   https://ssd.jpl.nasa.gov/horizons/app.html#/ 


data_artemis = load('artemis.txt');
data_L1_artemis = load('L1_artemis.txt');
data_Earth_artemis = load('Earth_artemis.txt');


%% L1 Halo Orbit Construction

R = 40000;  % orbital radius in km
P = 12.25*24*60;  % orbital period in minutes - 12.25 day period
w = 2*pi/P;  % angular velocity
theta = 0; 
data_orbit = zeros(size(data_L1_artemis));  % preallocate output array

for i = 1:length(data_L1_artemis(:,1))
    t = i;  % current time in minutes
    r = R*[cos(theta+w*t) sin(theta+w*t) 0]';  % calculate new position
    data_orbit(i,1:3) = data_L1_artemis(i,1:3) + r';  % add to L1 position
end


%% Artemis 1

figure;
plot3(data_artemis(:,1),data_artemis(:,2),data_artemis(:,3))
hold on;
plot3(0, 0, 0, 'ro', 'MarkerFaceColor', 'r', 'MarkerSize', 10)
hold on;
plot3(data_L1_artemis(:,1),data_L1_artemis(:,2),data_L1_artemis(:,3))
hold on;
plot3(data_Earth_artemis(:,1),data_Earth_artemis(:,2),data_Earth_artemis(:,3))
hold on;
plot3(data_orbit(:,1),data_orbit(:,2),data_orbit(:,3))
hold off;
legend('Artemis 1 Trajectory', 'Moon', 'EM-L1','Earth','Halo Orbit');
grid on;
title('Ephemeris Data for Artemis 1')




FOV = deg2rad(1.5); %1.5 degrees

N = 200;
spotting_list = [];
for j = 1:N
    dir_to_poi= [];
    spotted = [];
    for i = 1:length(data_artemis)
        POV = randn(1,3);
        POV = POV/norm(POV);
        dir_to_poi(i,1:3) = data_artemis(i,1:3) - data_L1_artemis(i,1:3);
        angle_to_poi = acos(dot(dir_to_poi(i,1:3), POV) / norm(dir_to_poi(i,1:3)));
        if angle_to_poi < FOV / 2
            spotted(end+1) = i;
        end
    end
    spotting_list(j) = length(spotted);
end


disp(mean(spotting_list))
