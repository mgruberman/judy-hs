#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
/*
 *  --- hint for SvPVbyte ---
 *  Does not work in perl-5.6.1, ppport.h implements a version
 *  borrowed from perl-5.7.3.
 */
#define NEED_sv_2pvbyte
#include "ppport.h"
#include "Judy.h"

#include "const-c.inc"

MODULE = Judy::Mem PACKAGE = Judy::Mem PREFIX = ljme_

=pod

/*
 * I am not sure that using UV and char* directly as XS types improves things
 * much. Perhaps these should be direct SV* accesses.
 */

=cut

UV
ljme_String2Ptr(in)
        char *in
    INIT:
        size_t length = strlen(in);
        char *out = (char*)0xDEADBEEF;
    CODE:
        Newx(out,length,char);
        Copy(in,out,length,char);
        RETVAL = INT2PTR(UV,out);
    OUTPUT:
        RETVAL

void
ljme_Ptr2String(in)
        SV *in
    PPCODE:
        XPUSHs(sv_2mortal(newSVpv((char*)SvUV(in),0)));

void
ljme_Ptr2String2(in,len)
        SV *in
        STRLEN len
    PPCODE:
        XPUSHs(sv_2mortal(newSVpv((char*)SvUV(in),len)));


void
ljme_Free(PStr)
        SV *PStr
    CODE:
        Safefree(SvUV(PStr));

UV
PeekU(ptr)
        UV ptr
    CODE:
        RETVAL = *((UV*)ptr);
    OUTPUT:
        RETVAL

void
PokeU(ptr,v)
        UV ptr
        UV v
    CODE:
        *((UV*)ptr) = v;

IV
PeekI(ptr)
        IV ptr
    CODE:
        RETVAL = *((IV*)ptr);
    OUTPUT:
        RETVAL

void
PokeI(ptr,v)
        IV ptr
        IV v
    CODE:
        *((IV*)ptr) = v;




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
        char *Key = SvPVbyte(Key_sv,Length);
        Word_t *PValue = (Word_t*)0xDEADBEEF;
        Word_t PrevValue = 0xDEADBEEF;
    PPCODE:
        JHSI(PValue,PJHSArray,Key,(Word_t)Length);
        PrevValue = *PValue;
        ++*PValue;

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
        char *Key = SvPVbyte(Key_sv,Length);
        Word_t  *PValue = (Word_t*)0xDEADBEEF;
    PPCODE:
        JHSI(PValue,PJHSArray,Key,(Word_t)Length);
        *PValue = Value;

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
        char *Key = SvPVbyte(Key_sv,Length);
        int Rc_int = 0xDEADBEEF;
    PPCODE:
        JHSD(Rc_int,PJHSArray,Key,(Word_t)Length);

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
        char *Key = SvPVbyte(Key_sv,Length);
        Word_t *PValue = (Word_t*)0xDEADBEEF;
    PPCODE:
        JHSG(PValue,PJHSArray,Key,(Word_t)Length);

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
        char *Key = SvPVbyte(Key_sv,Length);
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
        char *Key = SvPVbyte(Key_sv,Length);
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
        char *Key = SvPVbyte(Key_sv,Length);
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
ljsl_First( PJSLArray_sv, Key_sv )
        SV *PJSLArray_sv
        SV *Key_sv
    INIT:
        Pvoid_t PJSLArray = (Pvoid_t)(SvOK(PJSLArray_sv) ? SvUV(PJSLArray_sv) : 0);
        STRLEN Length = 0xDEADBEEF;
        char *Key = SvPVbyte(Key_sv,Length);
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
ljsl_Next( PJSLArray_sv, Key_sv )
        SV *PJSLArray_sv
        SV *Key_sv
    INIT:
        Pvoid_t PJSLArray = (Pvoid_t)(SvOK(PJSLArray_sv) ? SvUV(PJSLArray_sv) : 0);
        STRLEN Length = 0xDEADBEEF;
        char *Key = SvPVbyte(Key_sv,Length);
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
ljsl_Last( PJSLArray_sv, Key_sv )
        SV *PJSLArray_sv
        SV *Key_sv
    INIT:
        Pvoid_t PJSLArray = (Pvoid_t)(SvOK(PJSLArray_sv) ? SvUV(PJSLArray_sv) : 0);
        STRLEN Length = 0xDEADBEEF;
        char *Key = SvPVbyte( Key_sv, Length );
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
ljsl_Prev( PJSLArray_sv, Key_sv )
        SV *PJSLArray_sv
        SV *Key_sv
    INIT:
        Pvoid_t PJSLArray = (Pvoid_t)(SvOK(PJSLArray_sv) ? SvUV(PJSLArray_sv) : 0);
        STRLEN Length = 0xDEADBEEF;
        char *Key = SvPVbyte(Key_sv,Length);
        Word_t *PValue = (Word_t*)0xDEADBEEF;
    PPCODE:
        JSLP(PValue,PJSLArray,Key);

        if ( PValue ) {
            EXTEND(SP,3);
            PUSHs(sv_2mortal(newSVuv(INT2PTR(UV,PValue))));
            PUSHs(sv_2mortal(newSVuv(*PValue)));
	    PUSHs(sv_2mortal(newSVpv(Key,0)));
        }



