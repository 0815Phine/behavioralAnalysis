import os
import tkinter as tk
from tkinter import filedialog
from moviepy.editor import VideoFileClip
from moviepy.video.fx.all import speedx

def choose_file(start_path):
    root = tk.Tk()
    root.withdraw()  # Hide the main window

    file_path = filedialog.askopenfilename(initialdir=start_path, title="Select a video file")

    return file_path

def velocity_video(input_file, output_file, factor):
    # Load the video clip
    clip = VideoFileClip(input_file)

    # adjust the video speed
    new_clip = clip.fx(speedx, factor)

    # Save the new video
    new_clip.write_videofile(output_file, codec='libx264')


# Get the user's home directory
home_dir = os.path.expanduser("~")
# Define the start path
start_path = os.path.join(home_dir, 'OneDrive', 'Whiskertracking', 'Videos')
start_path = filedialog.askdirectory(initialdir=start_path, title='Select Folder')
# Prompt the user to select a file
input_file = choose_file(start_path)
file_name = os.path.splitext(os.path.basename(input_file))[0]

output_file = os.path.join(start_path, f'{file_name}_slowed.mp4')

# Define the start and end times for cropping
factor = 0.25 #input("How fast do you want to have the video?")

velocity_video(input_file, output_file, factor)