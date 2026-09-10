# 06 Histogram — ToF 光子直方图（Python）

## 1. 模块作用

`06 Histogram` 是**软件侧数据处理模块**。

它接收前面 TDC 得到的一批 photon timestamp，把相同时间 bin 的 photon 数量累积起来：

```text
timestamp = 100 → histogram[100] += 1
timestamp = 101 → histogram[101] += 1
timestamp = 100 → histogram[100] += 1
```

最终得到：

```text
Histogram[100] = 2
Histogram[101] = 1
```

重复大量激光周期后，真实目标回波会在某个 ToF 附近形成统计峰。

## 2. 为什么这里使用 Python

前面的 Synchronizer、Edge Detector、Coarse TDC、Time Gate 属于 FPGA 上的实时确定性数字处理。

Histogram 在本项目的第一版中作为**PC/离线数据处理模块**实现，用于先验证算法和数据流，而不是把软件算法强行做成 RTL。

后续如果需要高吞吐量，也可以再单独设计 FPGA BRAM Histogram。

## 3. 输入

```python
timestamps
```

一维 photon timestamp 数组。

例如：

```text
[100, 101, 100, 100, 102, 100]
```

这里的 timestamp 是已经经过 TDC 得到的时间 bin。

## 4. 输出

```python
histogram
```

长度为 `num_bins` 的数组。

对于：

```text
[100, 101, 100, 100, 102, 100]
```

得到：

```text
histogram[100] = 4
histogram[101] = 1
histogram[102] = 1
```

## 5. `histogram.py`

### `build_histogram(timestamps, num_bins)`

核心函数：

```python
histogram = np.zeros(num_bins, dtype=np.int64)
np.add.at(histogram, timestamps, 1)
```

第一行创建全部为 0 的 histogram。

第二行按照 timestamp 对应的 bin 累加 photon count。

`np.add.at()` 能正确处理多个 photon 落在同一个 bin 的情况。

### 输入检查

```python
if np.any((timestamps < 0) | (timestamps >= num_bins)):
    raise ValueError(...)
```

防止 timestamp 超出 Histogram 地址范围。

## 6. 与 LiDAR 的关系

最终数据类似：

```text
Photon count
   │
   │                    █
   │                  ████
   │                ███████
   │________________████████________ ToF
                         ↑
                      target
```

峰的位置就是后续 Peak Detector 要寻找的位置。