MODULE = Judy::L PACKAGE = Judy::L PREFIX = ljl_

PROTOTYPES: DISABLE

void
ljl_Set( PJLArray_sv, Key, Value )
        SV *PJLArray_sv
        UV Key
        UV Value
    INIT:
        Pvoid_t PJLArray = (Pvoid_t)(SvOK( PJLArray_sv ) ? SvUV( PJLArray_sv ) : 0 );
        Word_t *PValue = (Word_t*)0xDEADBEEF;
    PPCODE:
        JLI(PValue,PJLArray,Key);
        *PValue = Value;

        /* OUTPUT */
        if ( SvOK(PJLArray_sv) ) {
            SvUV_set(PJLArray_sv, INT2PTR(UV,PJLArray));
        }
        else {
            sv_setsv(ST(0),newSVuv(INT2PTR(UV,PJLArray)));
        }
        XPUSHs(sv_2mortal(newSVuv(INT2PTR(UV,PValue))));


void
ljl_Delete( PJLArray_sv, Key )
        SV *PJLArray_sv
        UV Key
    INIT:
        Pvoid_t PJLArray = (Pvoid_t)(SvOK(PJLArray_sv) ? SvUV(PJLArray_sv) : 0);
        int Rc_int = 0xDEADBEEF;
    PPCODE:
        JLD(Rc_int,PJLArray,Key);

        /* OUTPUT */
        if ( SvOK(PJLArray_sv) ) {
            SvUV_set(PJLArray_sv, INT2PTR(UV,PJLArray));
        }
        else {
            sv_setsv(ST(0),newSVuv(INT2PTR(UV,PJLArray)));
        }
        XPUSHs(sv_2mortal(newSViv(Rc_int)));

void
ljl_Get( PJLArray_sv, Key )
        SV *PJLArray_sv
        UV Key
    INIT:
        Pvoid_t PJLArray = (Pvoid_t)(SvOK(PJLArray_sv) ? SvUV(PJLArray_sv) : 0);
        Word_t *PValue = (Word_t*)0xDEADBEEF;
    PPCODE:
        JLG(PValue,PJLArray,Key);

        if ( PValue ) {
            EXTEND(SP,2);
            PUSHs(sv_2mortal(newSVuv(INT2PTR(UV,PValue))));
            PUSHs(sv_2mortal(newSVuv(*PValue)));
        }

void
ljl_Count( PJLArray_sv, Key1, Key2 )
        SV *PJLArray_sv
        UV Key1
        UV Key2
    INIT:
        Pvoid_t PJLArray = (Pvoid_t)(SvOK(PJLArray_sv) ? SvUV(PJLArray_sv) : 0);
        Word_t Rc_word = 0xDEADBEEF;
    PPCODE:
        JLC(Rc_word,PJLArray,Key1,Key2);

        XPUSHs(sv_2mortal(newSVuv(Rc_word)));

