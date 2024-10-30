1. Why in Raman spectroscopy are the spectra shown in wavenumber instead of wavelength?

The Raman shift, the difference in the incident light and the scattered light, results from a shift in vibrational energy. Wavenumber is directly proportional to this change in energy, making it more intuitive than wavelength. 

2. Calculate the photons emitted per second from an Alexa488 dye pumped at 100 W/cm2.

$$488\text{ nm} = \frac{c}{f} \rightarrow 488\times10^{-9}\text{ m} \times f = 3\times10^8\text{ m/s} \rightarrow f = 6.14\times10^{14}\text{ Hz}$$
$$E = h \cdot f = 6.626\times10^{-34}\text{ J}\cdot\text{s} \times 6.14\times10^{14}\text{ Hz} = 4.068\times10^{-19}\text{ J}$$
$$\text{Photon flux} = \frac{100\text{ W/cm}^2}{4.068\times10^{-19}\text{ J}} = 2.46\times10^{20}\text{ photons/(s}\cdot\text{cm}^2)$$

3. Use the Perrin equation to explain why the fluorescence anisotropy of fluorescein in solution is nearly zero, whereas for GFP it is not.

The Perrin equation relates rotational diffusion of a flourophore $\frac{\tau}{\theta}$ to the anisotropy in solution. With faster rotational diffusion, anisotropy drops.

$$\[ r = \frac{r_0}{1 + \frac{\tau}{\theta}} \]$$

Flourescein is a small organic molecule (332 g/mol) that can rotate much faster than the 3-4 ns flourecense lifetime. GFP, a protein over 27 kDa, rotates more slowly, preseverving the anisotropy from parallel photoselected flourophores. 

(1 point). Why does the gain of a PMT change so rapidly (non-linearly) with the voltage between dynodes?

The negative potential of the dynode determines the number of electrons ejected following collison with the incident photoelectron. Higher voltages allow more electrons to eject to the next dynode, and the amplification will be much higher because now each subsequent dynode is receiving more and more electrons.
