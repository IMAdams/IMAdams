# code for plotting data from smite DBSCAN *results.mat

using MAT

# import data for each group under comparison

datapath = "C:\\Users\\imadams\\OneDrive - University of New Mexico Health Sciences Center\\Desktop\\Hek ALFA-EGFR (L858R) BaGoL\\Clustering\\Results\\Analysis\\DBSCAN_N=3,E=30\\"

wtRestfile = matopen(string(datapath,"wt_rest#DBSCAN_N=3,E=30_results.mat"));
wtRest = read(wtRestfile, "results")

# wtRestVars = matread(string(datapath,"wt_rest#DBSCAN_N=3,E=30_results.mat"))
# wtRestVars["results"][5]

wtEGFfile = matopen(string(datapath,"wtEGF#DBSCAN_N=3,E=30_results.mat"));
wtEGF = read(wtEGFfile, "results")

L858Rrestfile = matopen(string(datapath,"L858R_rest#DBSCAN_N=3,E=30_results.mat"));
L858Rrest = read(L858Rrestfile, "results")

L858RegfFile = matopen(string(datapath,"L858R_egf#DBSCAN_N=3,E=30_results.mat"));
L858Regf= read(L858RegfFile, "results")


function clustsPerPoint(data)
    cPP_data = Array{Float64}(undef, 1, size(data)[2])
    for i in 1:size(data)[2] cPP_data[i]= /(data[i]["n_clustered"], data[i]["n_points"]) end
    for i in 1:size(cPP_data)[2] if cPP_data[i] == 0 || cPP_data[i] == NaN pop!(cPP_data[i]) end end
    return cPP_data
end

CDFDict = Dict{String, Array}("wt Rest" => clustsPerPoint(wtRest), "wt +EGF" => clustsPerPoint(wtEGF), 
    "L858R Rest" => clustsPerPoint(L858Rrest), "L858R +EGF" => clustsPerPoint(L858Regf))

print(keys(CDFDict))


using CairoMakie
using Colors

fig = Figure()

ax = Axis(fig[1,1], 
    ygridvisible = false, xgridvisible = false, 
    xlabel = "fraction of clustered localizations per ROI", ylabel = "CDF",
    limits = (minimum(CDFDict["wt Rest"]),1.0, 0.0, 1.0),
    xminorticksvisible = true, yminorticksvisible = true)

ecdfplot!(ax, CDFDict["wt Rest"][:], label = "EGFR-WT Resting", step = :center, Color = :cyan2, linewidth = 4)
ecdfplot!(ax, CDFDict["wt +EGF"][:] , label = "EGFR-WT +EGF", step = :center, color = :blue)
ecdfplot!(ax, CDFDict["L858R Rest"][:] , label = "EGFR-L858R Resting", step = :center, Color = :magenta)
ecdfplot!(ax, CDFDict["L858R +EGF"][:] , label = "EGFR-L858R +EGF", step = :center, color = :magenta4)
axislegend(ax; position = :lt)


fig
empty!(fig)
clustsPerPoint[:]
typeof(cPP_wtRest)