void
ljl_Nth( PJLArray_sv, Nth )
        SV *PJLArray_sv
        UV Nth
    INIT:
        Pvoid_t PJLArray = (Pvoid_t)(SvOK(PJLArray_sv) ? SvUV(PJLArray_sv) : 0);
        Word_t Rc_word = 0xDEADBEEF;
        UV Index = 0xDEADBEEF;
        Word_t *PValue = (Word_t*)0xDEADBEEF;
    PPCODE:
        JLBC(PValue,PJLArray,Nth,Index);

        if ( PValue ) {
            EXTEND(SP,3);
            PUSHs(sv_2mortal(newSVuv(INT2PTR(UV,PValue))));
            PUSHs(sv_2mortal(newSVuv(*PValue)));
            PUSHs(sv_2mortal(newSVuv(Index)));
        }

void
ljl_Free( PJLArray_sv )
        SV *PJLArray_sv
    INIT:
        Pvoid_t PJLArray = (Pvoid_t)(SvOK(PJLArray_sv) ? SvUV(PJLArray_sv) : 0);
        Word_t Rc_word = 0xDEADBEEF;
    PPCODE:
        JLFA(Rc_word,PJLArray);

        /* OUTPUT */
        if ( SvOK(PJLArray_sv) ) {
            SvUV_set(PJLArray_sv, INT2PTR(UV,PJLArray));
        }
        else {
            sv_setsv(ST(0),newSVuv(INT2PTR(UV,PJLArray)));
        }
        XPUSHs(sv_2mortal(newSVuv(Rc_word)));

void
ljl_MemUsed( PJLArray_sv )
        SV *PJLArray_sv
    INIT:
        Pvoid_t PJLArray = (Pvoid_t)(SvOK(PJLArray_sv) ? SvUV(PJLArray_sv) : 0);
        Word_t Rc_word = 0xDEADBEEF;
    PPCODE:
        JLMU(Rc_word,PJLArray);

        /* OUTPUT */
        XPUSHs(sv_2mortal(newSVuv(Rc_word)));

void
ljl_First( PJLArray_sv, Key )
        SV *PJLArray_sv
        UV Key
    INIT:
        Pvoid_t PJLArray = (Pvoid_t)(SvOK(PJLArray_sv) ? SvUV(PJLArray_sv) : 0);
        Word_t *PValue = (Word_t*)0xDEADBEEF;
    PPCODE:
        JLF(PValue,PJLArray,Key);

        if ( PValue ) {
            EXTEND(SP,3);
            PUSHs(sv_2mortal(newSVuv(INT2PTR(UV,PValue))));
            PUSHs(sv_2mortal(newSVuv(*PValue)));
	    PUSHs(sv_2mortal(newSVuv(Key)));
        }


void
ljl_Next( PJLArray_sv, Key )
        SV *PJLArray_sv
        UV Key
    INIT:
        Pvoid_t PJLArray = (Pvoid_t)(SvOK(PJLArray_sv) ? SvUV(PJLArray_sv) : 0);
        Word_t *PValue = (Word_t*)0xDEADBEEF;
    PPCODE:
        JLN(PValue,PJLArray,Key);

        if ( PValue ) {
            EXTEND(SP,3);
            PUSHs(sv_2mortal(newSVuv(INT2PTR(UV,PValue))));
            PUSHs(sv_2mortal(newSVuv(*PValue)));
	    PUSHs(sv_2mortal(newSVuv(Key)));
        }



void
ljl_Last( PJLArray_sv, Key )
        SV *PJLArray_sv
        UV Key
    INIT:
        Pvoid_t PJLArray = (Pvoid_t)(SvOK(PJLArray_sv) ? SvUV(PJLArray_sv) : 0);
        Word_t *PValue = (Word_t*)0xDEADBEEF;
    PPCODE:
        JLL(PValue,PJLArray,Key);

        if ( PValue ) {
            EXTEND(SP,3);
            PUSHs(sv_2mortal(newSVuv(INT2PTR(UV,PValue))));
            PUSHs(sv_2mortal(newSVuv(*PValue)));
	    PUSHs(sv_2mortal(newSVuv(Key)));
        }


