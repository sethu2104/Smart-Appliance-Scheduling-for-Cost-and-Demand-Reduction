%% Input Data
%% LS1
% DA = [1.5 1.5 1.5 0.5 1 1 1 2 1 1.5];
% load = [12 12 4.5 1.5 5 5 6 12 2 3];
% time_slots= [8 8  3 3 5 5 6 6 2 2];
% cost = [4 5 6 7 6 8 2 5]; 
% E_max = 8; % Maximum energy constraint per time slot 
% alpha = 0.1;  
% beta = 0.5;  

%% LS2
DA=[1.5,1.5,1,1,1,1.5,1.5,1,1,1];
load=[12,12,3,3,4,6,6,4,4,3];
cost=[8,3,9,4,6,5,7,6];
time_slots = [8, 8, 3, 3, 4, 4, 4, 4, 4, 3];
E_max = 8; % Maximum energy constraint per time slot 
alpha = 0.5;  
beta = 0.5;  

%% LS3
% DA=[1.5,1.5,1,0.5,0.5,1,0.5,0.5,0.5,1.5];
% load=[12,12,3,1.5,2.5,3,2,2,1.5,7.5];
% time_slots=[8 8 3 3 5 3 4 4 3 5];
% cost=[5,3,7,9,8,4,4,6];
% E_max = 7; % Maximum energy constraint per time slot
% alpha = 0.1;  
% beta = 0.5;  

%% LS4
% DA=[1.5,1.5,0.5,1,1.5,1,1,0.5,1,0.5];
% load=[12,12,1,4,6,2,2,1.5,2,2];
% time_slots=[8 8 2 4 4 2 2 3 2 4];
% cost=[4,9,5,8,6,7,4,6];
% E_max = 6; % Maximum energy constraint per time slot 
% alpha = 0.1;  
% beta = 0.5;  


priority = [
    7  2  8  1  4  5  3  9;     %for A1
    6  4  9  2  8  1  7  5;     %for A2
    3  8  2  6 10  4  9  1;     %for A3
    9  1  7  3  5  6  2  8;     %for A4
    4 10  5  7  2  8  1  6;     %for A5
    2  7  6  9  3  5  8  4;     %for A6
    8  5  1  4  7  2  6 10;     %for A7
    5  3 10  8  6  7  4  2;     %for A8
   10  6  4  5  1  9  2  7;     %for A9
    1  9  3 10  8  6  5  2     %for A10
];

 

%%
num_appliances = length(DA);
num_time_slots = length(cost);

num_variables = num_appliances * num_time_slots;
intcon = 1:num_variables;

priority_vector = reshape(priority', 1, []);
cost_vector = repmat(cost, 1, num_appliances);
energy_vector = repmat(DA', num_time_slots, 1);
energy_vector = reshape(energy_vector, 1, []);     

% objective: minimizing (cost - alpha * priority - beta * energy_used)
f = cost_vector - alpha * priority_vector - beta * energy_vector;

A_eq = zeros(num_appliances, num_variables);
b_eq = load';

% "start" is used to contruct constraint coeffiecient matrices (A_leq and A_eq)
    st_row=1;
    st_col=1;
    start=[];
    for i=1:num_appliances
      I=DA(i)*eye(num_time_slots);
      start=[start,I];
      for j=st_col:st_col+(num_time_slots-1)
          A_eq(st_row,j)=DA(i);
      end
      st_col=st_col+num_time_slots;
      st_row=st_row+1;
    end

A_leq = start;
b_leq = E_max * ones(num_time_slots,1);

lb = zeros(num_variables,1);
ub = ones(num_variables,1);
options = optimoptions('intlinprog','Display','none');

[x, ~, exitflag] = intlinprog(f, intcon, A_leq, b_leq, A_eq, b_eq, lb, ub, options);

if exitflag == 1
    x_solution = reshape(x, num_time_slots, num_appliances)';

     printer(DA, cost, E_max, x);

else
    disp('No solution found.');
end


while(1)
    exit_loop = input('Enter 0 to exit and press any another key to continue reschedulling: ');
    if exit_loop==0
    break;
    end

    turn_on=input('Enter value 1/0 if you want to turn on/off on any appliance  : ');

current_slot = input('Enter a value for current_slot: ');
appliance_id=input('Enter a value for appliance_id: ');

 reschedule(turn_on, current_slot, appliance_id, x_solution, priority, DA, time_slots, cost, E_max, alpha, beta);

end