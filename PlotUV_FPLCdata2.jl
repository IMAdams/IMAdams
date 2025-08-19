using Pkg
Pkg.add("CSV")
using CSV
# Pkg.add("DataFrames")
using DataFrames
# Pkg.add("CairoMakie")
using CairoMakie

df = CSV.read("/Users/ianadams/Desktop/Clean1101_2.csv", DataFrame; header=2, skipto = 10)

fig = Figure()
ax = Axis(fig[1,1], xlabel= "Column Volume", ylabel = "mAU(Abs)", 
             title = "SEC-cleaning")
# ax1 = Axis(fig[1,2], xlabel = "Column Volume", ylabel = "Pre-col pressure")
lines!(ax, df."UV1 (260 nm)_volume", df."UV1 (260 nm)_mAU"; label = "A260 nm")
# lines!(ax1, df[!, "PreCol Pressure_volume"], df[!, "PreCol Pressure_psi"]; label = "psi")
# lines!(ax, df."UV1 (215 nm)_volume", df."UV4 (495 nm)_mAU"; label = "495 nm")
axislegend(ax; position = :rt)
display(fig)
save("/Users/ianadams/Desktop/cleanSEC.png", fig)