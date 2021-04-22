clear all;
clc;
%% show images;
load('USPS.mat');
A_1 = reshape(A(1,:), 16, 16);
A_2 = reshape(A(2,:), 16, 16);
figure(1);
subplot(1,2,1);
imshow(A_1');
subplot(1,2,2);
imshow(A_2')
saveas(gcf,sprintf('img%d.jpg', 0))
%% different p;
p = [10, 50, 100, 200];
error = zeros(length(p),1);
%% PCA
for i = 1:length(p)
    A_mean = mean(A,1);
    A = (A - repmat(A_mean,size(A,1),1));
    [residuals, A_pca] = pcares(A, p(i));
    error(i) = mean(mean(power(A_pca - A, 2)));
    img_1 = reshape(A_pca(1,:),16,16);
    img_2 = reshape(A_pca(2,:),16,16);
    figure;
    subplot(1,2,1);
    imshow(img_1')
    subplot(1,2,2);
    imshow(img_2')
    saveas(gcf,sprintf('img%d.jpg', i))
    %saveas((i),'jpg')
    %imwrite(img_1, sprintf('img%d.png', i));
end
%% error
figure;
plot(p,error,  '-s', 'LineWidth', 3,'Color','blue');
grid on;
xlabel('p','fontsize',20);
ylabel('Reconstruction Error','fontsize',20);
saveas(gcf,'error.jpg')
