function rsqrt_tb
      
%------------------------------------------------------------
% Note: it appears that the cosimWizard needs to be re-run if
% this is moved to a different machine (VHDL needs to be
% recompile in ModelSim).
%------------------------------------------------------------

% HdlCosimulation System Object creation (this Matlab function was created
% by the cosimWizard).
rsqrt_hdl = hdlcosim_rsqrt;            

% Simulate for Nclock rising edges (this will be the length of the
% simulation)
Nclock_edges = 10;

for clki=1:Nclock_edges
    %-----------------------------------------------------------------
    % Create our input vector at each clock edge, which must be a 
    % fixed-point data type.  The word width of the fixed point data type
    % must match the width of the std_logic_vector input.
    %-----------------------------------------------------------------
    fixed_word_width     = 32;  % width of input to component
    fixed_point_value    = randi([1 2^fixed_word_width-1],1,1);  % choose a random integer between [0 2^W-1] - Note: can't have a zero input....
    fixed_point_signed   = 0;  % unsiged = 0, signed = 1;
    fixed_point_fraction = 0;  % fraction width (location of binary point within word)
    input_vector1 = fi(fixed_point_value, fixed_point_signed, fixed_word_width, fixed_point_fraction); % make the input a fixed point data type
    input_history{clki} = input_vector1;  % capture the inputs 
    
    %-----------------------------------------------------------------
    % Push the input(s) into the component using the step function on the
    % system object lzc_hdl
    % If there are multiple I/O, use
    % [out1, out2, out3] = step(lzc_hdl, in1, in2, in3);
    % and understand all I/O data types are fixed-point objects
    % where the inputs can be created by the fi() function.
    %-----------------------------------------------------------------
    output_vector1 = step(rsqrt_hdl,input_vector1);
    
    %-----------------------------------------------------------------
    % Save the outputs (which are fixed-point objects)
    %-----------------------------------------------------------------
    output_history{clki} = output_vector1;  % capture the output
    
end
%-----------------------------------------------------------------
% Display the captured I/O
%-----------------------------------------------------------------
display_this = 0;
if display_this == 1
    for clki=1:Nclock_edges
        in1 = input_history{clki};
        in1.bin
        out1 = output_history{clki}
        out1.dec
        out1.WordLength
    end
end
%-----------------------------------------------------------------
% Perform the desired comparison (with the latency between input
% and output appropriately corrected).
%-----------------------------------------------------------------
latency     = 1;  % latency in clock cycles through the component
error_index = 1;
error_case  = [];
for clki=1:Nclock_edges-latency
    in1  = input_history{clki};  
    out1 = output_history{clki+latency};  % get the output associated with current output
    %------------------------------------------------------
    % Perfom the comparison with the "true" output 
    %------------------------------------------------------
    in1
    double(in1)
    out1
    double(out1)
    double(in1)/2
    dif1 = floor(double(in1)/2)   - double(out1)
    pause
    
    
%     true_lzc = fixed_word_width - floor(log2(double(in1))) -  1;  % calculate "true" lzc
%     if isinf(true_lzc)
%         true_lzc = fixed_word_width;  % fix "true" lzc if we took log2(zero)
%     end
%     if abs(true_lzc-double(out1)) > 0
%         error_case{error_index}.clock_index = clki;
%         error_case{error_index}.input       = in1;
%         error_case{error_index}.output      = out1;
%         error_case{error_index}.true_lzc    = true_lzc;
%         error_index = error_index + 1;
%     end
end
% error_count = error_index - 1;
% if error_count == 0
%     disp(['No Errors detected'])
% else
%     disp(['ERROR: There were ' num2str(error_count) ' errors.'])
%     disp(['ERROR: The errors occured at the following index locations:'])
%     for k=1:error_count
%         k
%         size(error_case)
%         error_case{k}
%         error_case{k}.clock_index
%         error_case{k}.input.bin    
%         error_case{k}.output   
%         error_case{k}.true_lzc 
%     end
% end





end
