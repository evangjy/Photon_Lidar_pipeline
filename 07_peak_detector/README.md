# 07 Peak Detector — Histogram 峰值搜索（Python）

## 1. 模块作用

`07 Peak Detector` 从 ToF Histogram 中寻找 photon count 最大的 bin：

```text
Histogram
   ↓
argmax
   ↓
peak_bin + peak_value
```

`peak_bin` 表示目标回波对应的时间位置。

## 2. 为什么这里使用 Python

Peak Detection 属于 Histogram 之后的数据处理算法。

第一版先在 PC/Python 中实现，方便后续继续加入：

- background subtraction
- threshold
- moving average
- CFAR
- multi-peak detection
- peak interpolation

而不把算法为了“FPGA 化”而强行改成 RTL。

## 3. 输入

```python
histogram
```

例如：

```text
bin 98  → 2
bin 99  → 7
bin 100 → 15
bin 101 → 30
bin 102 → 12
```

## 4. 输出

```python
peak_bin
peak_value
```

上面的例子：

```text
peak_bin   = 101
peak_value = 30
```

## 5. `peak_detector.py`

### `find_peak(histogram)`

核心：

```python
peak_bin = int(np.argmax(histogram))
peak_value = int(histogram[peak_bin])
```

`np.argmax()` 返回最大值第一次出现的位置。

因此如果多个 bin count 相同，会选择最靠前的 bin。

## 6. 为什么 Peak 对应目标

经过大量激光发射后：

```text
background → 分散在很多时间 bin
target     → 大量 photon 集中在某个 ToF 附近
```

所以 Histogram 通常会出现一个明显峰值。

注意：**最大值不一定永远等于真实目标**。强背景、多目标、pile-up、死时间等情况下需要更高级的检测算法。

## 7. 运行

```bash
python 07_peak_detector/peak_detector.py
```

## 8. 与前后模块

```text
06 Histogram (Python)
        ↓
   histogram
        ↓
07 Peak Detector (Python)
        ↓
peak_bin
        ↓
08 Distance Calculator (Python)
```

