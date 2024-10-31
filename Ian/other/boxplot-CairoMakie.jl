# creating a simple boxplot

using CairoMakie

f = Figure()
display(f)
ax = Axis(f[1,1];
    xlabel = "categories",
    ylabel = "values",
    xticks = (1:3, ["one", "two", "three"])
)
categories = rand(1:3, 1000)
values = randn(1000)
dodge = rand(1:2, 1000)

boxplot!(ax, categories, values, dodge = dodge, color = dodge) 

# to add legend 

# build the marker elements
elems = [[MarkerElement(color = :Purple, marker=:circle, markersize = 15,
      strokecolor = :black)],[MarkerElement(color = :Yellow, marker=:circle, markersize = 15,
      strokecolor = :black)]]

axislegend(ax, elems, ["Purple", "Yellow"]; position=:rt)
f
