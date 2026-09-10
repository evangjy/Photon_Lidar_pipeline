# 04 Time Gate — 时间门控

## 作用
只接受指定 ToF/time-bin 范围内的 photon。

例如：

```text
START_BIN = 80
END_BIN   = 160
```

则：

```text
50  → reject
80  → accept
100 → accept
160 → accept
200 → reject
```

## `time_gate.v`

```verilog
module time_gate #(
    parameter integer WIDTH=32,
    parameter integer START_BIN=80,
    parameter integer END_BIN=160
)(
    input  wire [WIDTH-1:0] timestamp,
    input  wire timestamp_valid,
    output wire event_valid
);
```

- `timestamp`：TDC 输出的时间。
- `timestamp_valid`：表示这是新 timestamp。
- `START_BIN/END_BIN`：门控窗口。
- `event_valid`：最终允许进入后级的 event。

核心：

```verilog
assign event_valid = timestamp_valid &&
                     (timestamp >= START_BIN) &&
                     (timestamp <= END_BIN);
```

三个条件同时成立才放行。

## 为什么不是只比较 timestamp
因为 timestamp 没有新 event 时会保持旧值，所以必须结合 `timestamp_valid`。

## 代码特点
这是组合逻辑，没有 `always`，使用 `assign` 直接描述输出关系。
