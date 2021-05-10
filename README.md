# 低レベルプログラミング

## gdbチートシート

```shell
# アセンブラのリアルタイム表示
(gdb) lay asm

# ブレークポイントを貼る
(gdb) b _start

# 実行開始
(gdb) r

# ステップイン
(gdb) si

# 汎用レジスタの表示
(gdb) p $rax

# フラグレジスタの表示
(gdb) p $eflags

# 指定したレジスタを常時表示
(gdb) disp $rax
```
