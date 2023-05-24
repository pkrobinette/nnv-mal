function export2vnnlib(lb, ub, outsize, property, name)
% Export verification property to vnn-lib format
% lb = vector (double)
% ub = vector (double)
% outsize = scalar (double)
% property = HalfSpace(s)
%
% author: Diego Manzanas Lopez
% date: April 20th, 2023

% Main steps of the function
% 1) declare output and input variables (X_x, Y_y)
% 2) define input bounds (inequalities)
% 3) define output bounds/inequalities of property to verify

% Assumptions
% - Only one input set possible
% - Only one halfSpace for the output 
% Notes
% - can extend this if needed, but properties introduced match these assumptions
% - Output constraints are limited to comparing 2 indexes or comparing one index to a value from g
% - Seems like vnncomp sets the output properties as to find a counterexample

precision = '%.16g'; 

% Create file
fID = fopen(name, 'w');

% 1) Declare variables based on I/O sizes

% Inputs
nI = numel(lb);
for i=0:nI-1
    fprintf(fID,"(declare-const X_"+string(i) + " Real)\n");
end
fprintf(fID,"\n\n");

% Outputs
for i=0:outsize-1
    fprintf(fID,"(declare-const Y_"+string(i) + " Real)\n");
end
fprintf(fID,"\n\n");

% 2) Define output bounds (looks like ub value goes before lb
for i=0:nI-1
    fprintf(fID,"(assert (<= X_"+string(i)+ " " + num2str(ub(i+1), precision)+ "))\n");
    fprintf(fID,"(assert (>= X_"+string(i)+ " " + num2str(lb(i+1), precision)+ "))\n");
    fprintf(fID,"\n");
end
fprintf(fID,"\n");

% 3) Define outputs
nO = length(property.g); % number of output constraints
if nO > 1
    fprintf(fID,"(assert (or \n");
    for i=1:nO
        constraint = halfspaceConstraint2inequality(property.G(i,:), property.g(i));
        fprintf(fID,"        "+constraint+"\n"); % format used in other vnnlib examples
    end
    fprintf(fID,"))");
else
    constraint = halfspaceConstraint2inequality_1(property.G, property.g);
    fprintf(fID,"(assert "+constraint);
end

% close and save file
fclose(fID); 

end


%% Helper functions

function str = halfspaceConstraint2inequality(hRow, hVal)
    % Input a halfspace row (G row) and the corresponding g value
    % Outputs a string to write in the vnnlib file

    locs = find(hRow ~= 0); % Find indexes that are not zero
    if hVal == 0 % Compare two indexes
        if hRow(locs(1)) > 0 % 
            str = "(and (>= Y_"+string(locs(2)-1) + " " + "Y_"+string(locs(1)-1)+ "))";
        else
            str = "(and (>= Y_"+string(locs(1)-1) + " " + "Y_"+string(locs(2)-1) + "))";
        end
    else % compare index to value
        str = "(and (>= Y_"+string(locs(1)-1) + " " + num2str(hVal, '%.16f') + "))";
    end

end

function str = halfspaceConstraint2inequality_1(hRow, hVal)
    % Input a halfspace row (G row) and the corresponding g value
    % Outputs a string to write in the vnnlib file

    locs = find(hRow ~= 0); % Find indexes that are not zero
    if hVal == 0 % Compare two indexes
        if hRow(locs(1)) > 0 % 
            str = "(>= Y_"+string(locs(2)-1) + " " + "Y_"+string(locs(1)-1)+ "))";
        else
            str = "(>= Y_"+string(locs(1)-1) + " " + "Y_"+string(locs(2)-1) + "))";
        end
    else % compare index to value
        str = "(>= Y_"+string(locs(1)-1) + " " + num2str(hVal, '%.16f') + "))";
    end

end