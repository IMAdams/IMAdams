# A julia-based substitute for 2 channel single-particle tracking. Built to accomodate the results of SMITE matlab tracking. 

using MAT

filepath = "/Users/ianadams/Documents/IMAdams/Ian/TrajVideoMaker/example_data/00_CHOHAEGFR_wt_resting-2025-7-8-13-13-48_Channel1_Results.mat"
# load the .mat file
data = matread(filepath)

# Function to load and explore .mat file structure

# Function to load and explore .mat file structure
function explore_mat_file(filename::String)
    println("Loading file: $filename")
    println("="^50)
    
    try
        # Load the .mat file
        data = matread(filename)
        
        # Display top-level structure
        println("Top-level variables in the .mat file:")
        for (key, value) in data
            println("  $key: $(typeof(value))")
            if isa(value, Array)
                println("    Size: $(size(value))")
            elseif isa(value, Dict)
                println("    Dict with $(length(value)) entries")
            end
        end
        
        println("\n" * "="^50)
        return data
        
    catch e
        println("Error loading file: $e")
        return nothing
    end
end


# Function to load and explore .mat file structure
function explore_mat_file(filename::String)
    println("Loading file: $filename")
    println("="^50)
    
    try
        # Load the .mat file
        data = matread(filename)
        
        # Display top-level structure
        println("Top-level variables in the .mat file:")
        for (key, value) in data
            println("  $key: $(typeof(value))")
            if isa(value, Array)
                println("    Size: $(size(value))")
            elseif isa(value, Dict)
                println("    Dict with $(length(value)) entries")
            end
        end
        
        println("\n" * "="^50)
        return data
        
    catch e
        println("Error loading file: $e")
        return nothing
    end
end


# Function to list all keys in a dictionary variable
function list_all_keys(data::Dict, varname::String)
    if haskey(data, varname)
        var = data[varname]
        if isa(var, Dict)
            println("All keys in '$varname':")
            sorted_keys = sort(collect(keys(var)))
            for (i, key) in enumerate(sorted_keys)
                println("  [$i] $key")
            end
            return sorted_keys
        else
            println("Variable '$varname' is not a dictionary")
            return nothing
        end
    else
        println("Variable '$varname' not found")
        return nothing
    end
end

       
    explore_mat_file(filepath)
    examine_variable(data, "TR")
    list_all_keys(data, "TR")
    data_tr = data["TR"]
    examine_variable(data_tr,"FrameNum")
    examine_variable(data_tr,"X")
    examine_variable(data_tr,"Y")

    # Functions for working with trajectory data
    issues = 0
    for i in 1:min(10, n_particles)  # Check first 10 particles
        frames = TR["FrameNum"][i]
        x_coords = TR["X"][i] 
        y_coords = TR["Y"][i]
        
        if length(frames) != length(x_coords) || length(frames) != length(y_coords)
            println("⚠️  Particle $i: Length mismatch - Frames:$(length(frames)), X:$(length(x_coords)), Y:$(length(y_coords))")
            issues += 1
        end
    end# Functions for working with trajectory data

# Extract trajectory data for a specific particle
function get_particle_trajectory(data::Dict, particle_id::Int)
    TR = data["TR"]
    
    if particle_id < 1 || particle_id > length(TR["FrameNum"])
        error("Particle ID $particle_id out of range. Valid range: 1-$(length(TR["FrameNum"]))")
    end
    
    # Extract data for this particle
    frames = TR["FrameNum"][particle_id]
    x_coords = TR["X"][particle_id]
    y_coords = TR["Y"][particle_id]
    
    return (
        frames = frames,
        x = x_coords, 
        y = y_coords,
        n_points = length(frames)
    )
end

