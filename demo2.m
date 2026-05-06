% demo 2 : Property setting.
% Generate random data for 7 sets (100 samples each)
X1 = randi([1, 500], [100, 1]);
X2 = randi([1, 500], [100, 1]);
X3 = randi([1, 500], [100, 1]);
X4 = randi([1, 500], [100, 1]);
X5 = randi([1, 500], [100, 1]);
X6 = randi([1, 500], [100, 1]);
X7 = randi([1, 500], [100, 1]);
XX = {X1, X2, X3, X4, X5, X6, X7};

% Create Venn diagram object and draw.
VN = venn(XX{1:7});
VN = VN.labels('AAA', 'BBB', 'CCC', 'DDD', 'EEE', 'FFF', 'GGG');
VN = VN.draw();

%% Property settings for the Venn diagram appearance
% Batch set properties for all polygons (black fill and black edges)
VN.setPatch('FaceColor', [0, 0, 0], 'EdgeColor', [0, 0, 0])
% Set properties for the first polygon specifically (dark red fill, black edges)
VN.setPatchN(1, 'FaceColor', [0.5, 0, 0], 'EdgeColor', [0, 0, 0])
% Set font properties for numerical value text (red color, size 14)
VN.setFont('Color', [0.9, 0, 0], 'FontSize', 14)
% Set font properties for category labels (blue color, size 25, Cambria font)
VN.setLabel('Color', [0, 0, 0.9], 'FontSize', 25, 'FontName', 'Cambria')