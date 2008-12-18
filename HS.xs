#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
/* #include "ppport.h" Removed at the suggestion of ppport.h */
#include "Judy.h"

MODULE = Judy::HS PACKAGE = Judy::HS PREFIX = ljhs_

PROTOTYPES: DISABLE

void
ljhs_Duplicates( PJHSArray_sv, Index_sv )
        SV *PJHSArray_sv
        SV *Index_sv
    INIT:
        Pvoid_t PJHSArray = (Pvoid_t*)(SvOK( PJHSArray_sv ) ? SvUV( PJHSArray_sv ) : 0);
        STRLEN  Length = 0xDEADBEEF;
        char *Index = sv_2pvbyte(Index_sv,&Length);
        Word_t *PValue = (Word_t*)0xDEADBEEF;
        Word_t PrevValue = 0xDEADBEEF;
    PPCODE:
        //warn("&PValue=%d",&PValue);
        //warn("JHSIa Judy=%d Index=%s Length=%d",PJHSArray,Index,Length);
        JHSI(PValue,PJHSArray,Index,(Word_t)Length);
        PrevValue = *PValue;
        ++*PValue;
        //warn("JHSIb Judy=%d PValue=%d *PValue=%d Value=%d Index=%s Length=%d",PJHSArray,PValue,(PValue?(*PValue):-1),Value,Index,Length);

        /* OUTPUT */
        if ( PJHSArray_sv ) {
            SvUV_set(PJHSArray_sv,INT2PTR(UV,PJHSArray));
        }
        XPUSHs(sv_2mortal(newSVuv(PrevValue)));

void
ljhs_Set( PJHSArray_sv, Index_sv, Value )
        SV *PJHSArray_sv
        SV *Index_sv
        UV Value
    INIT:
        Pvoid_t PJHSArray = (Pvoid_t*)(SvOK( PJHSArray_sv ) ? SvUV( PJHSArray_sv ) : 0);
        STRLEN  Length = 0xDEADBEEF;
        char *Index = sv_2pvbyte(Index_sv,&Length);
        Word_t  *PValue = (Word_t*)0xDEADBEEF;
    PPCODE:
        //warn("&PValue=%d",&PValue);
        //warn("JHSIa Judy=%d Index=%s Length=%d",PJHSArray,Index,Length);
        JHSI(PValue,PJHSArray,Index,(Word_t)Length);
        *PValue = Value;
        //warn("JHSIb Judy=%d PValue=%d *PValue=%d Value=%d Index=%s Length=%d",PJHSArray,PValue,(PValue?(*PValue):-1),Value,Index,Length);

        /* OUTPUT */
        if ( PJHSArray_sv ) {
            SvUV_set(PJHSArray_sv,INT2PTR(UV,PJHSArray));
        }
        XPUSHs(sv_2mortal(newSVuv(INT2PTR(UV,PValue))));

void
ljhs_Delete( PJHSArray_sv, Index_sv )
        SV *PJHSArray_sv
        SV *Index_sv
    INIT:
        Pvoid_t PJHSArray = (Pvoid_t*)(SvOK(PJHSArray_sv) ? SvUV(PJHSArray_sv) : 0);
        STRLEN Length = 0xDEADBEEF;
        char *Index = sv_2pvbyte(Index_sv,&Length);
        int Rc_int = 0xDEADBEEF;
    PPCODE:
        //warn("JHSDa Judy=%d Rc_int=%d",PJHSArray,Rc_int);
        JHSD(Rc_int,PJHSArray,Index,(Word_t)Length);
        //warn("JHSDb Judy=%d Rc_int=%d",PJHSArray,Rc_int);

        /* OUTPUT */
        if ( PJHSArray_sv ) {
            SvUV_set(PJHSArray_sv,INT2PTR(UV,PJHSArray));
        }
        XPUSHs(sv_2mortal(newSViv(Rc_int)));

void
ljhs_Get( PJHSArray_sv, Index_sv )
        SV *PJHSArray_sv
        SV *Index_sv
    INIT:
        Pvoid_t PJHSArray = (Pvoid_t*)(SvOK(PJHSArray_sv) ? SvUV(PJHSArray_sv) : 0);
        STRLEN Length = 0xDEADBEEF;
        char *Index = sv_2pvbyte(Index_sv,&Length);
        Word_t *PValue = (Word_t*)0xDEADBEEF;
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
ljhs_Free( PJHSArray_sv )
        SV *PJHSArray_sv
    INIT:
        Pvoid_t PJHSArray = (Pvoid_t*)(SvOK(PJHSArray_sv) ? SvUV(PJHSArray_sv) : 0);
        Word_t Rc_word = 0xDEADBEEF;
    PPCODE:
        JHSFA(Rc_word,PJHSArray);
        //warn("JHSFA Rc_word=%d",Rc_word);

        /* OUTPUT */
        if ( PJHSArray_sv ) {
            SvUV_set(PJHSArray_sv,INT2PTR(UV,PJHSArray));
        }
        XPUSHs(sv_2mortal(newSVuv(Rc_word)));
