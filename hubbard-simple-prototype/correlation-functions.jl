final_expected_real_value(op) = complex_to_mat(op |> normal_form |> hubbard_opstr_coefficients)[1, 1]

open(full_output_name, "a") do file
    #region ⟨n_i⟩

    n_i_var = (cdag(1, ↑) * c(1, ↑) + cdag(1, ↓) * c(1, ↓)) |> final_expected_real_value
    println(file, "Expected ⟨n_i⟩:  $(value(n_i_var))")
    println(file)

    #endregion

    #region ⟨S_{zi}⟩
    Sz_i_var = (cdag(1, ↑) * c(1, ↑) - cdag(1, ↓) * c(1, ↓)) |> final_expected_real_value
    println(file, "Expected ⟨Sz_i⟩:  $(value(Sz_i_var))")
    println(file)
    #endregion
end