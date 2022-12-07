classdef ActivationFunctionLayer < handle
    % The ActivationFunction class in NN (parent of ReLU, LeakyReLU...)
    %   Contain constructor and reachability analysis methods
    %   Diego Manzanas: 12/06/202
    
    properties
        Name = 'act_func_layer';
        NumInputs = 1;
        InputNames = {'in'};
        NumOutputs = 1;
        OutputNames = {'out'};
    end
    
    
    % setting hyperparameters method
    methods
        
        % constructor of the class
        function obj = ActivationFunctionLayer(varargin)           
            % author: Diego Mazanas Lopez
            % date: 12/06/2022   
            
            switch nargin
                
                case 5 % used for parsing a matlab layer
                    obj.Name = varargin{1};
                    obj.NumInputs = varargin{2};
                    obj.InputNames = varargin{3};
                    obj.NumOutputs = varargin{4};
                    obj.OutputNames = varargin{5};

                case 1
                    name = varargin{1};
                    if ~ischar(name)
                        error('Name is not char');
                    else
                        obj.Name = name;
                    end                    
                    
                case 0
                    obj.Name = 'act_func_layer';
                           
                otherwise
                    error('Invalid number of inputs (should be 0, 1 or 5)');
                                 
            end 
             
        end
        
    end
            
    methods % reachability methods
        
        % handling multiple inputs
        function images = reach_star_multipleInputs(obj, in_images, method, option, relaxFactor, dis_opt, lp_solver)
            % @in_images: an array of ImageStars
            % @method: = 'exact-star' or 'approx-star' or 'abs-dom'
            % @option: = 'parallel' or 'single' or empty
            % @relaxFactor: of approx-star method
            % @images: an array of ImageStar (if we use 'exact-star' method)
            %         or a single ImageStar set
            
            % author: Diego Manzanas Lopez
            % date: 12/06/2022
            
            images = [];
            n = length(in_images);
                        
            if strcmp(option, 'parallel')
                parfor i=1:n
                    images = [images obj.reach_star_single_input(in_images(i), method, relaxFactor, dis_opt, lp_solver)];
                end
            elseif strcmp(option, 'single') || isempty(option)
                for i=1:n
                    images = [images obj.reach_star_single_input(in_images(i), method, relaxFactor, dis_opt, lp_solver)];
                end
            else
                error('Unknown computation option');
            end
            
        end
        
        % handling multiple inputs
        function images = reach_zono_multipleInputs(obj, in_images, option)
            % @in_images: an array of ImageStars
            % @option: = 'parallel' or 'single' or empty
            % @images: an array of ImageStar (if we use 'exact-star' method)
            %         or a single ImageStar set
            
            n = length(in_images);
            images(n) = ImageZono;
                        
            if strcmp(option, 'parallel')
                parfor i=1:n
                    images(i) = obj.reach_zono(in_images(i));
                end
            elseif strcmp(option, 'single') || isempty(option)
                for i=1:n
                    images(i) = obj.reach_zono(in_images(i));
                end
            else
                error('Unknown computation option');
            end
            
        end
        
        
        % MAIN REACHABILITY METHOD
        function images = reach(varargin)
            % @in_image: an input imagestar
            % @image: output set
            % @option: = 'single' or 'parallel' 
             
            switch nargin
                
                case 7
                    obj = varargin{1};
                    in_images = varargin{2};
                    method = varargin{3};
                    option = varargin{4};
                    relaxFactor = varargin{5};
                    dis_opt = varargin{6};
                    lp_solver = varargin{7};
                
                case 6
                    obj = varargin{1};
                    in_images = varargin{2};
                    method = varargin{3};
                    option = varargin{4};
                    relaxFactor = varargin{5};
                    dis_opt = varargin{6};
                    lp_solver = 'glpk';
                
                case 5
                    obj = varargin{1};
                    in_images = varargin{2};
                    method = varargin{3};
                    option = varargin{4};
                    relaxFactor = varargin{5};
                    dis_opt = [];
                    lp_solver = 'glpk';
                        
                case 4
                    obj = varargin{1};
                    in_images = varargin{2};
                    method = varargin{3};
                    option = varargin{4};
                    dis_opt = [];
                    lp_solver = 'glpk';
                
                case 3
                    obj = varargin{1};
                    in_images = varargin{2};
                    method = varargin{3};
                    option = 'single';
                    dis_opt = [];
                    lp_solver = 'glpk';
                    
                otherwise
                    error('Invalid number of input arguments (should be 2,3,4,5 or 6)');
            end
            
            if strcmp(method, 'approx-star') || strcmp(method, 'abs-dom') || contains(method, 'relax-star')
                images = obj.reach_star_multipleInputs(in_images, method, option, relaxFactor, dis_opt, lp_solver);
            elseif strcmp(method, 'approx-zono')
                images = obj.reach_zono_multipleInputs(in_images, option);
            else
                error('Unsupported reachability method');
            end         

        end
                 
    end
    
end

