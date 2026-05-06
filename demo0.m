% demo 0 : basic usage(Input format)

%% Input format 1: Multiple arrays
figure()
A = [1, 2, 3, 4, 5];
B = [1, 3, 5, 7];
C = [2, 4, 6, 8];
% Create venn diagram object and draw.
VN1 = venn(A, B, C);
VN1.labelSet = {'set-A', 'set-B', 'set-C'};
VN1.draw();



%% Input format 2: 
% An m × n Boolean matrix, 
% with m samples and n sets.
figure()
%         [A, B, C]
boolABC = [1, 1, 0;
           1, 0, 1;
           1, 1, 0;
           1, 0, 1;
           1, 1, 0;
           0, 0, 1;
           0, 1, 0;
           0, 0, 1];
% Create venn diagram object and draw.
VN2 = venn(boolABC);
VN2.labelSet = {'set-A', 'set-B', 'set-C'};
VN2.draw();



%% Input format 3: Cell arrays with string entries
figure()
A = {'apple', 'blueberry', 'peach'};
B = {'apple', 'cranberry', 'peach', 'mango'};
C = {'apple', 'orange', 'lemon', 'lime'};

% Create venn diagram object and draw.
VN3 = venn(A, B, C);
VN3.labelSet = {'set-A', 'set-B', 'set-C'};
VN3.draw();