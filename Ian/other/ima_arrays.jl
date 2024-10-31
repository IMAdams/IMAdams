#how arrays are created and indexed in julia. Top left corner is element 1,1. 
arr = zeros(3,5)
arr[1,1] = 1
arr[3,1] = 3
arr[end,end] = 7
arr[2,:] .= 6

arr[:] #get everything, return it as a vector
#go to cairomakie, find a new type of plot. give a code example with axis labels, legends
#get comfortable with arrays


