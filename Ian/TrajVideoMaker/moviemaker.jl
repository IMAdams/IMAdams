# A julia-based substitute for 2 channel single-particle tracking. Built to accomodate the results of SMITE matlab tracking. 

using Images, VideoIO, Makie, Colors, MAT
filepath = "O:\\Cell Path\\Lidke Lab\\IMAdams\\iX71 Single Particle Tracking\\20240816_alfa_EGFR_EGF_twocolor\\01_alfaEGFRcos7_EGF585655-2024-8-16-15-51-6.mat"
file = matopen(filepath)

varnames = names(file)

sequence = read(file, "sequence")

seqraw = sequence["data"]

im = seqraw[:,:,1]
im = im./maximum(im)
Gray.(im)

sequence