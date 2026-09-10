# 02 Edge Detector — Photon Event 提取

## 作用
把同步后的电平信号转换成一个 clock 周期的上升沿事件。

例如：

```text
signal_in: 000011111000
event:     000010000000
```

## `edge_detector.v` 代码说明

```verilog
reg signal_d;
```

`signal_d` 保存上一 clock 的 `signal_in`。

```verilog
event <= signal_in & ~signal_d;
```

只有当前为 1、上一拍为 0 时成立：

```text
0 → 1
```

因此检测的是上升沿。

```verilog
signal_d <= signal_in;
```

把当前输入保存下来，下一拍作为“上一状态”。

复位：

```verilog
if (!rst_n) begin
    signal_d <= 1'b0;
    event    <= 1'b0;
end
```

## 为什么需要
SPAD/readout 信号可能持续多个 clock，但后级 TDC/计数器通常需要明确的“一个事件”。

```text
同步信号
   ↓
Edge Detector
   ↓
one-clock photon event
```

## testbench
`tb_edge_detector.v` 制造多个 HIGH/LOW 序列，验证每个上升沿只产生一次 `event`。
