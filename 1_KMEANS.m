clc;
clear all;
%% generate data points
% class A
%mu1 = [-2 0];
%sigma1 = [1 0; 0 1];
load('ca.mat');
% class B
%mu2 = [2 0];
%sigma2 = [1 0; 0 1];
load('cb.mat');
%% plot points
figure(1);
plot(class_A(:,1), class_A(:,2), 'ro');
hold on;
plot(class_B(:,1), class_B(:,2), 'b*');
grid on;
xlabel('x','fontsize',20);
ylabel('y','fontsize',20);
xlim([-6 6]);
ylim([-6 6]);
saveas(gcf,'Random data points.jpg')
%% clustering
data = [class_A; class_B;];
[prediction center] = k_means(data, 2,0.01);
[m, n] = size(prediction);
%% plot clustering results
figure(2);
hold on;
for i=1:m
    if prediction(i, 1) == 1
        plot(data(i, 1), data(i, 2), 'ro'); 
    else 
        plot(data(i, 1), data(i, 2), 'b*');
    end
end
grid on;
plot(center(:,1), center(:,2), 'c+','MarkerSize', 16,'LineWidth',3);
xlabel('x','fontsize',20);
ylabel('y','fontsize',20);
xlim([-6 6]);
ylim([-6 6]);
saveas(gcf,'KMEANS_result.jpg')
acc=0;
for j=1:m
    if prediction(j, 1) == 1 && j<201
        acc=acc+1;
    end
    if prediction(j, 1) == 2 && j>200
        acc=acc+1;
    end
end
accuracy=acc/400;
%% k_means function
function [label center] = k_means(data, k, epsilon)
[m, n] = size(data);
label = zeros(m, 1);
center = zeros(k, n);
u = zeros(k, n);% last center;
c = zeros(k, n); % new center;
%initialization
t = 1;
for i=1:k
    u(i, :) = data(t, :);
    t = t + m/k;
end


while true
    for i=1:m
        distance = zeros(k, 1);%distance between data and center;
        for j=1:k
            sum_dis = 0;
            for t=1:n
                sum_dis = sum_dis + (u(j, t) - data(i, t))^2;
            end
            distance(j) = sqrt(sum_dis);
        end       
        [~, index] = sort(distance);%clustering, find the closest distance.
        %label(i, 1:2) = data(i, :);
        label(i, 1) = index(1);
    end
    
    for i=1:k
        total_dis = zeros(1, n);
        num_i = 0;
        for j=1:m
            if label(j, 1) == i
                for t=1:n
                    total_dis(1, t) = total_dis(1, t) + data(j, t);
                end
                num_i = num_i + 1;
            end
        end
        c(i, :) = total_dis(1, :)/num_i;
    end
    
    if norm(c-u) < epsilon
        center=c;
        break;
    end
    u = c;
end
end
