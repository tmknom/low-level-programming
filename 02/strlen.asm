; 別モジュールからアクセスできる外部ラベル
global _start

; 命令セクション
section .text

; _startはプログラムのエントリポイントになる
; ldコマンドはデフォルトで_startを使用する
; _startがない場合、「0000000000401000をエントリポイントとみなす」という警告が出る
; ld: warning: cannot find entry symbol _start; defaulting to 0000000000401000
_start:
    mov rdi, test_string ; 1つ目の引数（rdi）にstrlenに渡す文字列のアドレスを渡す

    call strlen  ; strlen関数を実行
    mov rdi, rax ; exitシステエムコールの1つ目の引数（rdi）にstrlen関数の実行結果を入れる

	mov     rax, 60  ; システムコールの番号をraxに入れる（exit＝0）
    syscall          ; システムコールの実行

strlen:
    xor rax, rax ; 返り値をゼロで初期化しておく

; 文字列の長さ分だけ繰り返す
.loop:
    ; 現在の文字がヌル文字か調べる
    ; rdiはstrlenの第1引数
    ; raxはインデックス兼文字列長
    ; byte就職が必要なのは、2つのオペランドサイズを一致させるため（ヌル文字は1バイトである）
    cmp byte [rdi+rax], 0

    ; ヌル文字を見つけたらループを抜ける
    je .end

    ; ヌル文字でなければraxをインクリメントして、次の文字を検査できるようにする
    inc rax

    ; ループの先頭に無条件ジャンプ
    jmp .loop

; strlen関数の終了
.end:
    ret

; グローバル変数セクション
section .data

; test_stringラベルにstrlenに渡す文字列をバイトデータとして定義
test_string: db 'abcdef', 0
