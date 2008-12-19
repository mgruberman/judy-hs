#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
/* #include "ppport.h" Removed at the suggestion of ppport.h */
#include "Judy.h"

MODULE = Judy::Sugar PACKAGE = Judy::Sugar PREFIX = ljju_

PROTOTYPES: DISABLE

MODULE = Judy::HS PACKAGE = Judy::HS PREFIX = ljhs_

PROTOTYPES: DISABLE

void
ljhs_Duplicates( PJHSArray_sv, Key_sv )
        SV *PJHSArray_sv
        SV *Key_sv
    INIT:
        Pvoid_t PJHSArray = (Pvoid_t)(SvOK( PJHSArray_sv ) ? SvUV( PJHSArray_sv ) : 0);
        STRLEN  Length = 0xDEADBEEF;
        char *Key = sv_2pvbyte(Key_sv,&Length);
        Word_t *PValue = (Word_t*)0xDEADBEEF;
        Word_t PrevValue = 0xDEADBEEF;
    PPCODE:
        //warn("&PValue=%d",&PValue);
        //warn("JHSIa Judy=%d Key=%s Length=%d",PJHSArray,Key,Length);
        JHSI(PValue,PJHSArray,Key,(Word_t)Length);
        PrevValue = *PValue;
        ++*PValue;
        //warn("JHSIb Judy=%d PValue=%d *PValue=%d Value=%d Key=%s Length=%d",PJHSArray,PValue,(PValue?(*PValue):-1),Value,Key,Length);

        /* OUTPUT */
        if ( SvOK(PJHSArray_sv) ) {
            SvUV_set(PJHSArray_sv,INT2PTR(UV,PJHSArray));
        }
        else {
            sv_setsv(ST(0),newSVuv(INT2PTR(UV,PJHSArray)));
        }
        XPUSHs(sv_2mortal(newSVuv(PrevValue)));



void
ljhs_Set( PJHSArray_sv, Key_sv, Value )
        SV *PJHSArray_sv
        SV *Key_sv
        UV Value
    INIT:
        Pvoid_t PJHSArray = (Pvoid_t)(SvOK( PJHSArray_sv ) ? SvUV( PJHSArray_sv ) : 0);
        STRLEN  Length = 0xDEADBEEF;
        char *Key = sv_2pvbyte(Key_sv,&Length);
        Word_t  *PValue = (Word_t*)0xDEADBEEF;
    PPCODE:
        //warn("&PValue=%d",&PValue);
        //warn("JHSIa Judy=%d Key=%s Length=%d",PJHSArray,Key,Length);
        JHSI(PValue,PJHSArray,Key,(Word_t)Length);
        *PValue = Value;
        //warn("JHSIb Judy=%d PValue=%d *PValue=%d Value=%d Key=%s Length=%d",PJHSArray,PValue,(PValue?(*PValue):-1),Value,Key,Length);

        /* OUTPUT */
        if ( SvOK(PJHSArray_sv) ) {
            SvUV_set(PJHSArray_sv,INT2PTR(UV,PJHSArray));
        }
        else {
            sv_setsv(ST(0),newSVuv(INT2PTR(UV,PJHSArray)));
        }
        XPUSHs(sv_2mortal(newSVuv(INT2PTR(UV,PValue))));

void
ljhs_Delete( PJHSArray_sv, Key_sv )
        SV *PJHSArray_sv
        SV *Key_sv
    INIT:
        Pvoid_t PJHSArray = (Pvoid_t)(SvOK(PJHSArray_sv) ? SvUV(PJHSArray_sv) : 0);
        STRLEN Length = 0xDEADBEEF;
        char *Key = sv_2pvbyte(Key_sv,&Length);
        int Rc_int = 0xDEADBEEF;
    PPCODE:
        //warn("JHSDa Judy=%d Rc_int=%d",PJHSArray,Rc_int);
        JHSD(Rc_int,PJHSArray,Key,(Word_t)Length);
        //warn("JHSDb Judy=%d Rc_int=%d",PJHSArray,Rc_int);

        /* OUTPUT */
        if ( SvOK(PJHSArray_sv) ) {
            SvUV_set(PJHSArray_sv,INT2PTR(UV,PJHSArray));
        }
        else {
            sv_setsv(ST(0),newSVuv(INT2PTR(UV,PJHSArray)));
        }
        XPUSHs(sv_2mortal(newSViv(Rc_int)));

