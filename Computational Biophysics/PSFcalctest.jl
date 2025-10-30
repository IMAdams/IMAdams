# using Pkg
# Pkg.add("MicroscopePSFs")

using MicroscopePSFs #, SMLMData
using Images
# create psf model
psf = AiryPSF(1.4, 0.680) # Sequential scope 100x objective

# psf evaluation at a point
intensity = psf(0.5,0.3)
# scmos orca flash
camera = IdealCamera(20,20, 0.065)

# create emitter
emitter = Emitter2D(1.0,1.0,1000)
# image
pixels = integrate_pixels(psf, camera, emitter)
grays(pixels)
# Create a PSF model
# psf = AiryPSF(1.4, 0.532)  # NA = 1.4, λ = 0.532μm (532nm)
# or
# psf = GaussianPSF(0.15)    # σ = 0.15μm (150nm)

# # Direct PSF evaluation at a point
# intensity = psf(0.5, 0.3)  # x = 0.5μm, y = 0.3μm

# # Create camera (20×20 pixels, 0.1μm pixel size)
# camera = IdealCamera(20, 20, 0.1)

# # Create emitter 
# emitter = Emitter2D(1.0, 1.0, 1000.0)  # x = 1μm, y = 1μm, 1000 photons

# # Generate realistic microscope image
# pixels = integrate_pixels(psf, camera, emitter)