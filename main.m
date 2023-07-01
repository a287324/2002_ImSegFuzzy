clearvars; clc; close all;

B = struct;
W = struct;
B_init_interval = 30;
W_init_interval = 30;

% 讀取影像
im = imread('test2.bmp');
im = im(:,:,1);

% 找出灰度直方圖
Hgray = reshape(0:255, 1, 1, []);
Hgray = reshape(sum(sum(im == Hgray)), [], 1);

% 設定初始的模糊集合(B和W)的元素
reg = find(Hgray > 0);
B.element = reg(1:B_init_interval);
W.element = reg((end-W_init_interval+1):end);
Rfuzzy = ((max(B.element)+1):(min(W.element)-1));
B.IF = zeros(256,1);
W.IF = zeros(256,1);

% 尋找閥值
for n = Rfuzzy
    % 將元素n加入集合B和W
    regB = [B.element; n];
    regW = [W.element; n];
    
    % 計算IF
    B.IF(n) = CalcIF(regB, Hgray, 'Z');
    W.IF(n) = CalcIF(regW, Hgray, 'S');
    
    if W.IF(n) < B.IF(n)
        W.element = regW;
    else
        B.element = regB;
    end
end

% 找出閥值
reg = abs(W.IF-B.IF);
[~,T] = min(reg(Rfuzzy));
T = T + Rfuzzy(1)-1;
% 顯示原影像
figure(1); imshow(im); title('Original Image');
% 灰度直方圖
figure(2); 
plot(Hgray./max(Hgray), 'Color', 'b', 'LineWidth', 2);  hold on;
uB = CalcMembershipFun(B.element, Hgray, 'Z');
uW = CalcMembershipFun(W.element, Hgray, 'S');
plot(uB, 'Color', 'g', 'LineWidth', 2); hold on;
plot(uW, 'Color', 'r', 'LineWidth', 2);
title('Histogram of gray level');
xlabel('Gray level');
axis([0, 255, -inf, inf])
% 顯示集合的模糊指標
f3 = figure(3);
plot(B.IF, 'Color', 'b', 'LineWidth', 2); hold on;
plot(W.IF,  'Color', 'r', 'LineWidth', 2);
title('IF(index of fuzziness)');    
xlabel('Gray level');   ylabel('Index of fuzziness');
axis([0, 255, 0, 0.6])
line([T, T], W.IF(T)+[-0.03 0.03], 'Color', 'k', 'LineWidth', 1);
legend('IF(B)', 'IF(W)', 'threshold');
% 顯示閥值結果圖
figure(4);  imshow(im > T); title('Result')
