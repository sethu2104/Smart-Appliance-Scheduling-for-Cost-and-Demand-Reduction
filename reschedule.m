function reschedule(action, current_slot, appliance_id, x_solution, priority, DA, time_slots, cost, E_max, alpha, beta)

    num_appliances = size(x_solution, 1);
    num_time_slots = size(x_solution, 2);

    if current_slot > num_time_slots || current_slot < 1
        error('Invalid current slot');
    end

    remaining_slots = time_slots' - sum(x_solution(:,1:current_slot-1), 2);

    slots_to_schedule = current_slot:num_time_slots;
    num_remaining = length(slots_to_schedule);

    num_variables = num_appliances * num_remaining;
    intcon = 1:num_variables;

    priority_vector = reshape(priority(:, slots_to_schedule)', 1, []);
    cost_vector = repmat(cost(slots_to_schedule), 1, num_appliances);
    energy_vector = repmat(DA', num_remaining, 1);
    energy_vector = reshape(energy_vector, 1, []);

    f = cost_vector - alpha * priority_vector - beta * energy_vector;

    Aeq = zeros(num_appliances, num_variables);
    for i = 1:num_appliances
        Aeq(i, (i-1)*num_remaining + (1:num_remaining)) = 1;
    end
    beq = remaining_slots;

    A = zeros(num_remaining, num_variables);
    for t = 1:num_remaining
        for a = 1:num_appliances
            A(t, (a-1)*num_remaining + t) = DA(a);
        end
    end
    b = E_max * ones(num_remaining, 1);

    lb = zeros(num_variables, 1);
    ub = ones(num_variables, 1);

    idx = (appliance_id-1)*num_remaining + 1;
    if action == 1
        lb(idx) = 1;  % Force ON
    elseif action == 0
        ub(idx) = 0;  % Force OFF
    else
        error('Invalid action. Must be "on" or "off".');
    end

    options = optimoptions('intlinprog', 'Display', 'none');
    [x, ~, exitflag] = intlinprog(f, intcon, A, b, Aeq, beq, lb, ub, options);

    new_schedule = x_solution;
    if exitflag == 1
        new_schedule(:, slots_to_schedule) = reshape(x, num_remaining, num_appliances)';

        y = new_schedule';
        y = y(:);
        
        printer(DA, cost, E_max, y);
    else
        error('Rescheduling failed.');
    end

end
