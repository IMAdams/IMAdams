# Simulate filtering noisy data using a rolling-average style filter. 
## A slider on the plot adjusts the interval used for the rolling average. This visualy depicts the impact of choosing filter parameters. 

using Random
using GLMakie
using Statistics

# Set the seed for reproducibility
Random.seed!(42)

# Define model function 
function model(x)
    return sin(x)
end

# Generate the data
n = 1000  # number of data points
x = range(0, stop=50, length=n)  # x values

# Simulate noisy data by adding Gaussian noise
sd = 0.2  # standard deviation of the noise
y = model.(x) .+ sd * randn(n)

# rolling averages function

function rolling_average(y, window_size)
    n = 1000
    y_smooth = (zeros(n))
    window_size = window_size
    
        for i in 1:1000
            start_idx = max(1, i - window_size)
            end_idx = min(n, i + window_size)
            y_smooth[i] = mean(y[start_idx:end_idx])
        end
    
        return y_smooth
    end


# Initialize the window size
initial_window_size = 5

# Create the rolling average observable with the initial window size
y_smooth = rolling_average(y, initial_window_size)

y_smooth_obs = Observable(y_smooth)

# Plot the results with GLMakie using Observables
fig = GLMakie.Figure()

# Add a plot for the noisy data
ax1 = GLMakie.Axis(fig[1,1], title="Noisy Data", xlabel="x", ylabel="y")
ax2 = GLMakie.Axis(fig[2,1], title="sin(x)", xlabel="x", ylabel="y")
ax3 = GLMakie.Axis(fig[3,1], title="Noisy Data with Rolling Average Filter", xlabel="x", ylabel="y")


# Add a plot for the true model
GLMakie.lines!(ax2, x, model.(x), label="True Model", linewidth=2, color=:grey)

# plot the noisy model
GLMakie.lines!(ax1, x, y, 
    label="Noisy Data", markersize=1, color=:blue
    )

# Add a plot for the smoothed data
GLMakie.lines!(ax3, x, y_smooth_obs, 
    label="Smoothed Data", linewidth=2, color=:red
    )

# Create a slider to adjust the window size
s1 = GLMakie.Slider(fig[4,1], (label = "window size of rolling average"), range = 0:50, startvalue = 5) # label = range = 0:50, labelslider = "Window Size", labelslidergrid = "test")

# Update the rolling average when the slider value changes
GLMakie.on(s1.value) do new_window_size
    y_smooth_obs[] = rolling_average(y, new_window_size)
    notify(y_smooth_obs)
end


# Show the plot
display(fig)

