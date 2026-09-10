from __future__ import annotations
import argparse

SPEED_OF_LIGHT = 299_792_458.0  # m/s


def tof_to_distance(tof_ns, speed_of_light=SPEED_OF_LIGHT):
    return speed_of_light * (tof_ns * 1e-9) / 2.0


def bin_to_distance(peak_bin, bin_width_ns, speed_of_light=SPEED_OF_LIGHT):
    tof_ns = peak_bin * bin_width_ns
    return tof_to_distance(tof_ns, speed_of_light)


def main():
    parser = argparse.ArgumentParser(description="Convert ToF to distance.")
    parser.add_argument("--tof-ns", type=float, default=100.0)
    args = parser.parse_args()

    distance_m = tof_to_distance(args.tof_ns)
    print(f"ToF      = {args.tof_ns:.3f} ns")
    print(f"Distance = {distance_m:.3f} m")


if __name__ == "__main__":
    main()
