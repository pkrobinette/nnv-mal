classdef kFCOut5Layer1327022 < nnet.layer.Layer & nnet.layer.Formattable
    %kFCOut5Layer1327022
    % Auto-generated by MATLAB on 07-Apr-2022 14:19:29
    
    
    properties
        % Non Trainable Parameters
        
    end
    
    properties (Learnable)
        % Trainable parameters
        FCOut5Kernel
    end
    
    properties (Hidden)
        % Code literals
        
    end
    
    methods
        function obj = kFCOut5Layer1327022(Name, Type)
            obj.Name = Name;
            obj.Type = Type;
            obj.NumInputs = 1;
            obj.NumOutputs = 1;
        end
        
        function varargout = predict(obj, inputs)
            [temp{1}] = FCOut5Layer1327022(inputs, obj.FCOut5Kernel, obj);
            
            % Extract results from function call.
            varargout{1} = temp{1}.value;
        end
    end
end

function [identity] = FCOut5Layer1327022(inputs, matmulReadvariableopResource, obj)
import mlp_nn.ops.*;
[inputs] = struct('value', inputs, 'rank', 2);

% % Unsupported operator: Sign
% output: steSign8Sign
% inputs: inputs
error('Unsupported TensorFlow operator.');
steSign8AddY.value = single(0.1);
steSign8AddY.rank = 0;
% Operation
[steSign8Add] = tfAdd(steSign8Sign, steSign8AddY);
% % Unsupported operator: Sign
% output: steSign8Sign1
% inputs: steSign8Add
error('Unsupported TensorFlow operator.');
steSign8Identity.value = steSign8Sign1.value;
steSign8Identity.rank = steSign8Sign1.rank;
[steSign8IdentityN{1}, steSign8IdentityN{2}] = tfIdentityN(steSign8Sign1, inputs);
steSign8IdentityN.rank = steSign8Sign1.rank;
MatMulReadVariableOp.value = matmulReadvariableopResource;
MatMulReadVariableOp.rank = 2;
% % Unsupported operator: Sign
% output: MatMulSteSign7Sign
% inputs: MatMulReadVariableOp
error('Unsupported TensorFlow operator.');
MatMulSteSign7AddY.value = single(0.1);
MatMulSteSign7AddY.rank = 0;
% Operation
[MatMulSteSign7Add] = tfAdd(MatMulSteSign7Sign, MatMulSteSign7AddY);
% % Unsupported operator: Sign
% output: MatMulSteSign7Sign1
% inputs: MatMulSteSign7Add
error('Unsupported TensorFlow operator.');
MatMulSteSign7Identity.value = MatMulSteSign7Sign1.value;
MatMulSteSign7Identity.rank = MatMulSteSign7Sign1.rank;
[MatMulSteSign7IdentityN{1}, MatMulSteSign7IdentityN{2}] = tfIdentityN(MatMulSteSign7Sign1, MatMulReadVariableOp);
MatMulSteSign7IdentityN.rank = MatMulSteSign7Sign1.rank;
% Mat Mul
[MatMul] = tfMatMul(steSign8IdentityN{1}, MatMulSteSign7IdentityN{1}, 0, 0);
Identity.value = MatMul.value;
Identity.rank = MatMul.rank;

% assigning outputs
identity = Identity;
end
