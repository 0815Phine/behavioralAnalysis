import numpy as np
import cv2
import os
import imageio

# Path to the folder containing images
folder_path = "Z:\Histo\Lena_G735\G735-2\Images_aligned"

# Get all image file names (sorted for consistency)
image_files = sorted([f for f in os.listdir(folder_path) if f.endswith(('.tif'))])

# Load images into a list
image_list = []
for file in image_files:
    img = cv2.imread(os.path.join(folder_path, file), cv2.IMREAD_GRAYSCALE)  # Load as grayscale
    if img is None:
        print(f"Warning: Could not load {file}")
        continue
    image_list.append(img)

# Ensure all images have the same shape
assert all(img.shape == image_list[0].shape for img in image_list), "All images must have the same shape"

# Stack images into a 3D NumPy array
image_stack = np.stack(image_list, axis=2)  # Stacked along depth axis

# Print result
print("Stacked Image Shape:", image_stack.shape)  # (height, width, num_images)
imageio.mimwrite("stacked_image.tiff", image_stack, format="TIFF")