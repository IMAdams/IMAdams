using GLMakie

# generate a random 3d array 
data = rand(10,20,10)

data[1,1,1] = 2
# create a new figure
fig = GLMakie.Figure()
# add an axis to the figure
ax = GLMakie.Axis(fig[1,1], xlabel = "x", ylabel = "y", title = "z-stack", aspect = GLMakie.DataAspect(), yreversed = true)
# create a slider at position [2,1] in the figure
s1 = GLMakie.Slider(fig[2,1], range = 1:size(data,3), startvalue = 1)
# create a derived observable using lift. permute for correct display
im2display = GLMakie.lift(idx -> permutedims(data[:,:,idx],[2,1]), s1.value) # idx conventional for index

GLMakie.heatmap!(ax, im2display)

fig