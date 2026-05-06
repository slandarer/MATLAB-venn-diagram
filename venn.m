classdef venn < handle
% Zhaoxu Liu / slandarer (2026). venn diagram 
% (https://www.mathworks.com/matlabcentral/fileexchange/116760-venn-diagram), 
% MATLAB Central File Exchange. Retrieved April 21, 2026.
% =========================================================================
% Basic usage
% -------------------------------------------------------------------------
% %% Input format 1: Multiple arrays
%
% figure()
% A = [1, 2, 3, 4, 5];
% B = [1, 3, 5, 7];
% C = [2, 4, 6, 8];
% % Create venn diagram object and draw.
% VN1 = venn(A, B, C);
% VN1.labelSet = {'class-A', 'class-B', 'class-C'};
% VN1.draw();
%
%
% -------------------------------------------------------------------------
% %% Input format 2: An m × n Boolean matrix, with m samples and n classes.
%
% figure()
% %         [A, B, C]
% boolABC = [1, 1, 0;
%            1, 0, 1;
%            1, 1, 0;
%            1, 0, 1;
%            1, 1, 0;
%            0, 0, 1;
%            0, 1, 0;
%            0, 0, 1];
% % Create venn diagram object and draw.
% VN2 = venn(boolABC);
% VN2.labelSet = {'class-A', 'class-B', 'class-C'};
% VN2.draw();
%
%
% -------------------------------------------------------------------------
% %% Input format 3: Cell arrays with string entries
%
% figure()
% A = {'apple', 'blueberry', 'peach'};
% B = {'apple', 'cranberry', 'peach', 'mango'};
% C = {'apple', 'orange', 'lemon', 'lime'};
% 
% % Create venn diagram object and draw.
% VN3 = venn(A, B, C);
% VN3.labelSet = {'class-A', 'class-B', 'class-C'};
% VN3.draw();
%
%

    properties
        ax         % Axes for plotting
        linePnts
        labelSet = {' ', ' ', ' ', ' ', ' ', ' ', ' '};
        % labels = {'AAA', 'BBB', 'CCC', 'DDD', 'EEE', 'FFF', 'GGG'};
        labelPos
        classNum   % Number of polygons
        dataList   % Data list
        pshapeHdl  % polyshape object
        fillHdl    % Semi-transparent polygons drawn by fill
        textHdl    % Handle for rendered text
        labelHdl   % Handle for rendered labels
    end

        methods
        function obj = venn(varargin)
            if isa(varargin{1}, 'matlab.graphics.axis.Axes')
                obj.ax = varargin{1}; varargin(1) = [];
            else
                obj.ax = gca;
            end
            hold(obj.ax, 'on')
            obj.classNum = length(varargin);
            obj.dataList = varargin;

            % Added support for Boolean matrix.
            if obj.classNum == 1
                obj.classNum = size(varargin{1}, 2);
                for i = 1:obj.classNum
                    obj.dataList{i} = find(varargin{1}(:,i) > 0);
                end
            end
            

            % Load line data from mat file
            obj.linePnts = load('EdgeData.mat');
            obj.linePnts = obj.linePnts.lineData;

            % Initialize label positions for different numbers of sets
            obj.labelPos{2} = [-0.38, 0.3; 0.38, 0.3];
            obj.labelPos{3} = [-0.38, 0.3; -0.38, -0.4; 0.38, -0.4];
            obj.labelPos{4} = [-0.38, 0.2; 0.38, 0.2; -0.15, 0.3; 0.15, 0.3];
            obj.labelPos{5} = [cos(linspace(2*pi/5, 2*pi, 5) + 2*pi/5 - pi/7) .* 0.47;
                               sin(linspace(2*pi/5, 2*pi, 5) + 2*pi/5 - pi/7) .* 0.47]';
            obj.labelPos{6} = [cos(linspace(2*pi/6, 2*pi, 6) + 2*pi/3 - pi/6) .* 0.49;
                               sin(linspace(2*pi/6, 2*pi, 6) + 2*pi/3 - pi/6) .* 0.49]';
            obj.labelPos{6} = obj.labelPos{6} + [0, +0.09; -0.01, -0.04; 0, +0.015; 0, -0.1; 0, 0; 0, -0.015];
            obj.labelPos{7} = [cos(linspace(2*pi/7, 2*pi, 7) + 2*pi/5 - pi/7) .* 0.47;
                               sin(linspace(2*pi/7, 2*pi, 7) + 2*pi/5 - pi/7) .* 0.47]';
            % help venn
        end

        function obj = draw(obj)
            % warning off
            % Axes decoration
            obj.ax.XLim = [-0.5, 0.5];
            obj.ax.YLim = [-0.5, 0.5];
            obj.ax.XTick = [];
            obj.ax.YTick = [];
            obj.ax.XColor = 'none';
            obj.ax.YColor = 'none';
            obj.ax.PlotBoxAspectRatio = [1, 1, 1];
            
            % Draw semi-transparent polygons in a loop
            tcolorList = lines(7);
            for i = 1:obj.classNum
                tPData = obj.linePnts(obj.classNum).pnts{i};
                obj.pshapeHdl{i} = polyshape(tPData(:, 1), tPData(:, 2));
                obj.fillHdl(i) = fill(tPData(:, 1), tPData(:, 2), tcolorList(i, :), ...
                    'FaceAlpha', 0.2, 'LineWidth', 1.5, 'EdgeColor', tcolorList(i, :));
            end
            
            % Construct initial Boolean set
            baseData = [];
            for i = 1:obj.classNum
                baseData = [baseData; obj.dataList{i}(:)];
            end
            baseShpae = polyshape([-0.5, -0.5, 0.5, 0.5], [0.5, -0.5, -0.5, 0.5]);
            pBool = abs(dec2bin((1:(2^obj.classNum - 1))')) - 48;
            
            % Draw labels in a loop
            for i = 1:obj.classNum
                tPos = obj.labelPos{obj.classNum};
                obj.labelHdl(i) = text(tPos(i, 1), tPos(i, 2), obj.labelSet{i}, ...
                    'HorizontalAlignment', 'center', 'FontName', 'Arial', 'FontSize', 16);
            end
            
            % Calculate and draw numerical values in a loop
            for i = 1:size(pBool, 1)
                tShpae = baseShpae;
                tData  = baseData;
                for j = 1:size(pBool, 2)
                    switch pBool(i, j)
                        case 1
                            tShpae = intersect(tShpae, obj.pshapeHdl{j});
                            tData  = intersect(tData, obj.dataList{j});
                        case 0
                            tShpae = subtract(tShpae, obj.pshapeHdl{j});
                            tData  = setdiff(tData, obj.dataList{j});
                    end                 
                end
                [cx, cy] = centroid(tShpae);
                obj.textHdl(i) = text(cx, cy, num2str(length(tData)), ...
                    'HorizontalAlignment', 'center', 'FontName', 'Arial');
            end  
        end
        % =================================================================
        % Set label text content
        function obj = labels(obj, varargin)
            tlabel{length(varargin)} = ' ';            
            for i = 1:length(varargin)
                tlabel{i} = varargin{i};
            end
            obj.labelSet = tlabel;
        end
        
        % Batch set polygon properties
        function setPatch(obj, varargin)
            for i = 1:obj.classNum
                set(obj.fillHdl(i), varargin{:})
            end
        end
        
        % Set properties for a specific polygon
        function setPatchN(obj, N, varargin)
            for i = 1:obj.classNum
                set(obj.fillHdl(N), varargin{:})
            end
        end
        
        % Set font properties for numerical values
        function setFont(obj, varargin)
            for i = 1:length(obj.textHdl)
                set(obj.textHdl(i), varargin{:})
            end
        end
        
        % Set font properties for labels
        function setLabel(obj, varargin)
            for i = 1:length(obj.labelHdl)
                set(obj.labelHdl(i), varargin{:})
            end
        end
    end
    % Zhaoxu Liu / slandarer (2026). venn diagram 
    % (https://www.mathworks.com/matlabcentral/fileexchange/116760-venn-diagram), 
    % MATLAB Central File Exchange. Retrieved April 21, 2026.
end