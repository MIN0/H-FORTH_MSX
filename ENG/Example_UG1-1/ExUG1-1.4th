ARRAY( BYTE: MARK 1001 ) /* Marking array */

/* --- Definition of word to erase marks of multiples of N --- */

: UNMARK PARAM( N )   /* Word name is UNMARK, parameter is N */
VAR( I )           /* Local variable I only valid in UNMARK */

N 2 * >> I         /* The initial value of I is N*2 */
WHILE( I 1000 <= ){      /* Repeat for I<=1000 */
    FALSE >> MARK [ I ]  /* Set mark I to FALSE (0) */
    I N + >> I           /* Add N to I */
}                  /* Loop ends here */
;                  /* End of definition of word UNMARK */


/* --- Main word definition --- */

: MAIN            /* Word name is MAIN, no parameters */
VAR( I )          /* Local variable I only valid in MAIN */

"\nFind prime numbers from 1 to 1000!!\n" STR. /* Display message */

1 >> I
WHILE( I 1000 <= ){        /* from 1 to 1000, */
    TRUE >> MARK [ I ]     /* Set all MARK to TRUE (1) */
    I 1 + >> I
}

2 >> I
WHILE( I 1000 <= ){        /* From 2 to 1000, */
    I UNMARK               /* Call word UNMARK */
    I 1 + >> I
}

1 >> I
WHILE( I 1000 <= ){        /* from 1 to 1000 */
    MARK [ I ] IF{ I . }   /* Display I if MARK is not 0 */
    I 1 + >> I
}
"\nWhat's up!!" STR.       /* Display end message */
;
END MAIN /* End of source program, specify main word */
