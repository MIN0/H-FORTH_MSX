4096 CONST>> BUFSIZE    /* Buffer size = 4096 bytes */
$5C CONST>> &FCB        /* FCB prepared by DOS */

ARRAY( BYTE: BUFFER 0 ) /* Take buffer as variable array */

/* --- Word to display N characters from the beginning of the buffer --- */

: NCHPUT PARAM( N )     /* Parameter is N */
VAR( I )                /* Local variable */

0 >> I                  /* The initial value of I is 0 (start of the buffer) */
WHILE( I N < ){         /* Repeat for I<N */
    BUFFER [ I ] CHPUT  /* Output I-th BUFFER */
    I 1 + >> I          /* Add 1 to I */
} ;

/* --- Main word --- */

: MAIN

_FREE BUFSIZE ARRAY>> BUFFER  /* Specify variable array address and size */

0 ( &FCB 12 + ) !        /* Reset current block */
&FCB >> _DE $0F BDOS     /* File open */
_A IF{                   /* Fail if A is not 0 */
    "FILE NOT FOUND" ERROR  /* Display error and exit */
}
1 ( &FCB 14 + ) !        /* Record size = 1 byte */
0 ( &FCB 33 + ) ! 0 ( &FCB 35 + ) !  /* Record position = 0 */

{        /* start of loop */
    & BUFFER >> _DE $1A BDOS    /* Set DTA to the beginning of BUFFER */

    &FCB >> _DE BUFSIZE >> _HL
    $27 BDOS                    /* Read 1 block */
    
   _A IF{                       /* If A is not 0 */
        _HL NCHPUT              /* HL = Output only the valid number of characters */
        BREAK                   /* Break out of the loop */

    }{                          /* If A is 0 */
        BUFSIZE NCHPUT          /* Print all characters in buffer */
    }
}                               /* repeat */
;
END MAIN
