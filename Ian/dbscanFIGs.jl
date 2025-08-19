# code for plotting data from smite DBSCAN *results.mat
using MAT

# import data for each group under comparison

datapath = "/Users/ianadams/Desktop/PrimaryLocalDirectory/LidkeLab/DBSCANresults/"

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
    xminorticksvisible = true, yminorticksvisible = true,
    xlabelsize=28.0f0,
    ylabelsize=28.0f0)

ecdfplot!(ax, CDFDict["wt Rest"][:], label = "EGFR-WT Resting", step = :center, color = :cyan2, linewidth = 8)
ecdfplot!(ax, CDFDict["wt +EGF"][:] , label = "EGFR-WT +EGF", step = :center, color = :steelblue4,linewidth = 8)
ecdfplot!(ax, CDFDict["L858R Rest"][:] , label = "EGFR-L858R Resting", step = :center, color = :magenta,linewidth = 8)
ecdfplot!(ax, CDFDict["L858R +EGF"][:] , label = "EGFR-L858R +EGF", step = :center, color = :grey10,linewidth = 8)
ecdfplot!(ax, CDFDict["L858R Rest"][:] , step = :center, color = :black,linewidth = 1)
ecdfplot!(ax, CDFDict["L858R +EGF"][:] , step = :center, color = :grey99,linewidth = 1)

axislegend(ax; position = :lt)


fig
save(string(datapath, "CDFclustROI.svg") , fig)

fig2 = Figure()
    ax2 = Axis(fig2[1,1],
    ygridvisible = false, xgridvisible = false, 
    ylabel = "fraction of clustered localizations per ROI",
    xticks = (1:4, ["EGFR-WT Resting", "EGFR-WT +EGF", "EGFR-L858R Resting","EGFR-L858R +EGF"]),
    # limits = (minimum(CDFDict["wt Rest"]),1.0, 0.0, 1.0),
    # xminorticksvisible = true, yminorticksvisible = true,
    xlabelsize=28.0f0,
    ylabelsize=28.0f0)


"""
Create a boxplot from a dictionary of data categories.

# Arguments
- `data_dict::Dict{String, Vector{Float64}}`: A dictionary where keys are category names 
  and values are numeric data vectors to be plotted.
- `title::String`: Title of the plot (optional).
- `xlabel::String`: Label for x-axis (optional).
- `ylabel::String`: Label for y-axis (optional).

# Returns
- A CairoMakie figure with the boxplot
"""
# function create_boxplot(
    data_dict::Dict{String, Vector{Float64}};
    title::String = "Boxplot",
    xlabel::String = "Categories", 
    ylabel::String = "Values"

    # Prepare data for plotting
    categories = collect(keys(CDFDict))
    data_values = [CDFDict[cat] for cat in categories]
    data_values = [vec(matrix) for matrix in data_values]
    # Create figure and axis

    fig = Figure()
    ax = Axis(fig[1,1],
    ygridvisible = false, xgridvisible = false, 
    ylabel = "fraction of clustered localizations per ROI",
    # xticks = (1:4, ["EGFR-WT Resting", "EGFR-WT +EGF", "EGFR-L858R Resting","EGFR-L858R +EGF"]),
    # limits = (minimum(CDFDict["wt Rest"]),1.0, 0.0, 1.0),
    # xminorticksvisible = true, yminorticksvisible = true,
    xlabelsize=28.0f0,
    ylabelsize=28.0f0)
       # Set x-ticks to category names
       ax.xticks = (1:length(categories), categories)
    # Create boxplot
    boxplot!(ax, categories, data_values)

    fig = Figure(size = (800, 600))
ax = Axis(fig[1,1],
    ygridvisible = false, 
    xgridvisible = false,
    ylabel = "fraction of clustered localizations per ROI",
    xlabelsize = 28.0f0,
    ylabelsize = 28.0f0
)

# Create boxplot using numerical positions and data
boxplot!(ax, 1:length(categories), data_values, 
    labels = categories,
    labelsize = 28.0f0
)

# Customize x-axis ticks
ax.xticks = (1:length(categories), categories)
    # return fig
# end
typeof(categories[1])
data_values[1]

# Diagnostic print to understand data structure
println("Categories: ", categories)
println("Data values type: ", typeof(data_values))
println("Data values first element type: ", typeof(data_values[1]))
println("Data values first element length: ", length(data_values[1]))

if all(x -> isa(x, Matrix), data_values)
    data_values = [vec(x) for x in data_values]
end