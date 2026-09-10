# 05 Photon Counter — 光子计数

## 作用
统计一个测量周期内有多少个有效 photon event。

## `photon_counter.v`

```verilog
module photon_counter #(
    parameter integer WIDTH=32
)(
    input wire clk,
    input wire rst_n,
    input wire clear,
    input wire event_valid,
    output reg [WIDTH-1:0] count
);
```

- `clk`：系统时钟。
- `rst_n`：低有效复位。
- `clear`：开始新的统计周期时清零。
- `event_valid`：有效 photon。
- `count`：累计数量。

### Reset

```verilog
if(!rst_n)
    count <= 0;
```

### Clear

```verilog
else if(clear)
    count <= 0;
```

### Count

```verilog
else if(event_valid)
    count <= count + 1'b1;
```

每个有效 event 计数加 1。

## 和 Histogram 的区别

Photon Counter：

```text
event event event → count = 3
```

只知道总数量。

Histogram：

```text
event@100
event@101
event@100
```

得到：

```text
bin100 = 2
bin101 = 1
```

Histogram 才保留了时间信息，因此距离恢复主要依赖 Histogram。