# Get summary statistics for all trajectories
function trajectory_summary(data::Dict)
    TR = data["TR"]
    n_particles = length(TR["FrameNum"])
    
    println("Trajectory Data Summary:")
    println("="^40)
    println("Number of particles: $n_particles")
    
    # Analyze trajectory lengths
    lengths = []
    frame_ranges = []
    
    for i in 1:n_particles
        frames = TR["FrameNum"][i]
        push!(lengths, length(frames))
        if length(frames) > 0
            push!(frame_ranges, (minimum(frames), maximum(frames)))
        end
    end
    
    println("\nTrajectory lengths:")
    println("  Min: $(minimum(lengths)) frames")
    println("  Max: $(maximum(lengths)) frames") 
    println("  Mean: $(round(sum(lengths)/length(lengths), digits=1)) frames")
    
    if length(frame_ranges) > 0
        all_min_frames = [r[1] for r in frame_ranges]
        all_max_frames = [r[2] for r in frame_ranges]
        
        println("\nFrame coverage:")
        println("  Dataset spans frames: $(minimum(all_min_frames)) to $(maximum(all_max_frames))")
        println("  Total frames in dataset: $(Int(maximum(all_max_frames) - minimum(all_min_frames) + 1))")
    end
    
    # Show some example trajectory info
    println("\nFirst 5 trajectories:")
    for i in 1:min(5, n_particles)
        frames = TR["FrameNum"][i]
        x_coords = TR["X"][i] 
        y_coords = TR["Y"][i]
        n_points = length(frames)
        if n_points > 0
            min_frame = Int(minimum(frames))
            max_frame = Int(maximum(frames))
            println("  Particle $i: $n_points points, frames $min_frame-$max_frame")
        else
            println("  Particle $i: Empty trajectory")
        end
    end
    
    return (
        n_particles = n_particles,
        lengths = lengths,
        frame_ranges = frame_ranges
    )
end

# Extract all trajectory data in a more convenient format
function extract_all_trajectories(data::Dict)
    TR = data["TR"]
    n_particles = length(TR["FrameNum"])
    
    trajectories = []
    
    for i in 1:n_particles
        traj = get_particle_trajectory(data, i)
        push!(trajectories, traj)
    end
    
    return trajectories
end

# Function to check data consistency
function check_data_consistency(data::Dict)
    TR = data["TR"]
    n_particles = length(TR["FrameNum"])
    issues = 0
    for i in 1:min(10, n_particles)  # Check first 10 particles
        frames = data_tr["FrameNum"][i]
        x_coords = data_tr["X"][i] 
        y_coords = data_tr["Y"][i]
        
        if length(frames) != length(x_coords) || length(frames) != length(y_coords)
            println("⚠️  Particle $i: Length mismatch - Frames:$(length(frames)), X:$(length(x_coords)), Y:$(length(y_coords))")
            issues += 1
        end
    end

    println("Data consistency check:")
    println("="^30)
    
    if issues == 0
        println("✅ All checked trajectories have consistent data lengths")
    else
        println("❌ Found $issues issues in trajectory data")
    end
    
    return issues == 0
end


all_trajs = extract_all_trajectories(data)
trajectory_summary(data)
get_particle_trajectory(data, 1)
    
check_data_consistency(data)

using Plots
using Colors

# Set backend (PlotlyJS works well for 3D animations, GR is also good)
# plotlyjs()  # or gr() for faster rendering

