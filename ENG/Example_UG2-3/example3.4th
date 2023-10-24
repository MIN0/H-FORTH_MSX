VAR( XRLTOP )
ARRAY( BYTE: FCB 37 )

/* --- Word to load XRL --- */

: LOADXRL
VAR( FILESIZE NEWFREE )
"PSG.XRL" & FCB CNVFCB   /* Set name to FCB */
DROP                     /* Discard the conversion result as it is not needed */

0 ( & FCB 12 + ) !       /* Reset current block */
& FCB >> _DE $0F BDOS    /* File open */
_A IF{                   /* Fail if A is not 0 */
    "FILE NOT FOUND" ERROR  /* Display error and exit */
}

( & FCB 16 + @ ) >> FILESIZE  /* Lower 2 bytes of file size */

( & FCB 18 + @ ) 0 <>    /* Is the upper file size not 0? */
FILESIZE ( _ENDFREE _FREE - ) _>  /* If the bottom is larger than the free area */
OR IF{
    "FILE TOO LARGE" ERROR  /* Display error and exit */
}

1 ( & FCB 14 + ) !          /* Record size = 1 byte */
0 ( & FCB 33 + ) ! 0 ( & FCB 35 + ) !  /* Record position = 0 */

_FREE >> _DE $1A BDOS      /* Set DTA to the beginning of free area */

& FCB >> _DE FILESIZE >> _HL $27 BDOS  /* Read execution */

_FREE >> XRLTOP            /* Start address of loaded XRL */

( XRLTOP 2 + ) @ XRLTOP + >> NEWFREE  /* After relocating, the relocation table is no longer needed. */

XRLTOP RELOCATE            /* Execute relocate */

NEWFREE >> _FREE           /* Reset _FREE */

/* Although it is not relevant to this example, it is recommended to reset _FREE after loading to prevent the XRL body from being destroyed by variable arrays, etc. */

;

/* --- Word that calls XRL --- */

: PSG@ PARAM( N )

N ( XRLTOP 4 + ) C!     /* Write N to REGSEL */
( XRLTOP 6 + ) CALL     /* Call RDPSG */
( XRLTOP 5 + ) C@       /* Read REGDAT */
;

: PSG! PARAM( D N )

N ( XRLTOP 4 + ) C!    /* Write N to REGSEL */
D ( XRLTOP 5 + ) C!    /* Write D to REGDAT */
( XRLTOP 9 + ) CALL    /* Call WRTPSG */
;

/* --- Main word --- */

: MAIN
VAR( I F )

LOADXRL            /* Load XRL */

$BE 7 PSG!         /* Channel 1, only square wave ON */
 12 8 PSG!         /* Channel 1, volume = 12 */

0 >> I
WHILE( I 5 < ){    /* repeat 5 times */
    100 >> F
    WHILE( F 300 < ){
        ( F 255 AND ) 0 PSG!   /* Set lower division ratio */
        ( F 256 _/ ) 1 PSG!    /* Set the upper division ratio */

        1 VSYNC    /* Wait for one vertical period (1/60 seconds) */

        F 1 + >> F
    }
    I 1 + >> I
}

  0 8 PSG!         /* Channel 1, volume = 0 */
$BF 7 PSG!         /* Stop sound on all channels */
;
END MAIN
