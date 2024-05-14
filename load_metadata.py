import pickle
import os
from tkinter import Tk, filedialog


# Get the user's home directory
home_dir = os.path.expanduser("~")
# Define the start path
start_path = os.path.join(home_dir, 'OneDrive', 'Whiskertracking', 'Videos')
# Prompt the user to select a folder
root = Tk()
root.withdraw()  # Hide the main window
start_path = filedialog.askdirectory(initialdir=start_path, title='Select Folder')
root.destroy()  # Close the tkinter window

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
else:
    print("Error: No or multiple pickle files found in the directory.")