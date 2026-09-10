# 09 Integrated Demo — 完整链路演示

## 作用
把前面模块的核心思想放在一个简化 demo 中：

```text
SPAD event
 ↓
TDC
 ↓
timestamp
 ↓
Histogram
 ↓
Peak
 ↓
Distance
```

## `lidar_pipeline_demo.v`

输入：

```verilog
event_in
```

表示 photon event。

内部：

```verilog
reg [31:0] counter;
```

每个 clock：

```verilog
counter <= counter + 1'b1;
```

event 到来：

```verilog
timestamp <= counter;
timestamp_valid <= event_in;
```

所以本质是：

```text
counter + event
       ↓
timestamp
```

## testbench

`tb_lidar_pipeline_demo.v` 构造了一批 synthetic photon arrival：

```text
20
45
97
98
99
100
100
100
100
101
102
150
```

100 附近 photon 密度最高，用来模拟目标回波。

随后 testbench 构造对应 Histogram，并扫描：

```verilog
if(hist[k] > peak_value)
```

找到最大峰。

最后根据：

```text
peak_bin × 20 ns × c / 2
```

计算距离。

## 为什么这里不是严格的模块级连接

这是一个“概念演示”，不是最终 RTL 系统。

真正工程应该把：

```text
synchronizer
→ edge detector
→ TDC
→ gate
→ histogram
→ peak detector
```

通过实际端口连接起来。

## 运行

```bash
iverilog -o sim tb_lidar_pipeline_demo.v lidar_pipeline_demo.v
vvp sim
```
