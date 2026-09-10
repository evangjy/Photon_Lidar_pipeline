from __future__ import annotations
import argparse
import numpy as np


def build_histogram(timestamps, num_bins=256):

    timestamps = np.asarray(timestamps, dtype=np.int64)
    if np.any((timestamps < 0) | (timestamps >= num_bins)):
        raise ValueError("timestamp is outside [0, num_bins-1]")

    histogram = np.zeros(num_bins, dtype=np.int64)
    np.add.at(histogram, timestamps, 1)
    return histogram


def main():
    parser = argparse.ArgumentParser(description="Build a ToF photon histogram.")  // 建立命令行参数解析器
    parser.add_argument("--bins", type=int, default=256)
    args = parser.parse_args()  // 读取用户在命令行输入的参数

    timestamps = [100, 101, 100, 100, 102, 100]
    hist = build_histogram(timestamps, args.bins)

    print("Non-zero histogram bins:")
    for i, count in enumerate(hist):
        if count:
            print(f"bin[{i}] = {count}")


if __name__ == "__main__":
    main()
