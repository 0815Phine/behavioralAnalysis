# this code takes really long for long videos and i am not sure if it displays if frames were skipped during aquisition
import ffmpeg
import os
import tkinter as tk
from tkinter import filedialog

# Open the Tkinter root window (necessary for file dialog)
root = tk.Tk()
root.withdraw()  # Hide the root window

# ------ select file ------
home_dir = os.path.expanduser("~")
start_path = os.path.join(home_dir, 'Z:\Animals')
start_path = filedialog.askdirectory(initialdir=start_path, title='Select Folder')
# Access file names in the selected folder
if not start_path:
    print("No folder selected.")
    exit()

video_file = filedialog.askopenfilename( initialdir=start_path, title="Select a File", filetypes=(("All files", "*.*"),))
# Check if a file was selected
if video_file:
    print(f"Selected file: {video_file}")
else:
    print("No file selected.")
    exit()

# ------  ------
def get_frame_timestamps(video_file):
    """Function to extract timestamps of each frame using ffmpeg"""
    try:
        probe = ffmpeg.probe(video_file, v='error', select_streams='v:0', show_entries='frame=pkt_pts_time,pkt_dts_time,pts_time')
        
        # Print out the keys of a single frame to check what's available
        print("Available frame data keys:", probe['frames'][0].keys())
        
        # Try extracting pkt_pts_time, pkt_dts_time, or pts_time
        timestamps = []
        for frame in probe['frames']:
            if 'pkt_pts_time' in frame:
                timestamps.append(float(frame['pkt_pts_time']))
            elif 'pkt_dts_time' in frame:
                timestamps.append(float(frame['pkt_dts_time']))
            elif 'pts_time' in frame:
                timestamps.append(float(frame['pts_time']))
            else:
                # If no valid timestamp, append a placeholder or skip the frame
                timestamps.append(None)

        return timestamps
        
    except ffmpeg.Error as e:
        print(f"Error occurred while processing video: {e}")
        return []

# Get the frame timestamps
frame_timestamps = get_frame_timestamps(video_file)

# Display the first 10 frame timestamps
if frame_timestamps:
    print(f"First 10 frame timestamps: {frame_timestamps[:10]}")
else:
    print("No timestamps available.")