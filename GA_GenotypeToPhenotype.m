function y = GA_GenotypeToPhenotype(x)
    
    % If we choose values between -10 and 10, max value becomes 10
    % 10*10^4 = 100.000, since we are scaling them to positive side,
    % 100.000+100.000 = 200.000 is the maximum number that we can have
    % we can represent it with 18 bits
    
    precision = 10000;
    add_term = 100000;          % in order to convert negative numbers to positive numbers
    bit_representation = 18;    % 2^18 = 262,144
    
    y_row = size(x, 1);  
    y_column = size(x,2)/bit_representation;
    y = zeros(y_row, y_column);
    
    for i=1:y_row
        for j=1:y_column
            y(i,j) = (bi2de(x(i,((j-1)*bit_representation+1):((j*bit_representation))))-add_term)/precision;
        end    
    end
end