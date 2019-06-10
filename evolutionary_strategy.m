clear, close, clc

num_iteration = 50000;
num_variable = 20;
population_size = 30;
offspring_size = 200;
sigma = 1;
thao = sqrt(1/num_variable);
mutation_probability = 0.5;

% initial population is chosen by uniform distribution
population_variables = randi([-num_variable, num_variable], population_size, num_variable);    
population_sigmas = ones(population_size, 1)*sigma;

% last column indicates sigma for that individual
population = [population_variables, population_sigmas];                     

offsprings = zeros([offspring_size, num_variable+1]);

offspring_fitness_values = zeros([offspring_size, 1]);

fitness_average= zeros(num_iteration, 1);
fitness_best = zeros(num_iteration, 1);

tic
for i=1:num_iteration

    % Select parents and create offsprings 
    % local intermediate recombination applied
    for j=1:offspring_size
        randNumbers = randperm(population_size);
        temp_parents = randNumbers(1:2);
        offsprings(j, :) = (population(temp_parents(1), :) + population(temp_parents(2), :))/2;        
    end
    
    % Mutate offsprings with mutation probability    
    for j=1:offspring_size
        if rand(1,1)< mutation_probability
            % first change sigma
            offsprings(j, end) = offsprings(j, end)*exp(thao*normrnd(0,1));
            % then change variables
            offsprings(j,1:num_variable) = offsprings(j,1:num_variable) + offsprings(j, end)*normrnd(0,1, [1, num_variable]);
        end
    end
    
    % Calculate fitness values
    for j=1:offspring_size
        offspring_fitness_values(j,1) = Ackley(offsprings(j,1:num_variable));
    end
    
    % Survival Selection
    [B, I] = mink(offspring_fitness_values, population_size);
    population = offsprings(I, :);
    
    % Record best and average fitness values
    fitness_best(i) = Ackley(population(1,1:num_variable));
    
    total_sum = 0;
    for j=1:population_size
        total_sum = total_sum + Ackley(population(j, 1:num_variable));
    end
    fitness_average(i) = total_sum/population_size;
end
toc

figure(1)
plot(fitness_best)
title('Best fitness value graph')
xlabel('Iteration number')
ylabel('Best fitness value in the population')

figure(2)
plot(fitness_average)
title('Average fitness value graph')
xlabel('Iteration number')
ylabel('Average fitness value of the population')