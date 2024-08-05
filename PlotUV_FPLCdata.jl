using Pkg
Pkg.add("CSV")
using CSV
Pkg.add("DataFrames")
using DataFrames
Pkg.add("CairoMakie")
using CairoMakie

df = CSV.read("C:\\Users\\imadams\\Desktop\\20240801_proteinARun 04.csv", DataFrame; header=2, skipto = 10)

fig = Figure()
ax = Axis(fig[1,1], xlabel= "Column Volume", ylabel = "mAU(Abs)", limits =(0,12,-500,1000), title = "20240801 HIS_protA Run")
lines!(ax, df."UV1 (215 nm)_column_volume", df."UV1 (215 nm)_mAU"; label = "215 nm")
lines!(ax, df."UV1 (215 nm)_column_volume", df."UV2 (255 nm)_mAU"; label = "255 nm")
lines!(ax, df."UV1 (215 nm)_column_volume", df."UV3 (280 nm)_mAU"; label = "280 nm")
lines!(ax, df."UV1 (215 nm)_column_volume", df."UV4 (495 nm)_mAU"; label = "495 nm")
axislegend(ax; position = :rb)
display(fig)
save("/Users/imadams/Desktop/0801.png", fig)