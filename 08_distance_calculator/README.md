# 08 Distance Calculator — ToF → Distance（Python）

## 1. 模块作用

把 Peak Detector 得到的 ToF 位置转换为目标距离。

基本公式：

```text
d = c × ToF / 2
```

其中：

```text
c = 299792458 m/s
```

## 2. 为什么这里使用 Python

这是典型的**数据后处理计算**。

第一版直接用 Python 浮点数实现，重点是验证：

```text
Histogram peak
        ↓
ToF
        ↓
Distance
```

如果以后需要把距离计算放到 FPGA，可以再单独设计 fixed-point / DSP 版本。

## 3. `tof_to_distance()`

```python
def tof_to_distance(tof_ns):
    return SPEED_OF_LIGHT * (tof_ns * 1e-9) / 2.0
```

输入单位：

```text
ns
```

输出单位：

```text
m
```

因为：

```text
1 ns = 1e-9 s
```

## 4. 为什么除以 2

LiDAR 测量的是：

```text
Laser → Target → Receiver
```

所以 ToF 对应的是往返距离：

```text
2d = c × ToF
```

因此：

```text
d = c × ToF / 2
```

## 5. `bin_to_distance()`

如果 Histogram 每个 bin 的时间宽度已知，可以直接从 peak bin 算距离：

```python
tof_ns = peak_bin * bin_width_ns
distance = tof_to_distance(tof_ns)
```

例如：

```text
peak_bin = 100
bin_width = 1 ns
```

则：

```text
ToF = 100 ns
Distance ≈ 14.99 m
```

## 6. 运行

```bash
python 08_distance_calculator/distance_calculator.py
```

## 7. 与前面模块

完整软件后处理链：

```text
TDC timestamp
      ↓
06 Histogram
      ↓
07 Peak Detector
      ↓
peak_bin
      ↓
08 Distance Calculator
      ↓
Distance (m)
```

