# EE5175_ImageSignalProcessing
Image Signal Processing Assignments

#### Laboratory Assignments

All codes are in MATLAB except Lab 10 on NLM Filtering/Denoising.

Lab 1) Translation and rotation of image using the translation matrix, homogeneous coordinates, target to source mapping, bilinear interpolation for fractional pixel coordinates.

Lab 2) Identifying SIFT feature descriptors from a set of images, finding the homography relating images 1,2 and images 2,3 using RANSAC algorithm, creating a canvas and blending the three images to form a panorama.

Lab 3) Application of space-invariant blur and space-varying blur using different types of sigma.

Lab 4) Shape from focus (SFF): Using a stack of images to create a 3D surface map, using the Sum Modified Laplacian (SML) operator.

Lab 5) Camera shake to motion blur: Using the camera trajectory to generate blurred images using averaging over individual exposure times, and using weighted averaging. Varying the blur based on depth and on focal length.

Lab 6) DFT, Magnitude Phase Dominance, Rotation Property: 2D DFT as two 1D DFTs for rows/columns, interchanging DFT magnitude and phase to obtain new images, rotating the DFT and seeing image rotation.

Lab 7) SVD, Walsh Hadamard Transform, DCT: Using various methods for reconstruction

Lab 8) Photometric Stereo: Using images with different lighting conditions for shape from shading (SFS). Estimated surface normal, lighting directions, 3D surface plot, using SVD and integration using weighted Poisson method.

Lab 9) Otsu Thresholding and K-Means Clustering: Using Otsu algorithm for optimal binary thresholding (maximizing the inter-class variance). Using K-Means Clustering for segmentation or compression (less colours).

Lab 10) Non-Local Means Filtering: Using the NLM algorithm for denoising. Creates a box filter that identifies regions which are similar to the neighbourhood of the pixel being considered, and filters the image accordingly. Equivalent to a non-local range term similar to the one present in a bilateral filtering algorithm.

Lab 11) Non-blind deblurring using gradient regularization: Used L2 prior (has a closed form expression) and L1 prior (solved using the constrained least squares method). The blur kernel being assumed is Gaussian (for different values of sigma) or a motion blur kernel.

Lab 12) Non-blind deblurring using Weiner Filtering: The Weiner filter is equivalent to a MAP estimator and is another non-blind deblurring technique. It uses the power spectral density of the image (f) and the noise (n), which can be estimated from using multiple  images of the same type.
