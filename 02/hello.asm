; 別モジュールからアクセスできる外部ラベル
global _start

; 命令セクション
section .text

; _startはプログラムのエントリポイントになる
; ldコマンドはデフォルトで_startを使用する
; _startがない場合、「0000000000401000をエントリポイントとみなす」という警告が出る
; ld: warning: cannot find entry symbol _start; defaulting to 0000000000401000
_start:
    ; writeシステムコールを実行し、標準出力に文字列を書く
    mov     rax, 1       ; システムコールの番号をraxに入れる（write＝1）
    mov     rdi, 1       ; 1つ目の引数（rdi）にstdoutのファイルディスクリプタを入れる
    mov     rsi, message ; 2つ目の引数（rsi）に出力文字列が定義されているアドレスを入れる
    mov     rdx, 14      ; 3つ目の引数（rdx）に出力文字列のバイトサイズを入れる
    syscall              ; システムコールの実行

    ; exitシステムコールを実行し、exit codeを0としてプログラムを終了する
    ; rdiにゼロをセットするためにxorを使用しているのは、バイナリサイズを小さくするためである
    ; xorオペランドは1バイトなのに対し、movオペランドは9バイトである
    ; これは非常によく使われる一般的な最適化手法である
	mov     rax, 60  ; システムコールの番号をraxに入れる（exit＝0）
    xor     rdi, rdi ; 1つ目の引数（rdi）にexit codeを入れる／xorで自身を指定すると「0」になる
    syscall          ; システムコールの実行

; グローバル変数セクション
section .data

; messageラベルに文字列をバイトデータとして定義
; dbはバイトデータの作成を意味する
; 末尾の「10」は改行コードLFを示す
message: db  'hello, world!', 10