void
ljhs_Get( PJHSArray_sv, Key_sv )
        SV *PJHSArray_sv
        SV *Key_sv
    INIT:
        Pvoid_t PJHSArray = (Pvoid_t)(SvOK(PJHSArray_sv) ? SvUV(PJHSArray_sv) : 0);
        STRLEN Length = 0xDEADBEEF;
        char *Key = sv_2pvbyte(Key_sv,&Length);
        Word_t *PValue = (Word_t*)0xDEADBEEF;
    PPCODE:
        //warn("&PValue=%d",&PValue);
        //warn("JHSGa Judy=%d",PJHSArray);
        JHSG(PValue,PJHSArray,Key,(Word_t)Length);
        //warn("JHSGb Judy=%d PValue=%d *PValue=%d",PJHSArray,PValue,(PValue?(*PValue):-1));

        /* OUTPUT */
        if ( PValue ) {
            EXTEND(SP,2);
            PUSHs(sv_2mortal(newSVuv(INT2PTR(UV,PValue))));
            PUSHs(sv_2mortal(newSVuv(*PValue)));
        }

void
ljhs_Free( PJHSArray_sv )
        SV *PJHSArray_sv
    INIT:
        Pvoid_t PJHSArray = (Pvoid_t)(SvOK(PJHSArray_sv) ? SvUV(PJHSArray_sv) : 0);
        Word_t Rc_word = 0xDEADBEEF;
    PPCODE:
        JHSFA(Rc_word,PJHSArray);
        //warn("JHSFA Rc_word=%d",Rc_word);

        /* OUTPUT */
        if ( SvOK(PJHSArray_sv) ) {
            SvUV_set(PJHSArray_sv,INT2PTR(UV,PJHSArray));
        }
        else {
            sv_setsv(ST(0),newSVuv(INT2PTR(UV,PJHSArray)));
        }
        XPUSHs(sv_2mortal(newSVuv(Rc_word)));

MODULE = Judy::SL PACKAGE = Judy::SL PREFIX = ljsl_

PROTOTYPES: DISABLE

void
ljsl_Set( PJSLArray_sv, Key_sv, Value )
        SV *PJSLArray_sv
        SV *Key_sv
        UV Value
    INIT:
        Pvoid_t PJSLArray = (Pvoid_t)(SvOK( PJSLArray_sv ) ? SvUV( PJSLArray_sv ) : 0 );
        STRLEN Length = 0xDEADBEEF;
        char *Key = sv_2pvbyte( Key_sv, &Length );
        Word_t *PValue = (Word_t*)0xDEADBEEF;
    PPCODE:
        JSLI(PValue,PJSLArray,Key);
        *PValue = Value;

        /* OUTPUT */
        if ( SvOK(PJSLArray_sv) ) {
            SvUV_set(PJSLArray_sv, INT2PTR(UV,PJSLArray));
        }
        else {
            sv_setsv(ST(0),newSVuv(INT2PTR(UV,PJSLArray)));
        }
        XPUSHs(sv_2mortal(newSVuv(INT2PTR(UV,PValue))));


void
ljsl_Delete( PJSLArray_sv, Key_sv )
        SV *PJSLArray_sv
        SV *Key_sv
    INIT:
        Pvoid_t PJSLArray = (Pvoid_t)(SvOK(PJSLArray_sv) ? SvUV(PJSLArray_sv) : 0);
        STRLEN Length = 0xDEADBEEF;
        char *Key = sv_2pvbyte( Key_sv, &Length );
        int Rc_int = 0xDEADBEEF;
    PPCODE:
        JSLD(Rc_int,PJSLArray,Key);

        /* OUTPUT */
        if ( SvOK(PJSLArray_sv) ) {
            SvUV_set(PJSLArray_sv, INT2PTR(UV,PJSLArray));
        }
        else {
            sv_setsv(ST(0),newSVuv(INT2PTR(UV,PJSLArray)));
        }
        XPUSHs(sv_2mortal(newSViv(Rc_int)));

void
ljsl_Get( PJSLArray_sv, Key_sv )
        SV *PJSLArray_sv
        SV *Key_sv
    INIT:
        Pvoid_t PJSLArray = (Pvoid_t)(SvOK(PJSLArray_sv) ? SvUV(PJSLArray_sv) : 0);
        STRLEN Length = 0xDEADBEEF;
        char *Key = sv_2pvbyte( Key_sv, &Length );
        Word_t *PValue = (Word_t*)0xDEADBEEF;
    PPCODE:
        JSLG(PValue,PJSLArray,Key);

        if ( PValue ) {
            EXTEND(SP,2);
            PUSHs(sv_2mortal(newSVuv(INT2PTR(UV,PValue))));
            PUSHs(sv_2mortal(newSVuv(*PValue)));
        }

