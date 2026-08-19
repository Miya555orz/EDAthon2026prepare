# T1 Prompt 中文对照

你正在解决一个 EDAthon RTL 代码补全 case。

阅读题目描述，并检查 `rtl/`、`verif/` 和 `harness/`。
只允许修改 `rtl/` 下的文件。不要修改 `verif/`、`harness/`、题目文件、metadata 或脚本。

唯一成功标准是：

```bash
bash harness/check.sh
```

反复运行 `bash harness/check.sh`，阅读编译/仿真/lint 错误，只修 RTL。
保持 testbench 期望的 module 接口。
不要硬编码可见测试样例。
只有当 `bash harness/check.sh` 退出码为 0 时才停止。

最后报告：修改了哪些文件、实现思路、运行的命令、最终退出码、还有哪些歧义。
