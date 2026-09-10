# 01 Synchronizer — 异步 SPAD 信号同步

## 作用
把与 FPGA `clk` 异步的 `async_in` 转换成同步的 `sync_out`。

```text
async_in → FF1 → FF2 → sync_out
```

## testbench
`tb_synchronizer.v` 人为改变 `async_in`，观察 `sync_out` 的同步延迟。

运行：

```bash
iverilog -o sim tb_synchronizer.v synchronizer.v
vvp sim
```

注意：Synchronizer 解决的是时钟域问题，不负责测量 photon 到达时间。
