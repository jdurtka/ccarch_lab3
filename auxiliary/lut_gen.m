% James Durtka
% EELE 465 - Computational Computer Architecture
% Lab #3 - Inverse squareroot

%Generate the LUT for the x_beta^(-3/2) calculation

%Recall: x_beta is always between 1 and 2. Thus, we can use the fractional
%part to index, ignoring the integer part. This is further truncated down
%to 8 bits, in order to keep the LUT relatively small. In the output, we
%will store 32 bits, although 4 will be thrown away.


%Possible range of inputs (as an unsigned 8-bit word)
inputs = [0:255];

%Reconstruct our (approximate) input x_beta values
x_betas = ones(1,length(inputs)) + (1/256)*inputs;

%Perform the calculation
outputs = x_betas.^(-3/2);

%Convert all of these to fixed point and output the binary part
for i = 1:256
    %Treat as an unsigned 8-bit word
    inp_val = fi(inputs(i), 0, 8, 0);
    
    %Treat as unsigned 32-bit word, and since we want to truncate the
    %fraction rather than the integer part, we increase the apparent size
    %of the fraction to 18 bits
    out_val = fi(outputs(i), 0, 32, 18);
    
    disp(sprintf('-- %f => %f', x_betas(i), out_val))
    input_spec = ['"' inp_val.bin '"'];
    output_spec = ['"' out_val.bin '"'];
    disp(sprintf('when %s => x_beta_lut <= %s;', input_spec, output_spec))
end