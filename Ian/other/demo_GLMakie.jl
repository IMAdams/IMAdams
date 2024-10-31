using Pkg
Pkg.add("GLMakie")

using GLMakie

a = Observable(7)

function mysqr(x)
    return x^2
end

on(a) do x  # do defines an anonymous funciton, passes the output to "on". 
    print("value of a changed to: ", a[], "\n")
end

# output = map(function_name, function_inputs)
b = map(mysqr, a) # mysqr with no () passes the function, as an arg, not a function

a[] = 7
println("b:", b[])