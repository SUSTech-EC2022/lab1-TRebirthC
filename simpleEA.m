function [bestSoFarFit ,bestSoFarSolution ...
    ]=simpleEA( ...  % name of your simple EA function
    fitFunc, ... % name of objective/fitness function
    T, ... % total number of evaluations
    input) % replace it by your input arguments

% Check the inputs
if isempty(fitFunc)
  warning(['Objective function not specified, ''' objFunc ''' used']);
  fitFunc = 'objFunc';
end
if ~ischar(fitFunc)
  error('Argument FITFUNC must be a string');
end
if isempty(T)
  warning(['Budget not specified. 1000000 used']);
  T = '1000000';
end
eval(sprintf('objective=@%s;',fitFunc));
% Initialise variables
nbGen = 0; % generation counter
nbEval = 0; % evaluation counter
bestSoFarFit = 0; % best-so-far fitness value
bestSoFarSolution = NaN; % best-so-far solution
%recorders
fitness_gen=[]; % record the best fitness so far
solution_gen=[];% record the best phenotype of each generation
fitness_pop=[];% record the best fitness in current population 
%% Below starting your code

% Initialise a population
pop_size = 4;
lenGene = 5;
population = randi([0,31],10,1);
genotypes = dec2bin(population);


% Evaluate the initial population
fitness = objective(population);
for i = 1:pop_size
    if fitness(i) > bestSoFarFit
        bestSoFarFit = fitness(i);
        bestSoFarSolution = population(i,:);
    end
end
nbEval = nbEval + pop_size;
nbGen =  nbGen + 1;
sorted_fitness = sort(fitness,'descend');
fitness_pop = sorted_fitness(1);
fitness_gen = bestSoFarFit;
solution_gen = bestSoFarSolution;

% Start the loop
while (nbEval<T) 
% Reproduction (selection, crossver)
offspringGenes = [];
crossoverPoint = randi(lenGene-1);
offspringGenes = [offspringGenes; [genotypes(1,1:crossoverPoint), genotypes(2,crossoverPoint+1:end)]];
offspringGenes = [offspringGenes; [genotypes(2,1:crossoverPoint), genotypes(1,crossoverPoint+1:end)]];
offspringGenes = [offspringGenes; [genotypes(3,1:crossoverPoint), genotypes(4,crossoverPoint+1:end)]];
offspringGenes = [offspringGenes; [genotypes(4,1:crossoverPoint), genotypes(3,crossoverPoint+1:end)]];

% Mutation
MP = 0.1;
for i = 1:pop_size
    for j = 1:lenGene
        if rand() < MP
            % offspringGenes(i) = dec2bin(abs(2^j-offspringGenes(i)));
            if offspringGenes(i,j) == '1'
                offspringGenes(i,j) = '0';
            else
                offspringGenes(i,j) = '1';
            end
        end
    end
end
genotypes = offspringGenes;
population = bin2dec(genotypes);
fitness = objective(population);
for i = 1:pop_size
    if fitness(i) > bestSoFarFit
        bestSoFarFit = fitness(i);
        bestSoFarSolution = population(i,:);
    end
end
nbEval = nbEval + pop_size;
nbGen = nbGen + 1;
sorted_fitness = sort(fitness,1,'descend');
fitness_pop = [fitness_pop,sorted_fitness(1)];
fitness_gen = horzcat(fitness_gen, bestSoFarFit);
solution_gen = horzcat(solution_gen, bestSoFarSolution);

end

bestSoFarFit;
bestSoFarSolution;

figure,plot(1:nbGen,fitness_gen,'b') 
title('Fitness\_Gen')

figure,plot(1:nbGen,solution_gen,'b') 
title('Solution\_Gen')

figure,plot(1:nbGen,fitness_pop,'b') 
title('Fitness\_Pop')
