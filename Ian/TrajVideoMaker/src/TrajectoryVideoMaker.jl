module TrajectoryVideoMaker

using Images
using VideoIO
using Plots
using DataFrames
using Revise
using Makie
using MAT

export create_trajectory_video

includet("data_processing.jl")
includet("video_generation.jl")

function create_trajectory_video(image_sequence, trajectories, output_path; fps=30, colormap=:grays)
    # Process image sequence
    processed_images = process_image_sequence(image_sequence)
    
    # Process trajectories
    processed_trajectories = process_trajectories(trajectories)
    
    # Generate video
    generate_video(processed_images, processed_trajectories, output_path; fps=fps, colormap=colormap)
end

end

dataname ="00_alfaEGFRcos7_EGF585655-2024-8-16-15-48-60"; # no .mat extension
filepath = "O:\\Cell Path\\Lidke Lab\\IMAdams\\iX71 Single Particle Tracking\\20240816_alfa_EGFR_EGF_twocolor\\";
seqraw = load_mat_dipseq(filepath,dataname);
channel1, channel2 = split_channels(seqraw);
TR1, TR2=load_TR(filepath, dataname)

transformfile = matopen(filepath*"RegistrationTransform_Fiducial_1-2024-8-16-15-25-34.mat")
names(transformfile)    
