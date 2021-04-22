clc;
clear all;
%% load data;
load('ca.mat');
load('cb.mat');
data = [class_A; class_B;];
K=2;
sigma=1;
DIS=pdist(data);
W=squareform(DIS);
%% clustering
prediction = spectral(W,sigma, K);
m=400;
figure;
hold on;
for i=1:m
    if prediction(i, 1) == 1
        plot(data(i, 1), data(i, 2), 'ro'); 
    else 
        plot(data(i, 1), data(i, 2), 'b*');
    end
end
grid on;
xlabel('x','fontsize',20);
ylabel('y','fontsize',20);
xlim([-6 6]);
ylim([-6 6]);
saveas(gcf,'Spectral_KMEANS_result.jpg')
%% ACCURACY
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
function C = spectral(W,sigma, K)
    format long
    m = size(W, 1);
    W = (-W.*W)/(2*sigma^2);
    SI = full(spfun(@exp, W));
    DU = full(sparse(1:m, 1:m, sum(SI)));
    LAP = eye(m)-(DU^(-1/2) * SI * DU^(-1/2));
    [V, ~] = eigs(LAP, K, 'SM');
    C=kmeans(V,K);
end
