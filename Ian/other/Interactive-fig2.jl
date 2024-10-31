# an old version of Hw2

# Model noisy data and apply an interactive filter using GLMakie

# import Pkg; Pkg.add("AbstractPlotting")
# import Pkg; Pkg.add("DataFrames")

using Random
using GLMakie
using AbstractPlotting
using DataFrames

# Set the seed for PRNG
Random.seed!(42)

# Define the underlying model function 
function model(x)
    return sin(x)
end

# Generate the data
n = 1000  # number of data points
x = range(0, stop=100, length=n)  # x values

# Simulate noisy data by adding Gaussian noise
sd = 0.2 
y_model = model.(x) .+ sd * randn(n)

# Convert the vector to a DataFrame
yDf = DataFrame(:value => y_model)


# function to calculate rolling average
function rolling_average!(y::DataFrame)

    for i in [1:1000]
        start_idx = max(1, [i] - 2)
        end_idx = min(n, [i] + 2)
        y_smooth[i] = sum(y[start_idx:end_idx, 2])
    end

    return y_smooth
end

# call the function to populate y_smooth
y_smooth = rolling_average(yDf)

# Apply filter the data 
function filtapply(y_filt, y, y_smooth)
    for i in n 
        y_filt = y .- y_smooth
    end

    return y_filt
end




# y_filt = y - y_smooth

fig = Figure()

ax = Axis(fig[1,1];
    xlabel = "wut",
    ylabel = "Radians"
    )

    lines!(ax, x, y_smooth)
fig



# # Apply the filter
# y_smooth = rolling_average(y, filter_window)


# fig = Figure()

# ax = Axis(f[1,1];
#     xlabel = "wut",
#     ylabel = "Radians"
#     )

#     lines!(ax, x,y)
# fig


#     filter_window = Observable(0.1:3)
# s1 = Slider(fig[2,1], range = 0.1:3, startvalue = 2)

# y_obs = Observable(y)
# # Rolling average filter using an observables type to define the window size. 
# #This will later be adjusted with a slider to visualize the effect of changing the rolling average window. 
# for i in [1:25]


# filt_array = zeros(5,5)
# filter_window = [1:1:50]