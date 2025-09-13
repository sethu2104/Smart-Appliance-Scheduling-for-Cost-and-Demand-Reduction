function printer(DA, cost, E_max, x)

% Inputs:
%   DA          : appliance power ratings
%   cost        : cost per slot
%   E_max       : scalar, maximum energy allowed per slot
%   x           : decision variable output of intlinprog (coloumn matrix)

num_appliances = length(DA);
num_time_slots = length(cost);
x_solution = reshape(x, num_time_slots, num_appliances)';
cost_vector = repmat(cost, 1, num_appliances);


energy_used_per_slot = zeros(num_time_slots,1);
for t = 1:num_time_slots
    for a = 1:num_appliances
        energy_used_per_slot(t) = energy_used_per_slot(t) + DA(a) * x_solution(a,t);
    end
end

cost_per_slot = zeros(num_time_slots,1);
for t = 1:num_time_slots
    cost_per_slot(t) = energy_used_per_slot(t) * cost(t);
end

mismatch_vector = E_max - energy_used_per_slot;

% Printing Scheduling Matrix
fprintf('\nOptimized Appliance Scheduling (1=ON, 0=OFF):\n\n');
fprintf('%12s', '');
for t = 1:num_time_slots
    fprintf('   T%-2d', t);
end
fprintf('\n');

for a = 1:num_appliances
    fprintf('Appliance %-2d', a);
    for t = 1:num_time_slots
        fprintf('%5d ', int32(x_solution(a,t)));
    end
    fprintf('\n');
end


fprintf('%12s', 'Energy:');
for t = 1:num_time_slots
    fprintf(' %5.1f', energy_used_per_slot(t));
end
fprintf('\n');

fprintf('%12s', 'Mismatch:');
for t = 1:num_time_slots
    fprintf(' %5.1f', mismatch_vector(t));
end
fprintf('\n\n');


fprintf('%1s', 'Consumed Cost:');
for t = 1:num_time_slots
    fprintf(' %4.1f ', cost_per_slot(t));
end
fprintf('\n  per slot\n\n');

fprintf('Utility Cost:  ');
fprintf('%4.1f  ', cost);
fprintf('\n  per slot\n\n');

fprintf('   E_max: ');
disp(E_max);

actual_cost = cost_vector * x;
fprintf('Total Power Consumption Cost = %.2f\n', actual_cost);


energy_contribution = zeros(num_appliances, num_time_slots);
for a = 1:num_appliances
    for t = 1:num_time_slots
        energy_contribution(a,t) = DA(a) * x_solution(a,t);
    end
end

figure;
b = bar(1:num_time_slots, energy_contribution', 'stacked');
hold on;


colors = [...
    166 206 227;
    31 120 180;
    178 223 138;
    51 160 44;
    251 154 153;
    227 26 28;
    253 191 111;
    255 127 0;
    202 178 214;
    106 61 154] / 255;

for k = 1:num_appliances
    b(k).FaceColor = colors(k, :);
end

plot([0, num_time_slots+1], [E_max, E_max], 'r--', 'LineWidth', 2);
text(0.2, E_max*1.05, sprintf('E_{max} = %.1f kW', E_max), 'Color', 'r', 'FontWeight', 'bold');

title('Power Consumption per Time Slot (Appliance-wise)');
xlabel('Time Slot');
ylabel('Power (kW)');
legend(arrayfun(@(a) sprintf('Appliance %d', a), 1:num_appliances, 'UniformOutput', false), 'Location', 'eastoutside');
ylim([0, E_max*1.5]);
xlim([0, num_time_slots+1]);
xticks(1:num_time_slots);
grid on;

end
