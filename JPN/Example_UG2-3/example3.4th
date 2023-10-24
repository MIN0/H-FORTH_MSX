VAR( XRLTOP )
ARRAY( BYTE: FCB 37 )

/* －－－　ＸＲＬをロードするワード　－－－ */

: LOADXRL
VAR( FILESIZE NEWFREE )
"PSG.XRL" & FCB CNVFCB			/* ＦＣＢに名前を設定 */
DROP					/* 変換結果はいらないので捨てる */

0 ( & FCB 12 + ) !			/* カレントブロックをリセット */
& FCB >> _DE $0F BDOS			/* ファイルオープン */
_A IF{					/* Ａが０でなければ失敗 */
    "FILE NOT FOUND" ERROR		/* エラー表示して終了 */
}

( & FCB 16 + @ ) >> FILESIZE		/* ファイルサイズの下位２バイト */

( & FCB 18 + @ ) 0 <> 			/* ファイルサイズ上位が０でないか */
FILESIZE ( _ENDFREE _FREE - ) _>	/* 下位がフリーエリアより大きければ */
OR IF{
    "FILE TOO LARGE" ERROR		/* エラー表示して終了 */
}

1 ( & FCB 14 + ) !			/* レコードサイズ＝１バイト */
0 ( & FCB 33 + ) ! 0 ( & FCB 35 + ) !	/* レコードポジション＝０ */

_FREE >> _DE $1A BDOS			/* ＤＴＡをフリーエリアの先頭に設定 */

& FCB >> _DE  FILESIZE >> _HL  $27 BDOS	/* 読み込み実行 */

_FREE >> XRLTOP				/* ロードされたＸＲＬの先頭番地 */

( XRLTOP 2 + ) @ XRLTOP + >> NEWFREE	/* リロケート後はリロケーション */
					/* テーブルはいらなくなるので。 */

XRLTOP RELOCATE				/* リロケートを実行 */

NEWFREE >> _FREE			/* _FREE を設定しなおす */

/* 今回の例では関係ありませんが、ＸＲＬのボディが可変配列などで破壊されるの
   を防ぐため、ロード後は _FREE を設定しなおすことをお薦めします。 */

;

/* －－－　ＸＲＬを呼ぶワード　－－－ */

: PSG@  PARAM( N )

N ( XRLTOP 4 + ) C!		/* REGSEL に N を書き込む */
( XRLTOP 6 + ) CALL		/* RDPSG を呼び出す */
( XRLTOP 5 + ) C@		/* REGDAT を読みだす */
;

: PSG!  PARAM( D N )

N ( XRLTOP 4 + ) C!		/* REGSEL に N を書き込む */
D ( XRLTOP 5 + ) C!		/* REGDAT に D を書き込む */
( XRLTOP 9 + ) CALL		/* WRTPSG を呼び出す */
;

/* －－－　メインワード　－－－ */

: MAIN
VAR( I F )

LOADXRL				/* ＸＲＬをロード */

$BE 7 PSG!			/* チャネル１、矩形波のみＯＮ */
 12 8 PSG!			/* チャネル１、ボリューム＝１２ */

0 >> I
WHILE( I 5 < ){			/* ５回くり返し */
    100 >> F
    WHILE( F 300 < ){
        ( F 255 AND ) 0 PSG!	/* 分周比の下位を設定 */
        ( F 256 _/  ) 1 PSG!	/* 分周比の上位を設定 */

        1 VSYNC			/* 垂直周期を１回待つ（1/60秒） */

        F 1 + >> F
    }
    I 1 + >> I
}

  0 8 PSG!			/* チャネル１、ボリューム＝０ */
$BF 7 PSG!			/* 全チャネル発音停止 */
;
END MAIN
