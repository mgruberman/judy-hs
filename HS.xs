#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
/* #include "ppport.h" Removed at the suggestion of ppport.h */
#include "Judy.h"

MODULE = Judy::HS PACKAGE = Judy::HS PREFIX = ljhs_

PROTOTYPES: DISABLE

void
ljhs_JHSI( PValue_arg, PJHSArray_arg, Index, Length )
        Word_t PValue_arg
        Pvoid_t PJHSArray_arg
        char * Index
        Word_t Length
    PROTOTYPE: $$$$
    CODE:
        /* Map non-lvalue input to lvalues */
        Word_t PValue_val = PValue_arg;
        Word_t *PValue = &PValue_val;
        Pvoid_t PJHSArray = (Pvoid_t)PJHSArray_arg;

        JHSI(PValue,PJHSArray,Index,Length);

        /* Copy lvalue output */
        PValue_arg = PValue_val;
        PJHSArray_arg = PJHSArray;
    OUTPUT:
        PValue_arg
        PJHSArray_arg

void
ljhs_JHSD( RC_int, PJHSArray_arg, Index, Length )
        int RC_int
        Pvoid_t PJHSArray_arg
        char * Index
        Word_t Length
    CODE:
        /* Map non-lvalue input to lvalues */
        Pvoid_t PJHSArray = (Pvoid_t)PJHSArray_arg;

        JHSD(RC_int,PJHSArray,Index,Length);

        /* Copy lvalue output */
        PJHSArray_arg = PJHSArray;
    OUTPUT:
        RC_int
        PJHSArray_arg

void
ljhs_JHSG( PValue_arg, PJHSArray_arg, Index, Length )
        Word_t PValue_arg
        Pvoid_t PJHSArray_arg
        char * Index
        Word_t Length
    CODE:
        /* Map non-lvalue input to lvalues */
        Word_t PValue_val = PValue_arg;
        Word_t *PValue = &PValue_val;
        Pvoid_t PJHSArray = (Pvoid_t)PJHSArray_arg;

        JHSG(PValue,PJHSArray,Index,Length);

        /* Copy lvalue output */
        PValue_arg = PValue_val;
        PJHSArray_arg = PJHSArray;
    OUTPUT:
        PValue_arg
        PJHSArray_arg

void
ljhs_JHSFA( RC_word, PJHSArray_arg )
        Word_t RC_word
        Pvoid_t PJHSArray_arg
    CODE:
        /* Map non-lvalue input to lvalues */
        Pvoid_t PJHSArray = (Pvoid_t)PJHSArray_arg;

        JHSFA(RC_word,PJHSArray);

        /* Copy lvalue output */
        PJHSArray_arg = PJHSArray;
    OUTPUT:
        RC_word
        PJHSArray_arg
