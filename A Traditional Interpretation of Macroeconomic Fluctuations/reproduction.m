%% A Traditional Interpretation of Macroeconomic Fluctuations
clear; clc

%% database
data = load('data.mat');

%% series
figure
subplot(3,2,1)
plot(data.M)
title('M')
subplot(3,2,2)
plot(data.P)
title('P')
subplot(3,2,3)
plot(data.Y)
title('Y')
subplot(3,2,4)
plot(data.U)
title('U')
subplot(3,2,[5 6])
plot(data.W)
title('W')

%% var
model = varm(5,3);
model = estimate(model, [data.M data.Y data.P data.W data.U]);
summarize(model);

%% generate irf
[response, lower, upper] = irf(model,"NumPaths", 500, ...
    "Confidence", 0.95);

%% generate graphs

count = 1;
names = ['M', 'Y', 'P', 'W', 'U'];
figure
for i=1:5
    for j=1:5
      subplot(5,5, count) 
      plot(0:19,response(:,i,j), 'linewidth', 1.5)
      title(['Response of ' names(i) ' to ' names(j)])
      hold on
      plot(0:19,[lower(:, i,j) upper(:, i, j)],'r', 'linewidth', 1.2);
      grid on
      count = count + 1;
    end
end
