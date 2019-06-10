clear, close, clc

num_iteration = 50000;
num_variable = 20;
population_size = 30;
offspring_size = population_size;
bit_representation = 18;
mutation_probability = 5/(num_variable*bit_representation);

population_phenotype = randi([-5, 5], population_size, num_variable);
population_genotype  = GA_PhenotypeToGenotype(population_phenotype);
offspring_genotype   = population_genotype;

population_fitness_values = zeros([population_size, 1]);
offspring_fitness_values = zeros([population_size, 1]);

mating_pool_indices = zeros([population_size, 1]);

fitness_average= zeros(num_iteration, 1);
fitness_best = zeros(num_iteration, 1);

% Calculate initial population fitness values
for j=1:population_size
    population_fitness_values(j, 1) = Ackley(population_phenotype(j, :));
end

tic
for i=1:num_iteration    
    
    % Create mating pool
    for j=1:population_size
        % implement roulette wheel
        % Important trick: we want lower fitness values to get higher
        % probability, so modify fitness values according to that
        normalized_fitness_values = population_fitness_values/sum(population_fitness_values);
        normalized_fitness_values_r = -normalized_fitness_values+max(normalized_fitness_values);
        normalized_fitness_values_r_n = normalized_fitness_values_r/sum(normalized_fitness_values_r);
        
        selected_index = find(rand<cumsum(normalized_fitness_values_r_n), 1, 'first');
        
        %selected_value = population_fitness_values(find(rand<cumsum(normalized_fitness_values), 1, 'first')); % this line samples values according to their weights
        %selected_index = find(population_fitness_values==selected_value, 1);
        
        mating_pool_indices(j,1) = selected_index;        
    end
    
    % Apply Recombination 
    % use uniform crossover
    j=1;
    while j<population_size        
        for k=1:size(offspring_genotype, 2)
            if rand < 0.5
                offspring_genotype(j, k)   = population_genotype(mating_pool_indices(j,1),k);
                offspring_genotype(j+1, k) = population_genotype(mating_pool_indices(j+1,1), k);           
            else
                offspring_genotype(j, k)   = population_genotype(mating_pool_indices(j+1), k);
                offspring_genotype(j+1, k) = population_genotype(mating_pool_indices(j), k);
            end
        end        
        j=j+2;
    end
    
    % Apply Mutation
    % Use bit flipping with mutation_probability
    for j=1:offspring_size
        for k=1:size(offspring_genotype, 2)
            if rand<mutation_probability
                if offspring_genotype(j,k) == 1
                    offspring_genotype(j,k) = 0;
                else
                    offspring_genotype(j,k) = 1;
                end
            end
        end
    end
    
    offspring_phenotype = GA_GenotypeToPhenotype(offspring_genotype);
    
    % Calculate offspring fitness values
    for j=1:offspring_size
        offspring_fitness_values(j, 1) = Ackley(offspring_phenotype(j, :));
    end
    
    % Apply Elitism
    % If there is an individual in the parents that is fitter than the all
    % indiviudals in the offsprings, keep it in the next generation
    population_best_individual = mink(population_fitness_values, 1);
    population_best_individual_index = find(population_fitness_values==population_best_individual, 1);
    
    keepBest = 1;
    for j=1:offspring_size
        if offspring_fitness_values(j, 1) < population_best_individual
            keepBest = 0;
            break
        end
    end
    
    if keepBest == 1
        changeIndex = randi([1, num_variable], 1);
        offspring_genotype(changeIndex, :) = population_genotype(population_best_individual_index, :);
    end    
    
    population_genotype = offspring_genotype;
    population_phenotype = GA_GenotypeToPhenotype(population_genotype);    
    
    % Record best and average fitness values
    for j=1:population_size
        population_fitness_values(j, 1) = Ackley(population_phenotype(j, :));
    end
    fitness_best(i) = mink(population_fitness_values, 1);
    
    total_sum = 0;
    for j=1:population_size
        total_sum = total_sum + population_fitness_values(j);
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


