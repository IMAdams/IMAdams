# plotting MESF surve to interpolate for receptor numbers

using Interpolations

"""
    interpolate_standard_curve(x_standards, y_standards, x_query)

Interpolate values from a standard curve.

Parameters:
- `x_standards`: Array of x values from standard data (concentrations, etc.)
- `y_standards`: Array of y values from standard data (measurements, signal, etc.)
- `x_query`: Single value or array of x values to interpolate

Returns:
- Interpolated y value(s) corresponding to x_query

Example:
```julia
# Standard curve data
x_std = [0.0, 0.5, 1.0, 2.0, 5.0, 10.0]
y_std = [0.02, 0.12, 0.25, 0.49, 1.2, 2.4]

# Interpolate a single value
result = interpolate_standard_curve(x_std, y_std, 1.5)
# or multiple values
results = interpolate_standard_curve(x_std, y_std, [0.75, 3.0, 7.5])
```
"""
function interp1(channel, MESF, query)
    # Check inputs
    if length(channel) != length(MESF)
        error("channel and MESF must have the same length")
    end
    
    if length(channel) < 2
        error("Need at least two points to interpolate")
    end
    
    # Create a sorted version of the data for interpolation
    sorted_indices = sortperm(channel)
    x_sorted = channel[sorted_indices]
    y_sorted = MESF[sorted_indices]
    
    # Create an interpolation object
    # Using cubic spline interpolation with linear extrapolation for out-of-range queries
    itp = linear_interpolation(channel, MESF; extrapolation_bc=Throw()) 
    
    # Return interpolated value(s)
    return itp(query)
end


# Define your standard curve data
MESF = [0, 7013, 31235, 90144, 398892]
channel = [134, 3149, 20681, 68436, 318881]  # Measured signals

# Interpolate a single value
result = interp1(channel, MESF, 12346)

result = interp1(MESF, channel, 21528)
println("At concentration 1.5, predicted signal is $(result)")

# Interpolate multiple values
results = interpolate_standard_curve(conc, signal, [0.75, 3.0, 7.5])
println("Multiple predictions: $(results)")

using CairoMakie
fig = Figure(size= (400,400))
ax = Axis(fig, aspect = 1, xscale = log10, yscale=log10)
scatter!(ax, channel, MESF)
display(fig)