void
ljsl_Free( PJSLArray_sv )
        SV *PJSLArray_sv
    INIT:
        Pvoid_t PJSLArray = (Pvoid_t)(SvOK(PJSLArray_sv) ? SvUV(PJSLArray_sv) : 0);
        Word_t Rc_word = 0xDEADBEEF;
    PPCODE:
        JSLFA(Rc_word,PJSLArray);

        /* OUTPUT */
        if ( SvOK(PJSLArray_sv) ) {
            SvUV_set(PJSLArray_sv, INT2PTR(UV,PJSLArray));
        }
        else {
            sv_setsv(ST(0),newSVuv(INT2PTR(UV,PJSLArray)));
        }
        XPUSHs(sv_2mortal(newSVuv(Rc_word)));


void
ljsl_SearchForward( PJSLArray_sv, Key_sv )
        SV *PJSLArray_sv
        SV *Key_sv
    INIT:
        Pvoid_t PJSLArray = (Pvoid_t)(SvOK(PJSLArray_sv) ? SvUV(PJSLArray_sv) : 0);
        STRLEN Length = 0xDEADBEEF;
        char *Key = sv_2pvbyte( Key_sv, &Length );
        Word_t *PValue = (Word_t*)0xDEADBEEF;
    PPCODE:
        JSLF(PValue,PJSLArray,Key);

        if ( PValue ) {
            EXTEND(SP,3);
            PUSHs(sv_2mortal(newSVuv(INT2PTR(UV,PValue))));
            PUSHs(sv_2mortal(newSVuv(*PValue)));
	    PUSHs(sv_2mortal(newSVpv(Key,0)));
        }


void
ljsl_ContinueForward( PJSLArray_sv, Key_sv )
        SV *PJSLArray_sv
        SV *Key_sv
    INIT:
        Pvoid_t PJSLArray = (Pvoid_t)(SvOK(PJSLArray_sv) ? SvUV(PJSLArray_sv) : 0);
        STRLEN Length = 0xDEADBEEF;
        char *Key = sv_2pvbyte( Key_sv, &Length );
        Word_t *PValue = (Word_t*)0xDEADBEEF;
    PPCODE:
        JSLN(PValue,PJSLArray,Key);

        if ( PValue ) {
            EXTEND(SP,3);
            PUSHs(sv_2mortal(newSVuv(INT2PTR(UV,PValue))));
            PUSHs(sv_2mortal(newSVuv(*PValue)));
	    PUSHs(sv_2mortal(newSVpv(Key,0)));
        }



void
ljsl_SearchBackward( PJSLArray_sv, Key_sv )
        SV *PJSLArray_sv
        SV *Key_sv
    INIT:
        Pvoid_t PJSLArray = (Pvoid_t)(SvOK(PJSLArray_sv) ? SvUV(PJSLArray_sv) : 0);
        STRLEN Length = 0xDEADBEEF;
        char *Key = sv_2pvbyte( Key_sv, &Length );
        Word_t *PValue = (Word_t*)0xDEADBEEF;
    PPCODE:
        JSLL(PValue,PJSLArray,Key);

        if ( PValue ) {
            EXTEND(SP,3);
            PUSHs(sv_2mortal(newSVuv(INT2PTR(UV,PValue))));
            PUSHs(sv_2mortal(newSVuv(*PValue)));
	    PUSHs(sv_2mortal(newSVpv(Key,0)));
        }


void
ljsl_ContinueBackward( PJSLArray_sv, Key_sv )
        SV *PJSLArray_sv
        SV *Key_sv
    INIT:
        Pvoid_t PJSLArray = (Pvoid_t)(SvOK(PJSLArray_sv) ? SvUV(PJSLArray_sv) : 0);
        STRLEN Length = 0xDEADBEEF;
        char *Key = sv_2pvbyte( Key_sv, &Length );
        Word_t *PValue = (Word_t*)0xDEADBEEF;
    PPCODE:
        JSLP(PValue,PJSLArray,Key);

        if ( PValue ) {
            EXTEND(SP,3);
            PUSHs(sv_2mortal(newSVuv(INT2PTR(UV,PValue))));
            PUSHs(sv_2mortal(newSVuv(*PValue)));
	    PUSHs(sv_2mortal(newSVpv(Key,0)));
        }


MODULE = Judy::HS PACKAGE = Judy::HS PREFIX = ljhs_