function animate_particle_trajectories(all_trajs; 
                                     fps = 20,   
                                    
                                     frame_time = 0.050, # time in (s)
                                     trail_length=1000,
                                     show_trails=true,
                                     point_size=2,
                                     colors=nothing,
                                     x_bounds=(0.0, 128.0),
                                     y_bounds=(0.0, 128.0),
                                     z_bounds=(1.0, 1000.0),
                                     save_path="particle_animation.gif",
                                     auto_save=true)
    """
    Animate particle trajectories in 3D with time as the z-axis
    
    Parameters:
    - all_trajs: Vector of NamedTuples containing trajectory data
    - fps: Frames per second for animation
    - trail_length: Number of previous positions to show as trails
    - show_trails: Whether to show particle trails
    - point_size: Size of the particles
    - colors: Vector of colors for each trajectory (auto-generated if nothing)
    - x_bounds: Tuple (min, max) for x-axis limits, default (0.0, 128.0)
    - y_bounds: Tuple (min, max) for y-axis limits, default (0.0, 128.0)  
    - z_bounds: Tuple (min, max) for z-axis limits, default (1.0, 1000.0)
    - save_path: Path to save the animation file (default "particle_animation.gif")
    - auto_save: If true, automatically saves the animation; if false, returns animation object
    """
    
    # Get dimensions
    n_trajectories = length(all_trajs)
    max_frames = maximum([size(traj.frames, 1) for traj in all_trajs])
    
    # Generate colors if not provided
    if colors === nothing
        colors = distinguishable_colors(n_trajectories, [RGB(1,1,1), RGB(0,0,0)])
    end
    
    # Use provided z bounds
    z_min, z_max = z_bounds
    
    # Create animation
    anim = @animate for frame_idx in 1:max_frames
        p = plot3d(
            xlims=x_bounds,
            ylims=y_bounds,
            zlims=(z_min, z_max),
            xlabel="X Position",
            ylabel="Y Position",
            zlabel="Time (Frame)",
            title="Particle Trajectories (Time(s) $frame_idx*$frame_time)",
            legend=false,
            size=(800, 600),
            camera=(45, 23.5)  # Adjust viewing angle
        )
        
        for (traj_idx, traj) in enumerate(all_trajs)
            n_frames_traj = size(traj.frames, 1)
            
            # Skip if this trajectory doesn't have data for current frame
            if frame_idx > n_frames_traj
                continue
            end
            
            # Determine which points to plot for this trajectory
            if show_trails && frame_idx > 1
                # Show trail
                start_frame = max(1, frame_idx - trail_length)
                trail_frames = start_frame:frame_idx
                
                # Plot trail with fading alpha
                for (i, t_frame) in enumerate(trail_frames)
                    if t_frame <= n_frames_traj && t_frame <= size(traj.x, 1) && t_frame <= size(traj.y, 1)
                        alpha = 1.0
                        # alpha = 0.2 + 0.8 * (i / length(trail_frames))  # Fade from 0.2 to 1.0
                        
                        # Get positions for this frame - handle potential dimension mismatches
                        x_pos = traj.x[t_frame, :]
                        y_pos = traj.y[t_frame, :]
                        
                        # Ensure we don't exceed the actual number of points
                        actual_n_points = min(length(x_pos), length(y_pos), traj.n_points)
                        x_pos = x_pos[1:actual_n_points]
                        y_pos = y_pos[1:actual_n_points]
                        
                        z_pos = fill(Float32(traj.frames[t_frame, 1]), actual_n_points)
                        
                        # Filter out NaN/Inf values
                        valid_idx = isfinite.(x_pos) .& isfinite.(y_pos) .& isfinite.(z_pos)
                    
                        if any(valid_idx)
                            scatter3d!(p, 
                                x_pos[valid_idx], 
                                y_pos[valid_idx], 
                                z_pos[valid_idx],
                                color=colors[traj_idx],
                                alpha=alpha,
                                markersize=point_size * (alpha + 0.5),
                                markerstrokewidth=0
                            )
                        end
                    end
                end
            else
                # Just show current positions - handle potential dimension mismatches
                if frame_idx <= size(traj.x, 1) && frame_idx <= size(traj.y, 1)
                    x_pos = traj.x[frame_idx, :]
                    y_pos = traj.y[frame_idx, :]
                    
                    # Ensure we don't exceed the actual number of points
                    actual_n_points = min(length(x_pos), length(y_pos), traj.n_points)
                    x_pos = x_pos[1:actual_n_points]
                    y_pos = y_pos[1:actual_n_points]
                    
                    z_pos = fill(Float32(traj.frames[frame_idx, 1]), actual_n_points)
                    
                    # Filter out NaN/Inf values
                    valid_idx = isfinite.(x_pos) .& isfinite.(y_pos) .& isfinite.(z_pos)
                
                    if any(valid_idx)
                        scatter3d!(p,
                            x_pos[valid_idx],
                            y_pos[valid_idx], 
                            z_pos[valid_idx],
                            color=colors[traj_idx],
                            markersize=point_size,
                            markerstrokewidth=0
                        )
                    end
                end
            end
            end
        end
    
    # Save animation or return animation object
    if auto_save
        println("Saving animation to: $save_path")
        if endswith(lowercase(save_path), ".gif")
            gif(anim, save_path, fps=fps)
        elseif endswith(lowercase(save_path), ".mp4")
            mp4(anim, save_path, fps=fps)
        else
            # Default to gif if extension is unclear
            gif(anim, save_path, fps=fps)
        end
        println("Animation saved successfully!")
        return save_path
    else
        return anim
    end
end

