using MAT
using Images
using DataFrames

function load_mat_dipseq(filepath, dataname)
    datapath = filepath*dataname*".mat"
    file = matopen(datapath)
        
    # Load sequence data
    sequence = read(file, "sequence")
    seqraw = sequence["data"]
    
    close(file)
    
    return seqraw
end

function load_TR(filepath, dataname)
    resultspath1 = filepath*"Results\\"*dataname*"_Channel1_Results.mat"
    file1 = matopen(resultspath1)
    TR1 = read(file1, "TR")
    close(file1)
    resultspath2 = filepath*"Results\\"*dataname*"_Channel2_Results.mat"
    file2 = matopen(resultspath2)
    TR2 = read(file2, "TR")
    close(file2)
    return TR1, TR2
end    


function split_channels(combined_array::Array{T, 3}) where T
    # Check if the array has the expected shape
    if size(combined_array, 2) != 256
        error("Expected second dimension to be 256, got $(size(combined_array, 1))")
    end

    # Extract channel 1 (rows 1:128)
    channel1 = combined_array[:, 1:128, :]

    # Extract channel 2 (rows 129:end)
    channel2 = combined_array[:, 129:end, :]

    return channel1, channel2
end

function transform_channels()
end



