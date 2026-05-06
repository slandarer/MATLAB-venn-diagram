% demo 3 : Loop to set polygon colors
boolSet = randi([0, 1], [500, 7]);

% Create Venn diagram object and draw.
VN = venn(boolSet);
VN = VN.labels('AAA','BBB','CCC','DDD','EEE','FFF','GGG');
VN = VN.draw();

% Loop to set polygon(patch) colors.
colorList = [78 101 155; 138 140 191; 184 168 207;
            231 188 198; 253 207 158; 239 164 132; 182 118 108]./255;
for i = 1:7
    VN.setPatchN(i, 'FaceColor',colorList(i,:), 'EdgeColor',colorList(i,:))
end