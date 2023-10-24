ARRAY( INT: PALETTE 0 )         /* Variable array for palette */

/* --- Word that draws a lot of lines on the screen --- */

: DRAW
VAR( X Y C )

0 >> C                   /* Initial value of C */
0 >> Y                   /* Initial value of Y */
WHILE( Y 212 < ){        /* Repeat for Y<212 */
    0 >> _DX 0 >> _DY    /* Drawing start point */
    256 >> _NX Y >> _NY  /* Length to draw X and Y */
    C 8 + >> _COL        /* Color is C+8, i.e. 8 to 15*/
    0 >> _LOG            /* Logical operation = PSET */
    LINE                 /* Draw a line */
    
    C 1 + 7 AND >> C     /* Add 1 to C and AND with 7 */
    Y 2 + >> Y           /* Add 2 to Y */
}

254 >> X                 /* Initial value of X */
WHILE( X 0 >= ){         /* Repeat for X>=0 */
    0 >> _DX 0 >> _DY    /* Drawing start point */
    X >> _NX 212 >> _NY  /* Length to draw X and Y */
    C 8 + >> _COL        /* Color is C+8, i.e. 8 to 15*/
    0 >> _LOG            /* Logical operation = PSET */
    LINE                 /* Draw a line */
    
    C 1 + 7 AND >> C     /* Add 1 to C and AND with 7 */
    X 2 - >> X           /* Subtract 2 from X */
} ;

/* --- Main word --- */

: MAIN
VAR( I P )

5 >> _A $5F BIOS           /* Set to screen 5 */

DATA( INT:
    0 0 0 0 0 0 0 0        /* Palettes 0 to 7 */
    $700 $701 $602 $503    /* Pallets No. 8 to 11 */
    $404 $305 $206 $107    /* Pallets No. 12 to 15 */
) ARRAY>> PALETTE          /* Make this a variable array as is */

& PALETTE SETPAL           /* Palette settings */
DRAW                       /* Drawing */

{
    PALETTE [ 8 ] >> P     /* Save palette number 8 to P */
    8 >> I                 /* Initial value of I 8 */
    WHILE( I 15 < ){
        PALETTE [ I 1 + ]  /* I+1 */
        >> PALETTE [ I ]   /* Move to number I */
        I 1 + >> I
    }
    P >> PALETTE [ 15 ]    /* Move pallet number 8 to number 15 */
    
    5 VSYNC                /* Kill time appropriately */
    
    & PALETTE SETPAL       /* Set new palette */
}
;
END MAIN