void
ljl_Prev( PJLArray_sv, Key )
        SV *PJLArray_sv
        UV Key
    INIT:
        Pvoid_t PJLArray = (Pvoid_t)(SvOK(PJLArray_sv) ? SvUV(PJLArray_sv) : 0);
        Word_t *PValue = (Word_t*)0xDEADBEEF;
    PPCODE:
        JLP(PValue,PJLArray,Key);

        if ( PValue ) {
            EXTEND(SP,3);
            PUSHs(sv_2mortal(newSVuv(INT2PTR(UV,PValue))));
            PUSHs(sv_2mortal(newSVuv(*PValue)));
	    PUSHs(sv_2mortal(newSVuv(Key)));
        }

void
ljl_FirstEmpty( PJLArray_sv, Key )
        SV *PJLArray_sv
        UV Key
    INIT:
        Pvoid_t PJLArray = (Pvoid_t)(SvOK(PJLArray_sv) ? SvUV(PJLArray_sv) : 0);
        int Rc_int = 0xDEADBEEF;
    PPCODE:
        JLFE(Rc_int,PJLArray,Key);

        if ( Rc_int ) {
            XPUSHs(sv_2mortal(newSVuv(Key)));
        }


void
ljl_NextEmpty( PJLArray_sv, Key )
        SV *PJLArray_sv
        UV Key
    INIT:
        Pvoid_t PJLArray = (Pvoid_t)(SvOK(PJLArray_sv) ? SvUV(PJLArray_sv) : 0);
        int Rc_int = 0xDEADBEEF;
    PPCODE:
        JLNE(Rc_int,PJLArray,Key);

        if ( Rc_int ) {
            XPUSHs(sv_2mortal(newSVuv(Key)));
        }

void
ljl_LastEmpty( PJLArray_sv, Key )
        SV *PJLArray_sv
        UV Key
    INIT:
        Pvoid_t PJLArray = (Pvoid_t)(SvOK(PJLArray_sv) ? SvUV(PJLArray_sv) : 0);
        int Rc_int = 0xDEADBEEF;
    PPCODE:
        JLLE(Rc_int,PJLArray,Key);

        if ( Rc_int ) {
            XPUSHs(sv_2mortal(newSVuv(Key)));
        }

void
ljl_PrevEmpty( PJLArray_sv, Key )
        SV *PJLArray_sv
        UV Key
    INIT:
        Pvoid_t PJLArray = (Pvoid_t)(SvOK(PJLArray_sv) ? SvUV(PJLArray_sv) : 0);
        int Rc_int = 0xDEADBEEF;
    PPCODE:
        JLPE(Rc_int,PJLArray,Key);

        if ( Rc_int ) {
            XPUSHs(sv_2mortal(newSVuv(Key)));
        }

MODULE = Judy::1 PACKAGE = Judy::1 PREFIX = lj1_

PROTOTYPES: DISABLE

void
lj1_Set( PJ1Array_sv, Key )
        SV *PJ1Array_sv
        UV Key
    INIT:
        Pvoid_t PJ1Array = (Pvoid_t)(SvOK( PJ1Array_sv ) ? SvUV( PJ1Array_sv ) : 0 );
        int Rc_int = 0xDEADBEEF;
    PPCODE:
        J1S(Rc_int,PJ1Array,Key);

        /* OUTPUT */
        if ( SvOK(PJ1Array_sv) ) {
            SvUV_set(PJ1Array_sv, INT2PTR(UV,PJ1Array));
        }
        else {
            sv_setsv(ST(0),newSVuv(INT2PTR(UV,PJ1Array)));
        }
        XPUSHs(Rc_int ? &PL_sv_yes : &PL_sv_no);

void
lj1_Unset( PJ1Array_sv, Key )
        SV *PJ1Array_sv
        UV Key
    INIT:
        Pvoid_t PJ1Array = (Pvoid_t)(SvOK( PJ1Array_sv ) ? SvUV( PJ1Array_sv ) : 0 );
        int Rc_int = 0xDEADBEEF;
    PPCODE:
        J1U(Rc_int,PJ1Array,Key);

        /* OUTPUT */
        if ( SvOK(PJ1Array_sv) ) {
            SvUV_set(PJ1Array_sv, INT2PTR(UV,PJ1Array));
        }
        else {
            sv_setsv(ST(0),newSVuv(INT2PTR(UV,PJ1Array)));
        }
        XPUSHs(Rc_int ? &PL_sv_yes : &PL_sv_no);

