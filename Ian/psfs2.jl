# set-up environment
using FFTW
using LaTeXStrings
using Plots
using Statistics

# define functions
# Write a function that takes as input: Numerical Aperture (NA), Wavelength (λ) Pixel size (Δx, Δy) z-stack range and step size Image size (NxN pixels)
function modelPSF(NA, λ, xsz, ysz, zstep, zrange, NxN::Tuple{Int64,Int64})
    npix = NxN[1]
    zpositions = collect(0:zstep:zrange-1)

    # Initialize PSF stack
    psf_stack = zeros(Complex{Float64}, npix, npix, length(zpositions))

    x = range(-xsz * npix / 2, xsz * npix / 2, length=npix)
    dx = x[2] - x[1]
    fS = 1 / dx
    df = fS / npix
    fx = range(-fS / 2, fS / 2, length=npix)

    fNA = NA / λ
    pupilRadius = fNA / df
    pupilCenter = npix / 2

    # Create coordinate grids
    W = repeat(0:npix-1, 1, npix)
    H = repeat((0:npix-1)', npix, 1)

    # Create frequency grids for phase calculation
    fx_grid = repeat(fx, 1, npix)
    fy_grid = repeat(fx', npix, 1)

    # Create pupil mask
    pupilMask = @. sqrt((W - pupilCenter)^2 + (H - pupilCenter)^2) <= pupilRadius
    pupil = complex.(pupilMask)

    # Process each z-position
    for (i, z) in enumerate(zpositions)
        # Calculate phase using 2D frequency grid
        phase = defocus_phase(z, λ, NA, fx_grid, fy_grid)
        psf_stack[:, :, i] = fftshift(fft(pupil .* phase, (1, 2)))
    end

    # Normalize using squared abolute value
    norm_stack = abs2.(psf_stack)
    norm_factor = sum(norm_stack[:, :, 1])
    norm_stack ./= norm_factor
    # plots = plotPSF(result, zpositions, fx)

    # Check PSF integral
    integral_stats = checkPSFIntegral(norm_stack)
    return norm_stack, integral_stats
end


function plotPSF(norm_stack::Array{Float64,3}, NA::Float64, λ::Float64, xsz::Float64, ysz::Float64,
    zstep::Int64, zrange::Int64, NxN::Tuple{Int64,Int64};figsize=(600,600))
    
    npix = NxN[1]
    zpositions = collect(0:zstep:zrange-1)

    # Recalculate fx
    x = range(-xsz * npix / 2, xsz * npix / 2, length=npix)
    dx = x[2] - x[1]
    fS = 1 / dx
    df = fS / npix
    fx = range(-fS / 2, fS / 2, length=npix)

    plots = []
    for depth_idx in 1:length(zpositions)
        p = heatmap(fx, fx,
            log10.(norm_stack[:, :, depth_idx] .+ 1),
            title="PSF at z = $(zpositions[depth_idx]) μm",
            xlabel=L"f_x \, (\mu m^{-1})",
            ylabel=L"f_y \, (\mu m^{-1})",
            colorbar=true,
            aspect_ratio=:equal,
            color=:greys,
            size = figsize,
            grid=false,
            xlimits=(-5,5),
            ylimits=(-5,5))
        push!(plots, p)

        # display(p)
    end
# Create 5x2 layout
final_plot = plot(plots..., layout=(5,2), size=(700,900))
display(final_plot)
    # return plots
end

function checkPSFIntegral(norm_stack::Array{Float64,3})
    # Get dimensions
    nx, ny, nz = size(norm_stack)

    # Calculate integral at each z
    z_integrals = zeros(nz)
    for z in 1:nz
        z_integrals[z] = sum(norm_stack[:, :, z])
    end

    # Compute statistics
    mean_integral = mean(z_integrals)
    var_integral = var(z_integrals)

    # Print diagnostic info
    println("PSF Integral Statistics:")
    println("Mean: ", mean_integral)
    println("Variance: ", var_integral)

    return (mean_integral, var_integral)
end

# defocus phase function
function defocus_phase(z, λ, NA, fx_grid, fy_grid)
    k = 2π / λ
    fr_squared = @. (λ * fx_grid)^2 + (λ * fy_grid)^2
    return @. exp(1im * k * z * (1 - sqrt(Complex(1 - fr_squared / (4 * NA^2)))))
end

# Usage examples:
# Direct parameters:
# plots = plotPSF(result, zpositions, fx)
# 
# Or with same args as modelPSF:
# plots = plotPSF(result, NA, λ, xsz, ysz, zstep, zrange, NxN)

# test functions
NA = .25
λ = 0.655
NxN = (128, 128)
pxsz = 0.1
zrange =10
zstep = 1

norm_stack, stats = modelPSF(NA, λ, pxsz, pxsz, zstep, zrange, NxN);
plots = plotPSF(norm_stack, NA, λ, pxsz, pxsz, zstep, zrange, NxN)
# savefig("psfplots.png")