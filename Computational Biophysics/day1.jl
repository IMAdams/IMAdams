# a few notes and following along

tastycakes = randn(128,128)
using CairoMakie 

# 1-based vs zero-based, julia is 1-based

t = 0:0.1:10
y = sin.(t)

fig = Figure() # the capital Figure indicates making a type
ax = Axis(fig[1,1], xlabel="time", ylabel = "amplitude")
lines!(ax,t,y,)
display(fig)