void
lj1_Test( PJ1Array_sv, Key )
        SV *PJ1Array_sv
        UV Key
    INIT:
        Pvoid_t PJ1Array = (Pvoid_t)(SvOK( PJ1Array_sv ) ? SvUV( PJ1Array_sv ) : 0 );
        int Rc_int = 0xDEADBEEF;
    PPCODE:
        J1T(Rc_int,PJ1Array,Key);

        /* OUTPUT */
        if ( SvOK(PJ1Array_sv) ) {
            SvUV_set(PJ1Array_sv, INT2PTR(UV,PJ1Array));
        }
        else {
            sv_setsv(ST(0),newSVuv(INT2PTR(UV,PJ1Array)));
        }
        XPUSHs(Rc_int ? &PL_sv_yes : &PL_sv_no);

void
lj1_Count( PJ1Array_sv, Key1, Key2 )
        SV *PJ1Array_sv
        UV Key1
        UV Key2
    INIT:
        Pvoid_t PJ1Array = (Pvoid_t)(SvOK(PJ1Array_sv) ? SvUV(PJ1Array_sv) : 0);
        Word_t Rc_word = 0xDEADBEEF;
        JError_t JError;
    PPCODE:
        Rc_word = Judy1Count(PJ1Array,Key1,Key2,&JError);
        if ( Rc_word ) {
            XPUSHs(sv_2mortal(newSVuv(Rc_word)));
        }
        else {
            if (JU_ERRNO(&JError) == JU_ERRNO_NONE) {
                XPUSHs(sv_2mortal(newSViv(0)));
            }
            else if ( JU_ERRNO(&JError) == JU_ERRNO_FULL) {
                XPUSHs(sv_2mortal(newSVuv(0xFFFFFFFF)));
            }
            else if (JU_ERRNO(&JError) == JU_ERRNO_NULLPPARRAY) {
                croak("NullArray");
            }
            else if (JU_ERRNO(&JError) >  JU_ERRNO_NFMAX) {
                croak("Null_or_CorruptArray");
            }
        }

void
lj1_Nth( PJ1Array_sv, Nth )
        SV *PJ1Array_sv
        UV Nth
    INIT:
        Pvoid_t PJ1Array = (Pvoid_t)(SvOK(PJ1Array_sv) ? SvUV(PJ1Array_sv) : 0);
        UV Index = 0xDEADBEEF;
        int Rc_int = 0xDEADBEEF;
    PPCODE:
        J1BC(Rc_int,PJ1Array,Nth,Index);

        if ( Rc_int ) {
            PUSHs(sv_2mortal(newSVuv(Index)));
        }

void
lj1_Free( PJ1Array_sv )
        SV *PJ1Array_sv
    INIT:
        Pvoid_t PJ1Array = (Pvoid_t)(SvOK(PJ1Array_sv) ? SvUV(PJ1Array_sv) : 0);
        Word_t Rc_word = 0xDEADBEEF;
    PPCODE:
        JLFA(Rc_word,PJ1Array);

        /* OUTPUT */
        if ( SvOK(PJ1Array_sv) ) {
            SvUV_set(PJ1Array_sv, INT2PTR(UV,PJ1Array));
        }
        else {
            sv_setsv(ST(0),newSVuv(INT2PTR(UV,PJ1Array)));
        }
        XPUSHs(sv_2mortal(newSVuv(Rc_word)));

void
lj1_MemUsed( PJ1Array_sv )
        SV *PJ1Array_sv
    INIT:
        Pvoid_t PJ1Array = (Pvoid_t)(SvOK(PJ1Array_sv) ? SvUV(PJ1Array_sv) : 0);
        Word_t Rc_word = 0xDEADBEEF;
    PPCODE:
        J1MU(Rc_word,PJ1Array);

        /* OUTPUT */
        XPUSHs(sv_2mortal(newSVuv(Rc_word)));

