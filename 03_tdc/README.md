# 03 Coarse TDC — 粗粒度时间戳

## 作用
把 photon event 转换为数字时间戳：

```text
event → timestamp
```

## `coarse_tdc.v`

```verilog
module coarse_tdc #(
    parameter integer WIDTH = 32
)(
    input  wire clk,
    input  wire rst_n,
    input  wire event_in,
    output reg timestamp_valid,
    output reg [WIDTH-1:0] timestamp
);
```

- `WIDTH`：时间计数器/时间戳位宽。
- `event_in`：一个 photon event。
- `timestamp`：event 对应的 counter 值。
- `timestamp_valid`：表示 timestamp 当前是新产生的有效数据。

### Counter

```verilog
reg [WIDTH-1:0] counter;
```

每个 clock：

```verilog
counter <= counter + 1'b1;
```

因此 counter 就是一条离散时间轴：

```text
0 1 2 3 4 5 6 ...
```

### 捕获事件

```verilog
if (event_in) begin
    timestamp       <= counter;
    timestamp_valid <= 1'b1;
end
```

例如：

```text
counter = 153
event_in = 1
```

则：

```text
timestamp = 153
timestamp_valid = 1
```

### 为什么必须有 `timestamp_valid`

`timestamp` 是寄存器，没有新 event 时仍保持旧值。

所以：

```text
timestamp = 数据
timestamp_valid = 数据是否刚刚更新
```

后级必须使用 `timestamp_valid` 防止重复消费旧 timestamp。

## 现实中的 LiDAR
真正 start-stop TDC 更常见：

```text
Laser START → ... → SPAD STOP
TOF = STOP - START
```

当前模块只是教学用 absolute timestamp/coarse TDC。

## 50 MHz 限制
50 MHz：

```text
1 tick = 20 ns
```

对应距离量化：

```text
Δd = c × 20 ns / 2 ≈ 3 m
```

所以它不是 ps 级真实 TDC。
