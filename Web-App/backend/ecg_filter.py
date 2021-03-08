import sys
import json
import numpy as np
from scipy import signal
import time

def butter_highpass_filter(data, cutoff, fs, order=5):
    nyq = 0.5 * fs
    normal_cutoff = cutoff / nyq
    b, a = signal.butter(order, normal_cutoff, btype='high', analog=False)
    filt_data = signal.filtfilt(b, a, data)
    return filt_data

def notch_filter(data, notch_freq, fs):
    Fnotch = 60; # Notch Frequency
    Q = 25; # Q factor
    [b, a] = signal.iirnotch (notch_freq, Q, fs);
    filt_data = signal.filtfilt(b, a, data);
    return filt_data

def filter_ECG(data, Fs):
    filtered_data = butter_highpass_filter(data, 0.5, Fs, 5)
    filtered_data = notch_filter(filtered_data, 60, Fs);
    return filtered_data

Fs = 300
np.set_printoptions(threshold=sys.maxsize) #prevent np array truncated print

lines = sys.stdin.readlines()
loaded = json.loads(lines[0])
filtered_data = filter_ECG(loaded, Fs)
filtered_data = np.around(filtered_data, decimals=2)
filtered_data = filtered_data * (3.3/4096)

# comma_delimited_data = [str(el) for el in filtered_data]
# comma_delimited_data = "[" + ",".join(comma_delimited_data) + "]"
comma_delimited_data = "[" + ",".join(map(str, filtered_data)) + "]"


# print(comma_delimited_data[0:8000])
# print(comma_delimited_data[7985:8020])
# print(comma_delimited_data[8001:16000])
print(comma_delimited_data)

# print(json.dumps('data'))