void
lj1_First( PJ1Array_sv, Key )
        SV *PJ1Array_sv
        UV Key
    INIT:
        Pvoid_t PJ1Array = (Pvoid_t)(SvOK(PJ1Array_sv) ? SvUV(PJ1Array_sv) : 0);
        int Rc_int = 0xDEADBEEF;
    PPCODE:
        J1F(Rc_int,PJ1Array,Key);

        if ( Rc_int ) {
            XPUSHs(sv_2mortal(newSVuv(Key)));
        }


void
lj1_Next( PJ1Array_sv, Key )
        SV *PJ1Array_sv
        UV Key
    INIT:
        Pvoid_t PJ1Array = (Pvoid_t)(SvOK(PJ1Array_sv) ? SvUV(PJ1Array_sv) : 0);
        int Rc_int = 0xDEADBEEF;
    PPCODE:
        J1N(Rc_int,PJ1Array,Key);

        if ( Rc_int ) {
            XPUSHs(sv_2mortal(newSVuv(Key)));
        }



void
lj1_Last( PJ1Array_sv, Key )
        SV *PJ1Array_sv
        UV Key
    INIT:
        Pvoid_t PJ1Array = (Pvoid_t)(SvOK(PJ1Array_sv) ? SvUV(PJ1Array_sv) : 0);
        int Rc_int = 0xDEADBEEF;
    PPCODE:
        J1L(Rc_int,PJ1Array,Key);

        if ( Rc_int ) {
            XPUSHs(sv_2mortal(newSVuv(Key)));
        }


void
lj1_Prev( PJ1Array_sv, Key )
        SV *PJ1Array_sv
        UV Key
    INIT:
        Pvoid_t PJ1Array = (Pvoid_t)(SvOK(PJ1Array_sv) ? SvUV(PJ1Array_sv) : 0);
        int Rc_int = 0xDEADBEEF;
    PPCODE:
        J1P(Rc_int,PJ1Array,Key);

        if ( Rc_int ) {
            XPUSHs(sv_2mortal(newSVuv(Key)));
        }

void
lj1_FirstEmpty( PJ1Array_sv, Key )
        SV *PJ1Array_sv
        UV Key
    INIT:
        Pvoid_t PJ1Array = (Pvoid_t)(SvOK(PJ1Array_sv) ? SvUV(PJ1Array_sv) : 0);
        int Rc_int = 0xDEADBEEF;
    PPCODE:
        J1FE(Rc_int,PJ1Array,Key);

        if ( Rc_int ) {
            XPUSHs(sv_2mortal(newSVuv(Key)));
        }


void
lj1_NextEmpty( PJ1Array_sv, Key )
        SV *PJ1Array_sv
        UV Key
    INIT:
        Pvoid_t PJ1Array = (Pvoid_t)(SvOK(PJ1Array_sv) ? SvUV(PJ1Array_sv) : 0);
        int Rc_int = 0xDEADBEEF;
    PPCODE:
        JLNE(Rc_int,PJ1Array,Key);

        if ( Rc_int ) {
            XPUSHs(sv_2mortal(newSVuv(Key)));
        }

void
lj1_LastEmpty( PJ1Array_sv, Key )
        SV *PJ1Array_sv
        UV Key
    INIT:
        Pvoid_t PJ1Array = (Pvoid_t)(SvOK(PJ1Array_sv) ? SvUV(PJ1Array_sv) : 0);
        int Rc_int = 0xDEADBEEF;
    PPCODE:
        JLLE(Rc_int,PJ1Array,Key);

        if ( Rc_int ) {
            XPUSHs(sv_2mortal(newSVuv(Key)));
        }

void
lj1_PrevEmpty( PJ1Array_sv, Key )
        SV *PJ1Array_sv
        UV Key
    INIT:
        Pvoid_t PJ1Array = (Pvoid_t)(SvOK(PJ1Array_sv) ? SvUV(PJ1Array_sv) : 0);
        int Rc_int = 0xDEADBEEF;
    PPCODE:
        JLPE(Rc_int,PJ1Array,Key);

        if ( Rc_int ) {
            XPUSHs(sv_2mortal(newSVuv(Key)));
        }

MODULE = Judy::HS PACKAGE = Judy::HS PREFIX = ljhs_

