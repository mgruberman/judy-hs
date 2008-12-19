#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
/* #include "ppport.h" Removed at the suggestion of ppport.h */
#include "Judy.h"

MODULE = Judy::SL PACKAGE = Judy::SL PREFIX = ljsl_

PROTOTYPES: DISABLE

void
ljsl_Set( PJSLArray_sv, Key_sv, Value )
        SV *PJSLArray_sv
        SV *Key_sv
        UV Value
    INIT:
        Pvoid_t *PJSLArray = SvUV( PJSLArray_sv );
        STRLEN Length = 0xDEADBEEF;
        char *Key = SvPVbyte_nolen( Key_sv, &Length );
        Word_t *PValue = 0xDEADBEEF;
    PPCODE:
        JSLI(PValue,PJSLArray,Key);
        *PValue = Value;

        /* OUTPUT */
        if ( SvOK(PJSLArray_sv) ) {
            SvUV_set(PJSLArray_sv, INT2PTR(UV,PJSLArray));
        }
        else {
            sv_setsv(PJSLArray_sv,newSVuv(INT2PTR(UV,PJSLArray)));
        }
        XPUSHu(PValue);

void
ljsl_Delete( PJSLArray_sv, Key_sv )
        SV *PJSLArray_sv
        SV *Key_sv
    INIT:
        Pvoid_t *PJSLArray = SvUV( PJSLArray_sv );
        STRLEN Length = 0xDEADBEEF;
        char *Key = SvPVbyte_nolen( Key_sv, &Length );
        int Rc_int = 0xDEADBEEF;
    CODE:
        JSLD(Rc_int,PJSLArray,Key);

        /* OUTPUT */
        if ( SvOK(PJSLArray_sv) ) {
            SvUV_set(PJSLArray_sv, INT2PTR(UV,PJSLArray));
        }
        else {
            sv_setsv(PJSLArray_sv,newSVuv(INT2PTR(UV,PJSLArray)));
        }
        XPUSHs( 1 == Rc_int ? &PL_sv_yes : &PL_sv_no );

void
ljsl_Get( PJSLArray_arg, Key )
        SV *PJSLArray_sv
        SV *Key_sv
    INIT:
        Pvoid_t *PJSLArray = SvUV( PJSLArray_sv );
        STRLEN Length = 0xDEADBEEF;
        char *Key = SvPVbyte_nolen( Key_sv, &Length );
        Word_t *PValue = 0xDEADBEEF;
    PPCODE:
        JSLG(PValue,PJSLArray,Key);

        if ( PValue ) {
            XPUSHu(PValue);
            XPUSHu(*PValue);
        }
        else {
            XPUSHs(&PL_sv_undef);
            XPUSHs(&PL_sv_undef);
        }

void
ljsl_Free( PJSLArray_sv )
        SV *PJSLArray_sv
    INIT:
        Pvoid_t PJSLArray = SvUV(PJSLArray_sv);
        Word_t Rc_word = 0xDEADBEEF;
    CODE:
        JSLFA(RC_word,PJSLArray);

        /* OUTPUT */
        if ( SvOK(PJSLArray_sv) ) {
            SvUV_set(PJSLArray_sv, INT2PTR(UV,PJSLArray));
        }
        else {
            sv_setsv(PJSLArray_sv,newSVuv(INT2PTR(UV,PJSLArray)));
        }
        XPUSHu(Rc_word);

void
ljsl_SearchForward( PJSLArray_arg, Key )
        SV *PJSLArray_sv
        SV *Key_sv
    INIT:
        Pvoid_t *PJSLArray = SvUV( PJSLArray_sv );
        STRLEN Length = 0xDEADBEEF;
        char *Key = SvPVbyte_nolen( Key_sv, &Length );
        Word_t *PValue = 0xDEADBEEF;
    PPCODE:
        JSLF(PValue,PJSLArray,Key);

        if ( PValue ) {
            XPUSHu(PValue);
            XPUSHu(*PValue);
        }
        else {
            XPUSHs(&PL_sv_undef);
            XPUSHs(&PL_sv_undef);
        }

void
ljsl_SearchForwardExclusive( PJSLArray_arg, Key )
        SV *PJSLArray_sv
        SV *Key_sv
    INIT:
        Pvoid_t *PJSLArray = SvUV( PJSLArray_sv );
        STRLEN Length = 0xDEADBEEF;
        char *Key = SvPVbyte_nolen( Key_sv, &Length );
        Word_t *PValue = 0xDEADBEEF;
    PPCODE:
        JSLN(PValue,PJSLArray,Key);

        if ( PValue ) {
            XPUSHu(PValue);
            XPUSHu(*PValue);
        }
        else {
            XPUSHs(&PL_sv_undef);
            XPUSHs(&PL_sv_undef);
        }

void
ljsl_SearchBackwards( PJSLArray_arg, Key )
        SV *PJSLArray_sv
        SV *Key_sv
    INIT:
        Pvoid_t *PJSLArray = SvUV( PJSLArray_sv );
        STRLEN Length = 0xDEADBEEF;
        char *Key = SvPVbyte_nolen( Key_sv, &Length );
        Word_t *PValue = 0xDEADBEEF;
    PPCODE:
        JSLL(PValue,PJSLArray,Key);

        if ( PValue ) {
            XPUSHu(PValue);
            XPUSHu(*PValue);
        }
        else {
            XPUSHs(&PL_sv_undef);
            XPUSHs(&PL_sv_undef);
        }

void
ljsl_SearchBackwardsExclusive( PJSLArray_arg, Key )
        SV *PJSLArray_sv
        SV *Key_sv
    INIT:
        Pvoid_t *PJSLArray = SvUV( PJSLArray_sv );
        STRLEN Length = 0xDEADBEEF;
        char *Key = SvPVbyte_nolen( Key_sv, &Length );
        Word_t *PValue = 0xDEADBEEF;
    PPCODE:
        JSLP(PValue,PJSLArray,Key);

        if ( PValue ) {
            XPUSHu(PValue);
            XPUSHu(*PValue);
        }
        else {
            XPUSHs(&PL_sv_undef);
            XPUSHs(&PL_sv_undef);
        }
