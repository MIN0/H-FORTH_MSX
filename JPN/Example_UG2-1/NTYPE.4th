4096 CONST>> BUFSIZE		/* バッファのサイズ＝４０９６バイト */
$5C CONST>> &FCB		/* ＤＯＳが用意しているＦＣＢ */

ARRAY( BYTE: BUFFER 0 )		/* バッファを可変配列としてとる */

/* －－－　バッファの先頭から N文字表示するワード　－－－ */

: NCHPUT  PARAM( N )		/* パラメータは N */
VAR( I )			/* ローカル変数 */

0 >> I				/* I の初期値は０（バッファの先頭） */
WHILE( I N < ){			/* I<N の間くり返し */
    BUFFER [ I ] CHPUT		/* BUFFER の I 番目を出力 */
    I 1 + >> I			/* I に１を足す */
} ;

/* －－－　メインワード　－－－ */

: MAIN

_FREE BUFSIZE ARRAY>> BUFFER		/* 可変配列の番地、サイズを指定 */

0 ( &FCB 12 + ) !			/* カレントブロックをリセット */
&FCB >> _DE $0F BDOS			/* ファイルオープン */
_A IF{					/* Ａが０でなければ失敗 */
    "FILE NOT FOUND" ERROR		/* エラー表示して終了 */
}
1 ( &FCB 14 + ) !			/* レコードサイズ＝１バイト */
0 ( &FCB 33 + ) ! 0 ( &FCB 35 + ) !	/* レコードポジション＝０ */

{					/* ループ始め */
    & BUFFER >> _DE $1A BDOS		/* ＤＴＡを BUFFER の先頭に設定 */

    &FCB >> _DE  BUFSIZE >> _HL
    $27 BDOS				/* １ブロック読み込み */

    _A IF{				/* Ａが０でない場合 */
        _HL NCHPUT			/* ＨＬ＝有効な文字数だけ出力 */
        BREAK				/* ループを抜ける */

    }{					/* Ａが０の場合 */
        BUFSIZE NCHPUT			/* バッファの文字を全部出力 */
    }
}					/* くり返し */
;
END MAIN
