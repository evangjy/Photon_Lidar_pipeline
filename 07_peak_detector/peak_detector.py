from __future__ import annotations
import argparse
import numpy as np


def find_peak(histogram):

    histogram = np.asarray(histogram)
    if histogram.ndim != 1 or histogram.size == 0:
        raise ValueError("histogram must be a non-empty 1-D array")

    peak_bin = int(np.argmax(histogram))
    peak_value = int(histogram[peak_bin])
    return peak_bin, peak_value


def main():
    parser = argparse.ArgumentParser(description="Find the maximum ToF histogram bin.")
    parser.add_argument("--bins", type=int, default=256)
    args = parser.parse_args()

    hist = np.zeros(args.bins, dtype=np.int64)
    hist[98] = 2
    hist[99] = 7
    hist[100] = 15
    hist[101] = 30
    hist[102] = 12
    hist[150] = 3

    peak_bin, peak_value = find_peak(hist)
    print(f"peak_bin   = {peak_bin}")
    print(f"peak_value = {peak_value}")


if __name__ == "__main__":
    main()
