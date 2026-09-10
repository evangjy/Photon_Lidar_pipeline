# 10 Extensions — 后续工程扩展

```text
SPAD
 ↓
Synchronizer        [Verilog / FPGA]
 ↓
Edge Detector       [Verilog / FPGA]
 ↓
Coarse TDC          [Verilog / FPGA]
 ↓
Time Gate           [Verilog / FPGA]
 ↓
Photon Counter      [Verilog / FPGA]
 ↓
Timestamp data
 ↓
Histogram           [Python / PC]
 ↓
Peak Detection      [Python / PC]
 ↓
Distance            [Python / PC]
```

之后增加以下内容。

## 1. Start-Stop TDC

更接近真实 LiDAR：

```text
Laser trigger → START
                    ↓
                  wait
                    ↓
SPAD return   → STOP
```

然后：

```text
TOF = STOP - START
```

## 2. Fine TDC

当前 coarse TDC：

```text
50 MHz → 20 ns/tick
```

太粗。

可以进一步使用：

```text
Coarse Counter + Fine Time
```

例如 FPGA carry-chain delay line、Vernier、校准等。

## 3. Background Processing

实际 Histogram：

```text
signal + background
```

可先在 Python/MATLAB 中开发：

```text
background estimate
→ subtraction
→ filtering
→ peak detection
```

## 4. CFAR

当背景强度变化时，用局部统计估计检测阈值。

## 5. Multi-peak

多个目标可能产生多个峰，需要从 `argmax` 扩展到多个局部峰检测。

## 6. Multi-SPAD / Multi-TDC

真实系统可以：

```text
SPAD array
 ↓
multiple channels
 ↓
multiple TDC
 ↓
histogram
```

提高吞吐量。

## 7. FPGA + PC

一个很实际的最终结构：

```text
SPAD
 ↓
FPGA TDC
 ↓
FPGA Histogram
 ↓
USB/UART/Ethernet
 ↓
PC Python/C++
 ↓
Signal Processing
 ↓
Peak Detection
 ↓
Distance / Point Cloud
```

FPGA 做实时、确定性的高速处理；PC 做复杂算法和可视化。