# Alternative function for showing full trajectories as continuous lines
function plot_full_trajectories_3d(all_trajs; 
                                  colors=nothing, 
                                  line_width=2,
                                  x_bounds=(0.0, 128.0),
                                  y_bounds=(0.0, 128.0),
                                  z_bounds=(1.0, 1000.0))
    """
    Plot all trajectories as continuous 3D lines
    
    Parameters:
    - all_trajs: Vector of NamedTuples containing trajectory data
    - colors: Vector of colors for each trajectory (auto-generated if nothing)
    - line_width: Width of trajectory lines
    - x_bounds: Tuple (min, max) for x-axis limits, default (0.0, 128.0)
    - y_bounds: Tuple (min, max) for y-axis limits, default (0.0, 128.0)
    - z_bounds: Tuple (min, max) for z-axis limits, default (1.0, 1000.0)
    """
    n_trajectories = length(all_trajs)
    
    if colors === nothing
        colors = distinguishable_colors(n_trajectories, [RGB(1,1,1), RGB(0,0,0)])
    end
    
    # Use provided z bounds
    z_min, z_max = z_bounds
    
    p = plot3d(
        xlims=x_bounds,
        ylims=y_bounds,
        zlims=(z_min, z_max),
        xlabel="X Position",
        ylabel="Y Position", 
        zlabel="Time (Frame)",
        title="Complete Particle Trajectories",
        legend=false,
        size=(800, 600)
    )
    
    for (traj_idx, traj) in enumerate(all_trajs)
        n_frames = size(traj.frames, 1)
        
        # For each particle in this trajectory
        for particle_idx in 1:traj.n_points
            x_coords = traj.x[:, particle_idx]
            y_coords = traj.y[:, particle_idx]
            z_coords = traj.frames[:, 1]  # Use frame numbers as z-coordinates
            
            # Filter out NaN/Inf values
            valid_idx = isfinite.(x_coords) .& isfinite.(y_coords) .& isfinite.(z_coords)
            
            if sum(valid_idx) > 1  # Need at least 2 points for a line
                plot3d!(p,
                    x_coords[valid_idx],
                    y_coords[valid_idx],
                    z_coords[valid_idx],
                    color=colors[traj_idx],
                    linewidth=line_width,
                    alpha=0.7
                )
            end
        end
    end
    
    return p
end

# Add debugging function to inspect data structure
function inspect_trajectory_data(all_trajs; max_trajs_to_show=3)
    """
    Inspect the structure of trajectory data to debug dimension issues
    """
    println("Number of trajectories: ", length(all_trajs))
    
    for (i, traj) in enumerate(all_trajs[1:min(max_trajs_to_show, length(all_trajs))])
        println("\n--- Trajectory $i ---")
        println("n_points: ", traj.n_points)
        println("frames shape: ", size(traj.frames))
        println("x shape: ", size(traj.x))
        println("y shape: ", size(traj.y))
        
        # Check for consistency
        if size(traj.x, 2) != traj.n_points
            println("WARNING: x columns ($(size(traj.x, 2))) != n_points ($(traj.n_points))")
        end
        if size(traj.y, 2) != traj.n_points
            println("WARNING: y columns ($(size(traj.y, 2))) != n_points ($(traj.n_points))")
        end
        if size(traj.x, 1) != size(traj.y, 1)
            println("WARNING: x rows ($(size(traj.x, 1))) != y rows ($(size(traj.y, 1)))")
        end
        if size(traj.frames, 1) != size(traj.x, 1)
            println("WARNING: frames rows ($(size(traj.frames, 1))) != x rows ($(size(traj.x, 1)))")
        end
    end
end
# Example usage:
# Create and save the animation in one step
# animate_particle_trajectories(all_trajs, fps=15, trail_length=30, show_trails=true)
# This will create "particle_animation.gif" by default

# Or create the animation object and save it manually
# anim = animate_particle_trajectories(all_trajs, fps=15, trail_length=30, show_trails=true)
# gif(anim, "my_particles.gif", fps=15)

# Or create a static plot of all trajectories
# p = plot_full_trajectories_3d(all_trajs)
# savefig(p, "all_trajectories_3d.png")

println("Functions defined successfully!")
println("Usage:")
println("1. anim = animate_particle_trajectories(all_trajs)")
println("2. gif(anim, \"output.gif\", fps=15)")
println("3. p = plot_full_trajectories_3d(all_trajs)  # for static plot")
anim = animate_particle_trajectories(all_trajs)
gif(anim, "./output3.gif", fps=20)

display(anim[1])