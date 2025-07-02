import os
import tkinter as tk
from tkinter import filedialog
from moviepy.video.io.VideoFileClip import VideoFileClip

def choose_file(start_path):
    root = tk.Tk()
    root.withdraw()  # Hide the main window

    file_path = filedialog.askopenfilename(initialdir=start_path, title="Select a video file")

    return file_path

def get_output_file_name():
    output_file_name = input("Enter the output file name (without extension): ")
    return output_file_name

def crop_video_in_time(input_file, output_file, start_time, end_time):
    # Load the video clip
    clip = VideoFileClip(input_file)

    # Crop the video in time
    cropped_clip = clip.subclip(start_time, end_time)

    # Save the cropped video
    cropped_clip.write_videofile(output_file, codec='libx264')


# Get the user's home directory
home_dir = os.path.expanduser("~")
# Define the start path
start_path = os.path.join(home_dir, 'OneDrive', 'Whiskertracking', 'Videos')
start_path = filedialog.askdirectory(initialdir=start_path, title='Select Folder')
# Prompt the user to select a file
input_file = choose_file(start_path)

# Check if a file was selected
if input_file:
    # Specify the output file path
    output_file_name = get_output_file_name()
    output_file = os.path.join(start_path, f'{output_file_name}.mp4')

    # Define the start and end times for cropping
    start_time = input("Enter the start time in seconds: ")
    end_time = input("Enter the end time in seconds: ")

    # Crop the video in time
    crop_video_in_time(input_file, output_file, start_time, end_time)
else:
    print("No file selected.")