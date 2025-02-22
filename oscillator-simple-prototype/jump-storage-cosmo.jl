using COSMO, JuMP
using JLD2

import JuMP.set_start_value, JuMP.set_dual_start_value

function set_optimal_start_values(model::Model)
    # Store a mapping of the variable primal solution
    variable_primal = Dict(x => value(x) for x in all_variables(model))
    # In the following, we loop through every constraint and store a mapping
    # from the constraint index to a tuple containing the primal and dual
    # solutions.
    constraint_solution = Dict()
    for (F, S) in list_of_constraint_types(model)
        # We add a try-catch here because some constraint types might not
        # support getting the primal or dual solution.
        try
            for ci in all_constraints(model, F, S)
                constraint_solution[ci] = (value(ci), dual(ci))
            end
        catch
            @info("Something went wrong getting $F-in-$S. Skipping")
        end
    end
    # Now we can loop through our cached solutions and set the starting values.
    for (x, primal_start) in variable_primal
        set_start_value(x, primal_start)
    end
    for (ci, (primal_start, dual_start)) in constraint_solution
        set_start_value(ci, primal_start)
        set_dual_start_value(ci, dual_start)
    end
    return
end

##

println()
println("First run")
println()
println("------------------------------------------")
model = Model(COSMO.Optimizer)
@variable(model, x[1:10] >= 0)
@constraint(model, sum(x) <= 1)
@objective(model, Max, sum(i * x[i] for i in 1:10))
optimize!(model)

##

set_optimal_start_values(model)

##

println()
println("Second run")
println()
println("------------------------------------------")
optimize!(model)
