function generate_video(images, trajectories, output_path; fps=30, colormap=:grays)
    # Create a video object
    encoder_options = (crf=23, preset="medium")
    open_video_out(output_path, images[1], framerate=fps, encoder_options=encoder_options) do writer
        for (i, img) in enumerate(images)
            frame_trajectories = filter(row -> row.frame == i, trajectories)
            
            # Create a plot with the current image and trajectories
            p = plot(img, axis=nothing, color=colormap)
            scatter!(p, frame_trajectories.x, frame_trajectories.y, 
                     group=frame_trajectories.particle_id, 
                     markersize=3, legend=false)
            
            # Convert plot to image and write to video
            frame = plot2img(p)
            write(writer, frame)
        end
    end
end

function plot2img(p)
    # Convert plot to RGB image
    img = plot2image(p)
    return RGB.(img)
end