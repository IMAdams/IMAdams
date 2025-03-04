# Plotting confluence of cells treated with varying concentrations of G418

using CSV, DataFrames, CairoMakie

df = CSV.read("O:\\Cell Path\\Lidke Lab\\IMAdams\\Incucyte data\\Cos-7 parent line kill curve\\export kill curve.txt", DataFrame, delim='\t')
group1 = Float64[]  
group2 = Float64[]
group3 = Float64[]
group4 = Float64[]
group5 = Float64[]
group6 = Float64[]

groups = [group1, group2, group3, group4, group5, group6]

# For each group, get values from 4 consecutive columns
for i in 1:6
    start_col = (i-1)*4 + 3  # Start at Column3, Column7, Column11, etc.
    end_col = start_col + 3   # Get 4 columns total
    
    for col in start_col:end_col
        push!(groups[i], parse(Float64, df[!,col][2]))  # Get the single value from each column
    end
end


groups[6]
fig = Figure()
ax =Axis(fig[1,1], xlabel = "G418 Concentration (mg/mL)", ylabel = "Confluency (%)", xticks = (1:6, ["0.0", "0.5", "0.75", "1.0", "1.5", "2.0"]), title = "Cos-7 G418 kill curve")
boxplot!(ax, repeat(1:6, inner=4), vcat(groups...))
display(fig)
save("O:\\Cell Path\\Lidke Lab\\IMAdams\\Incucyte data\\Cos-7 parent line kill curve\\boxplot.png", fig)

