import pickle
import os
import tkinter as tk
from tkinter import filedialog

def choose_file(start_path):
    root = tk.Tk()
    root.withdraw()  # Hide the main window

    file_path = filedialog.askopenfilename(initialdir=start_path, title="Select a video file")

    return file_path


# Get the user's home directory
home_dir = os.path.expanduser("~")
# Define the start path
start_path = os.path.join(home_dir, 'OneDrive', 'Whiskertracking', 'Videos')
# Prompt the user to select a folder
start_path = filedialog.askdirectory(initialdir=start_path, title='Select Folder')

# Access file names in the selected folder
if start_path:
    file_names = os.listdir(start_path)
    #print(file_names)
else:
    print("No folder selected.")

# Get the path to the pickle file
pickle_files = [file_name for file_name in file_names if file_name.endswith('.pickle')]

if len(pickle_files) == 1:
    pickle_file_path = os.path.join(start_path, pickle_files[0])

    # Load the pickle file
    with open(pickle_file_path, 'rb') as f:
        data = pickle.load(f)
        print(data)  # Print the loaded data as needed
else: # if more pickle files are in directory choose individually
    pickle_file_path = choose_file(start_path)
    # Load the pickle file
    with open(pickle_file_path, 'rb') as f:
        data = pickle.load(f)
        print(data)  # Print the loaded data as needed
    