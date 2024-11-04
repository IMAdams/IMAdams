using Pkg
# Pkg.add("CSV")
using CSV
# Pkg.add("DataFrames")
using DataFrames
# Pkg.add("CairoMakie")
using CairoMakie

df = CSV.read("D:LidkeLab\\FPLC\\20240925_HIS_HA_EGFR.csv", DataFrame; header=2, skipto = 10)

fig = Figure()
ax = Axis(fig[1,1], xlabel= "Column Volume", ylabel = "mAU(Abs)", 
            limits =(0,60,-100,2000), title = "20240920_HIS_HA_EGFR")
lines!(ax, df."UV1 (280 nm)_volume", df."UV1 (280 nm)_mAU"; label = "280 nm")
# lines!(ax, df."UV1 (215 nm)_volume", df."UV2 (255 nm)_mAU"; label = "255 nm")
# lines!(ax, df."UV1 (215 nm)_volume", df."UV3 (280 nm)_mAU"; label = "280 nm")
# lines!(ax, df."UV1 (215 nm)_volume", df."UV4 (495 nm)_mAU"; label = "495 nm")
axislegend(ax; position = :rt)
display(fig)
# save("C:\\Users\\imadams\\OneDrive - University of New Mexico Health Sciences Center\\Desktop\\20240920_HIS_HA_EGFR.png", fig)