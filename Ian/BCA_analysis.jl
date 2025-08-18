# interpolate BCA absorbance readings against standard curve. 


using Statistics
using CairoMakie
using Interpolations

standards = [0, 25, 125, ]
std_abs = [
                    1.38, 1.525;
                    1.165, 0.879;
                    0.619, 0.864;
                    0.632,0.677;
                    0.43,0.382;
                    0.266,0.286;
                    0.226,0.199;
                    0.147,0.154;
                    0.127,0.133
                ]



            """
                process_standard_curve(concentrations, measurements)
            
            Process standard curve data with replicate measurements.
            
            # Arguments
            - `concentrations`: Vector of known concentrations for the standards
            - `measurements`: Matrix where each row contains replicate measurements for a standard
            
            # Returns
            - Tuple containing (fitted_curve, r_squared)
            """
            function process_standard_curve(concentrations, measurements)
                # Calculate mean of replicate measurements
                means = [mean(measurements[i,:]) for i in 1:size(measurements, 1)]
                
                # Create interpolation object
                # Using cubic spline interpolation
                interp = CubicSplineInterpolation(means, concentrations)
                
                # Calculate R² for goodness of fit
                predicted = [interp(m) for m in means]
                ss_total = sum((concentrations .- mean(concentrations)).^2)
                ss_residual = sum((concentrations .- predicted).^2)
                r_squared = 1 - ss_residual/ss_total
                
                return interp, r_squared
            end
            
            """
                plot_standard_curve(concentrations, measurements, curve)
            
            Plot standard curve with raw data points and fitted curve.
            
            # Arguments
            - `concentrations`: Vector of known concentrations for standards
            - `measurements`: Matrix where each row contains replicate measurements for a standard
            - `curve`: Interpolation object returned by process_standard_curve
            """
            function plot_standard_curve(concentrations, measurements, curve)
                # Calculate mean and std of replicates
                means = [mean(measurements[i,:]) for i in 1:size(measurements, 1)]
                stds = [std(measurements[i,:]) for i in 1:size(measurements, 1)]
                
                # Create plot
                p = scatter(means, concentrations, 
                            yerror=stds, 
                            label="Standards", 
                            xlabel="Measurement", 
                            ylabel="Concentration",
                            title="Standard Curve")
                
                # Add fitted curve
                x_range = range(minimum(means)*0.9, maximum(means)*1.1, length=100)
                y_predicted = [curve(x) for x in x_range]
                plot!(p, x_range, y_predicted, label="Fitted Curve", linewidth=2)
                
                return p
            end
            
            """
                interpolate_samples(sample_measurements, curve)
            
            Interpolate concentrations for sample measurements using the standard curve.
            
            # Arguments
            - `sample_measurements`: Vector or Matrix of sample measurements
            - `curve`: Interpolation object returned by process_standard_curve
            
            # Returns
            - Vector of interpolated concentrations
            """
            function interpolate_samples(sample_measurements, curve)
                if isa(sample_measurements, Vector)
                    return [curve(m) for m in sample_measurements]
                else
                    # For matrix input, calculate mean of replicates
                    return [curve(mean(sample_measurements[i,:])) for i in 1:size(sample_measurements, 1)]
                end
            end
            
            # Example usage
            function run_example()
                # Example data: 9 standards with 2 measurements each
                concentrations = [0.0, 0.5, 1.0, 2.5, 5.0, 10.0, 25.0, 50.0, 100.0]
                
                # Create example measurements (signal increases with concentration)
                # In real data, replace this with actual measurements
                measurements = zeros(9, 2)
                for i in 1:9
                    # Simulate measurements with some noise
                    base_signal = 10 * log(1 + concentrations[i])
                    measurements[i,1] = base_signal + 0.2 * randn()
                    measurements[i,2] = base_signal + 0.2 * randn()
                end
                
                # Process standard curve
                curve, r_squared = process_standard_curve(concentrations, measurements)
                println("Standard curve processed. R² = ", r_squared)
                
                # Plot the standard curve
                p = plot_standard_curve(concentrations, measurements, curve)
                display(p)
                
                # Example sample data (3 samples with duplicates)
                sample_measurements = [
                    1.38, 1.525;
                    1.165, 0.879;
                    0.619, 0.864;
                    0.632,0.677;
                    0.43,0.382;
                    0.266,0.286;
                    0.226,0.199;
                    0.147,0.154;
                    0.127,0.133
                ]
                
                # Interpolate sample concentrations
                sample_concentrations = interpolate_samples(sample_measurements, curve)
                
                println("Sample interpolation results:")
                for i in 1:size(sample_measurements, 1)
                    println("Sample ", i, ": ", 
                            round(sample_measurements[i,1], digits=2), ", ", 
                            round(sample_measurements[i,2], digits=2), " → ", 
                            round(sample_concentrations[i], digits=2))
                end
                
                return concentrations, measurements, curve, sample_measurements, sample_concentrations
            end
            
            # Uncomment to run the example
            # run_example()