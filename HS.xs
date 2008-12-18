#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
/* #include "ppport.h" Removed at the suggestion of ppport.h */
#include "Judy.h"

MODULE = Judy::HS PACKAGE = Judy::HS PREFIX = ljhs_

PROTOTYPES: DISABLE

void
ljhs_JHSI( PJHSArray_arg, Index_sv, Value )
        Pvoid_t PJHSArray_arg
        SV      *Index_sv
        UV      Value
    INIT:
        Word_t  *PValue = (Word_t*)0xDEADBEEF;
        Pvoid_t PJHSArray = PJHSArray_arg;
        STRLEN  Length = 0xDEADBEEF;
        char *Index = sv_2pvbyte(Index_sv,&Length);
    PPCODE:
        //warn("&PValue=%d",&PValue);
        //warn("JHSIa Judy=%d Index=%s Length=%d",PJHSArray,Index,Length);
        JHSI(PValue,PJHSArray,Index,(Word_t)Length);
        *PValue = Value;
        //warn("JHSIb Judy=%d PValue=%d *PValue=%d Value=%d Index=%s Length=%d",PJHSArray,PValue,(PValue?(*PValue):-1),Value,Index,Length);

        /* OUTPUT */
        XPUSHs(sv_2mortal(newSVuv(INT2PTR(UV,PValue))));
        XPUSHs(sv_2mortal(newSVuv(INT2PTR(UV,PJHSArray))));

void
ljhs_JHSD( PJHSArray_arg, Index_sv )
        Pvoid_t PJHSArray_arg
        SV      *Index_sv
    INIT:
        Pvoid_t PJHSArray = (Pvoid_t)PJHSArray_arg;
        STRLEN Length = 0xDEADBEEF;
        char *Index = sv_2pvbyte(Index_sv,&Length);
        int Rc_int = 0xDEADBEEF;
    PPCODE:
        //warn("JHSDa Judy=%d Rc_int=%d",PJHSArray,Rc_int);
        JHSD(Rc_int,PJHSArray,Index,(Word_t)Length);
        //warn("JHSDb Judy=%d Rc_int=%d",PJHSArray,Rc_int);

        /* OUTPUT */
        XPUSHs(sv_2mortal(newSViv(Rc_int)));
        XPUSHs(sv_2mortal(newSVuv(INT2PTR(UV,PJHSArray))));

void
ljhs_JHSG( PJHSArray_arg, Index_sv )
        Pvoid_t PJHSArray_arg
        SV *Index_sv
    INIT:
        Word_t *PValue = (Word_t*)0xDEADBEEF;
        Pvoid_t PJHSArray = (Pvoid_t)PJHSArray_arg;
        STRLEN Length = 0xDEADBEEF;
        char *Index = sv_2pvbyte(Index_sv,&Length);
    PPCODE:
        //warn("&PValue=%d",&PValue);
        //warn("JHSGa Judy=%d",PJHSArray);
        JHSG(PValue,PJHSArray,Index,(Word_t)Length);
        //warn("JHSGb Judy=%d PValue=%d *PValue=%d",PJHSArray,PValue,(PValue?(*PValue):-1));

        /* OUTPUT */
	if ( PValue ) {
	    XPUSHs(sv_2mortal(newSVuv(INT2PTR(UV,PValue))));
            XPUSHs(sv_2mortal(newSVuv(*PValue)));
        }
        else {
            XPUSHs(sv_2mortal(newSViv(0)));
            XPUSHs(&PL_sv_undef);
        }

void
ljhs_JHSFA( PJHSArray_arg )
        Pvoid_t PJHSArray_arg
    INIT:
        Word_t Rc_word = 0xDEADBEEF;
        Pvoid_t PJHSArray = (Pvoid_t)PJHSArray_arg;
    PPCODE:
        JHSFA(Rc_word,PJHSArray);
        //warn("JHSFA Rc_word=%d",Rc_word);

        /* OUTPUT */
        XPUSHs(sv_2mortal(newSVuv(Rc_word)));
        XPUSHs(sv_2mortal(newSVuv(INT2PTR(UV,PJHSArray))));
