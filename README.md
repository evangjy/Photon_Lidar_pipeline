# Photon-counting LiDAR FPGA Pipeline

本工程从 **SPAD 已经输出数字脉冲** 开始，把“SPAD → 时间测量 → Histogram → 距离”的数字处理链拆成一组可以独立运行、
独立仿真、最后再组合起来的教学工程。

## 主线

SPAD pulse
  ↓
01 Synchronizer
  ↓
02 Edge Detector
  ↓
03 Coarse TDC
  ↓
04 Time Gate
  ↓
05 Photon Counter
  ↓
06 ToF Histogram
  ↓
07 Peak Detector
  ↓
08 Distance Calculator

09 Integrated Demo 会把主线串起来。

## 每个模块的定位

01_synchronizer
    处理异步 SPAD pulse 与 FPGA clk 的时钟域问题。

02_edge_detector
    把同步后的 pulse 变成一个 clock 宽度的 event。

03_coarse_tdc
    用 free-running counter 给 photon event 打时间戳。
    这是教学版 coarse TDC，不是 ps 级真实 FPGA TDC。

04_time_gate
    只接受指定 ToF 时间窗口内的事件。

05_photon_counter
    统计当前测量窗口内总共来了多少 photon event。

06_histogram
    histogram[timestamp]++，把很多次 photon event 变成 ToF 直方图。

07_peak_detector
    找 histogram 最大峰，对应主要目标回波时间。

08_distance_calculator
    d = c * ToF / 2。

09_integrated_demo
    用一个简单的仿真事件流展示完整链路。

## 刻意不放入第一版

- AFE / ADC
- 模拟 SPAD avalanche/quenching 模型
- ps 级 Fine TDC / Carry-chain TDC
- TDC calibration
- CFAR
- 多 SPAD / 多 TDC
- 多目标跟踪
- UART / Ethernet / GPU

这些都是后续可以继续扩展的独立工程；第一版优先保证主线清楚。


