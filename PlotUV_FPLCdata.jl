using Pkg
# Pkg.add("CSV")
using CSV
# Pkg.add("DataFrames")
using DataFrames
# Pkg.add("CairoMakie")
using CairoMakie

df = CSV.read("C:\\Users\\imadams\\OneDrive - University of New Mexico Health Sciences Center\\Desktop\\FPLC\\SECtest1111.csv", DataFrame; header=2, skipto = 10)
fracs = CSV.read("C:\\Users\\imadams\\OneDrive - University of New Mexico Health Sciences Center\\Desktop\\FPLC\\SECtest1111.txt", DataFrame; header=1)
fig = Figure()
ax = Axis(fig[1,1], xlabel= "Column Volume", ylabel = "mAU(Abs)", 
            limits = (75, 95, -25, 700), title = "SECtest1111", titlegap = 8.0, xgridvisible = false, ygridvisible = false, topspinevisible=false)
ax2 = Axis(fig[1,1], ylabel = "mg/ml (Nanodrop)", limits = (75,95, 0, 0.85), yaxisposition = :right, xgridvisible=false,ygridvisible=false)
lines!(ax, df."UV2 (280 nm)_volume", df."UV2 (280 nm)_mAU"; label = "280 nm", color = :black, linewidth =3)
barplot!(ax2, fracs.ctrfrac[30:44], fracs.nanodrp2[30:44], width =1.0, color = (:yellow, 0.5), strokecolor = :black, strokewidth = 1,  bar_labels = fracs.nanodrp2[30:44], transparency = 0.1, label_offset = 6, label_font = :bold, label_rotation = .15π)

# for i in collect(31:1:44)
#     vlines!(ax, fracs.ctrfrac[i], label = fracs.var"Rack/Tube"[i])
# end



# axislegend(ax; position = :rt)


display(fig)

save("C:\\Users\\imadams\\OneDrive - University of New Mexico Health Sciences Center\\Desktop\\SECtest1111.svg", fig)
save("C:\\Users\\imadams\\OneDrive - University of New Mexico Health Sciences Center\\Desktop\\SECtest1111.png", fig)


 