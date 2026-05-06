% demo 1 : Supports Venn diagrams with 2–7 sets

% Generate random Boolean matrix: 500 samples, 7 sets.
boolSet = randi([0, 1], [500, 7]);
for i = 2:7
    figure()
    % Initialize Venn diagram with first i sets.
    VN = venn(boolSet(:, 1:i));
    VN.labelSet = {'A', 'B', 'C', 'D', 'E', 'F', 'G'};
    VN.draw();
end