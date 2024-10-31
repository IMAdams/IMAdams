# Day 2 of julia course 

using CairoMakie

a = 1

x = zeros(10) #create a vector of zeros, length 10, 

#simple loop
xrange = [1:.1:10...] #splat
x = zeros(length(xrange))
cnt = 1
for i in xrange
    x[cnt] = i
    cnt += 1
end

for i in 1:10 
    x[i] = i
end

y = sin.(x)

plot(x,y)

f = Figure()
ax = Axis(f[1, 1],
    title = "A Makie Axis",
    xlabel = "The x label",
    ylabel = "The y label"
)

lines!(ax, x, y, color = :blue, label = "sin")
lines!(ax, x, y2, color = :red, label = "cos")
#axislegend(ax, position = :lt)
display(f)
y


mydir = joinpath("Users", "Ian")
save("mydir/testplot.png", f)

f1 = Figure()
ax1 = Axis(f[1, 1],
    title = "A Makie Axis",
    xlabel = "The x label",
    ylabel = "The y label"
)
ax2 = Axis(f[1, 2],
    title = "A Makie Axis",
    xlabel = "The x label",
    ylabel = "The y label"
)

lines!(ax1, x, y, color = :blue)
y2 = cos.(x)
lines!(ax2, x, y2, color = :red)

display(f1)

# comprehension
x = [i for i in 1:.1:10]
y = sin.(x)