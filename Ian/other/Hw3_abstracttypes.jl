
# Create an Abstract type that stores two series of numbers

using Pkg
using DataFrames
Pkg.instantiate()
Pkg.add("Interpolations")

# example data of type integer stored in DataFrame
data = rand(Int, 10)
df = DataFrame(x = data)
typeof(df.x)

# define non-mutable struct type

abstract type IntSeries end

struct SeriesData <: IntSeries
    unsort::Vector{Int}
    sort::Vector{Int}
end

# function that takes a SeriesData object and returns the sorted series

function sort_series_data(df::DataFrame)
    sorted_data = sort(df.x)
    sorted = collect(sorted_data)
    return sorted 
end

new_series = SeriesData(df.x, sort_series_data(df))
new_series.unsort == df.x
new_series.sort == sort(df.x)
