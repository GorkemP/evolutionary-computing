function y = GA_PhenotypeToGenotype(x)
    
    % folowing terms are for converting float numbers to positive integer
    % values, so that we can easily change it to binary
    precision = 10000;
    add_term = 100000;
    bit_representation = 18;
    
    % Map float numbers to positive integers
    x = int32(precision*x)+add_term;
    
    y_row = size(x,1);
    y_column = bit_representation*size(x,2);
    y=zeros(y_row, y_column);
    
    % Map decimal numbers to binary representation
    for i=1:y_row
        for j=1:size(x, 2)
            y(i, ((j-1)*bit_representation+1):((j*bit_representation))) = de2bi(x(i, j), bit_representation);
        end
    end
end