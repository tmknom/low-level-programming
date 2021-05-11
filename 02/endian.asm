; 別モジュールからアクセスできる外部ラベル
global _start

; 命令セクション
section .text

; _startはプログラムのエントリポイントになる
; ldコマンドはデフォルトで_startを使用する
; _startがない場合、「0000000000401000をエントリポイントとみなす」という警告が出る
; ld: warning: cannot find entry symbol _start; defaulting to 0000000000401000
_start:
    mov rdi, [demo1] ; 1つ目の引数（rdi）に16進数で標準出力したい値を入れる
    call print_hex
    call print_newline

    mov rdi, [demo2] ; 1つ目の引数（rdi）に16進数で標準出力したい値を入れる
    call print_hex
    call print_newline

    call exit

exit:
    ; exitシステムコールを実行し、exit codeを0としてプログラムを終了する
    ; rdiにゼロをセットするためにxorを使用しているのは、バイナリサイズを小さくするためである
    ; xorオペランドは1バイトなのに対し、movオペランドは9バイトである
    ; これは非常によく使われる一般的な最適化手法である
	mov     rax, 60  ; システムコールの番号をraxに入れる（exit＝0）
    xor     rdi, rdi ; 1つ目の引数（rdi）にexit codeを入れる／xorで自身を指定すると「0」になる
    syscall          ; システムコールの実行

print_newline:
    ; writeシステムコールを実行し、標準出力に改行コードを書く
    mov     rax, 1            ; システムコールの番号をraxに入れる（write＝1）
    mov     rdi, 1            ; 1つ目の引数（rdi）にstdoutのファイルディスクリプタを入れる
    mov     rsi, newline_char ; 2つ目の引数（rsi）に出力文字列が定義されているアドレスを入れる
    mov     rdx, 1            ; 3つ目の引数（rdx）に出力文字列のバイトサイズを入れる
    syscall                   ; システムコールの実行
    ret                       ; 関数をリターン

print_hex:
    mov rax, rdi ; 1つ目の引数（rdi）をraxに入れる
    mov rdi, 1   ; ファイルディスクリプタ1(=stdout)／writeシステムコールの第1引数として使用
    mov rdx, 1   ; 出力文字列のバイトサイズ／writeシステムコールの第3引数として使用
    mov rcx, 64  ; 入力値を右シフトするビット数

; ドットで始まるラベルはローカルラベル
.loop:
    ; print_hexの入力値をスタックに退避しておく
    push rax

    ; ループのたびに処理対象の桁を移動
    sub rcx, 4 ; rcxから4バイト（16進数の一桁分のバイト数）を減算

    ; raxに16進数の1バイトを入れる
    ; 上位ビットから下位ビットに向けて処理を進める
    sar rax, cl  ; raxを符号ビットを維持して右シフト／最上位ビットは元のbitをコピー／clはrcxの最下位バイト
    and rax, 0xf ; 00...01111で論理和を取る／下位4ビットのみ取得し、16進の一桁ぶんをraxに入れる

    ; writeシステムコールの第2引数として使用
    lea rsi, [codes + rax] ; rsiに16進表記文字のアドレスを格納

    ; writeシステムコールを実行し、標準出力に文字列を書く
    ; 第1引数（rdi）と第3引数（rdx）はループの外で定義
    mov rax, 1 ; システムコールの番号をraxに入れる（write＝1）
    push rcx   ; syscallでrcx（とr11）が変更されるのでスタックに退避
    syscall    ; システムコールの実行
    pop rcx    ; 退避したrcxをスタックから取り出す

    ; スタックに退避した入力値を復活させる
    pop rax

    ; rcxをチェックし、まだゼロでなければループを続行する
    ; rcxはループの冒頭で4バイト減算している
    test rcx, rcx ; rcxがゼロかどうかチェックする
    jnz .loop     ; rcxがゼロ以外なら.loopラベルにジャンプ

    ; print_hexのリターン
    ret


; グローバル変数セクション
section .data

; codesラベルに16進数で使用する文字列をバイトデータとして定義
; dbはバイトデータの作成を意味する
codes: db '0123456789ABCDEF'

; newline_charラベルに改行コードLFを10進数で定義
newline_char: db 10

; エンディアンの違いを見るための値
demo1: dq 0x1122334455667788
demo2: db 0x11, 0x22, 0x33, 0x44, 0x55, 0x66, 0x77, 0x88
