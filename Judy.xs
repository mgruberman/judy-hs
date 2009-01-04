#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

/* --- hint for SvPVbyte ---
   Does not work in perl-5.6.1, ppport.h implements a version
   borrowed from perl-5.7.3. */
#define NEED_sv_2pvbyte
#include "ppport.h"

/* Redefine Judy's error handling. Judy's default is to write this
   message to stderr and exit(1). That's unfriendly to a perl
   programmer. This does roughly the same thing but since it is perl's
   own croak(), the warning can be caught.

   This redefinition must occur prior to including Judy.h */
#define JUDYERROR(CallerFile,CallerLine,JudyFunc,JudyErrno,JudyErrID) \
    croak("File '%s', line %d: %s(), JU_ERRNO_* == %d, ID == %d\n",   \
          CallerFile, CallerLine,                                     \
          JudyFunc, JudyErrno, JudyErrID);

/* Judy.h comes from Judy at http://judy.sourceforge.net and is
   automatically installed for you by Alien::Judy. If you're
   having problems, please file a bug or better, fix it
   and post the patch. */
#include "Judy.h"

/* pjudy.h includes whatever I need to share between Judy.xs and the
   test suite. */
#include "pjudy.h"

#if PTRSIZE == 4
#	define PDEADBEEF (void*)0xDEADBEEF
#else
#	define PDEADBEEF (void*)0xDEADBEEFDEADBEEF
#endif

#if LONGSIZE == 4
#	define DEADBEEF 0xDEADBEEF
#else
#	define DEADBEEF 0xDEADBEEFDEADBEEF
#endif

MODULE = Judy PACKAGE = Judy PREFIX = lj_

PROTOTYPES: ENABLE

=for FIXME Constants aren't used as constants. The functions are
getting called anyway.

=cut

Pvoid_t
lj_PJERR()
    PROTOTYPE:
    CODE:
        RETVAL = PJERR;
    OUTPUT:
        RETVAL

Word_t
lj_JLAP_INVALID()
    PROTOTYPE:
    CODE:
        RETVAL = JLAP_INVALID;
    OUTPUT:
        RETVAL

MODULE = Judy PACKAGE = Judy::Mem PREFIX = ljme_

PROTOTYPES: DISABLE

void*
ljme_String2Ptr(in)
        Str in
    INIT:
        size_t length = DEADBEEF;
        void *out = PDEADBEEF;
    CODE:
        Newx(out,in.length,char);
        Copy(in.ptr,out,in.length,char);
        RETVAL = out;
    OUTPUT:
        RETVAL

Str
ljme_Ptr2String(in)
        void *in
    CODE:
        /* Guess about the length of the string. Use Ptr2String2 if there are nulls. */
        RETVAL.ptr = in;
        RETVAL.length = 0;
    OUTPUT:
        RETVAL

Str
ljme_Ptr2String2(in,length)
        void *in
        STRLEN length
    CODE:
        RETVAL.ptr = in;
        RETVAL.length = length;
    OUTPUT:
        RETVAL

void
ljme_Free(ptr)
        void *ptr
    CODE:
        Safefree(ptr);

IV
Peek(ptr)
        Word_t *ptr
    CODE:
        RETVAL = (Word_t)*ptr;
    OUTPUT:
        RETVAL

void
Poke(ptr,v)
        Word_t *ptr
        Word_t v
    CODE:
        *ptr = v;

MODULE = Judy PACKAGE = Judy::1 PREFIX = lj1_

int
lj1_Set( PJ1Array, Key )
        Pvoid_t PJ1Array
        Word_t Key
    INIT:
        int Rc_int = DEADBEEF;
    CODE:
        J1S(Rc_int,PJ1Array,Key);

        /* OUTPUT */
        RETVAL = Rc_int;
    OUTPUT:
        PJ1Array
        RETVAL

int
lj1_Unset( PJ1Array, Key )
        Pvoid_t PJ1Array
        Word_t Key
    INIT:
        int Rc_int = DEADBEEF;
    CODE:
        J1U(Rc_int,PJ1Array,Key);

        /* OUTPUT */
        RETVAL = Rc_int;
    OUTPUT:
        PJ1Array
        RETVAL

int
lj1_Test( PJ1Array, Key )
        Pvoid_t PJ1Array
        Word_t Key
    INIT:
        int Rc_int = DEADBEEF;
    CODE:
        J1T(Rc_int,PJ1Array,Key);
        RETVAL = Rc_int;
    OUTPUT:
        PJ1Array
        RETVAL

Word_t
lj1_Count( PJ1Array, Key1, Key2 )
        Pvoid_t PJ1Array
        Word_t Key1
        Word_t Key2
    INIT:
        Word_t Rc_word = DEADBEEF;
        JError_t JError;
    CODE:
        Rc_word = Judy1Count(PJ1Array,Key1,Key2,&JError);
        if ( Rc_word ) {
            RETVAL = Rc_word;
        }
        else {
            if ( JU_ERRNO(&JError) == JU_ERRNO_NONE ) {
	    	RETVAL = 0;
            }
            else if ( JU_ERRNO(&JError) == JU_ERRNO_FULL ) {
	        /* On a 32-bit machine, this value is
                   indistinguishable from the count of 2^32. On a
                   64-bit machine, this value cannot be triggered. */
                RETVAL = ULONG_MAX;
            }
            else if ( JU_ERRNO(&JError) > JU_ERRNO_NFMAX ) {
                /* Defer to back to the default implementation for
                   error handling in the J1C macro. */
                J_E("Judy1Count",&JError);
            }
        }
    OUTPUT:
        RETVAL

void
lj1_Nth( PJ1Array, Nth )
        Pvoid_t PJ1Array
        Word_t Nth
    INIT:
        Word_t Index = DEADBEEF;
        int Rc_int = DEADBEEF;
    PPCODE:
        J1BC(Rc_int,PJ1Array,Nth,Index);

        if ( Rc_int ) {
            XPUSHs(sv_2mortal(newSViv(Index)));
        }

Word_t
lj1_Free( PJ1Array )
        Pvoid_t PJ1Array
    INIT:
        Word_t Rc_word = DEADBEEF;
    CODE:
        JLFA(Rc_word,PJ1Array);
        RETVAL = Rc_word;
    OUTPUT:
        PJ1Array
        RETVAL

Word_t
lj1_MemUsed( PJ1Array )
        Pvoid_t PJ1Array
    INIT:
        Word_t Rc_word = DEADBEEF;
    CODE:
        J1MU(Rc_word,PJ1Array);
        RETVAL = Rc_word;
    OUTPUT:
        PJ1Array
        RETVAL

void
lj1_First( PJ1Array, Key )
        Pvoid_t PJ1Array
        Word_t Key
    INIT:
        int Rc_int = DEADBEEF;
    PPCODE:
        J1F(Rc_int,PJ1Array,Key);

        if ( Rc_int ) {
            XPUSHs(sv_2mortal(newSVuv(Key)));
        }


void
lj1_Next( PJ1Array, Key )
        Pvoid_t PJ1Array
        Word_t Key
    INIT:
        int Rc_int = DEADBEEF;
    PPCODE:
        J1N(Rc_int,PJ1Array,Key);

        if ( Rc_int ) {
            XPUSHs(sv_2mortal(newSVuv(Key)));
        }



void
lj1_Last( PJ1Array, Key )
        Pvoid_t PJ1Array
        Word_t Key
    INIT:
        int Rc_int = DEADBEEF;
    PPCODE:
        J1L(Rc_int,PJ1Array,Key);

        if ( Rc_int ) {
            XPUSHs(sv_2mortal(newSVuv(Key)));
        }


void
lj1_Prev( PJ1Array, Key )
        Pvoid_t PJ1Array
        Word_t Key
    INIT:
        int Rc_int = DEADBEEF;
    PPCODE:
        J1P(Rc_int,PJ1Array,Key);

        if ( Rc_int ) {
            XPUSHs(sv_2mortal(newSVuv(Key)));
        }

void
lj1_FirstEmpty( PJ1Array, Key )
        Pvoid_t PJ1Array
        Word_t Key
    INIT:
        int Rc_int = DEADBEEF;
    PPCODE:
        J1FE(Rc_int,PJ1Array,Key);

        if ( Rc_int ) {
            XPUSHs(sv_2mortal(newSVuv(Key)));
        }


void
lj1_NextEmpty( PJ1Array, Key )
        Pvoid_t PJ1Array
        Word_t Key
    INIT:
        int Rc_int = DEADBEEF;
    PPCODE:
        JLNE(Rc_int,PJ1Array,Key);

        if ( Rc_int ) {
            XPUSHs(sv_2mortal(newSVuv(Key)));
        }

void
lj1_LastEmpty( PJ1Array, Key )
        Pvoid_t PJ1Array
        Word_t Key
    INIT:
        int Rc_int = DEADBEEF;
    PPCODE:
        JLLE(Rc_int,PJ1Array,Key);

        if ( Rc_int ) {
            XPUSHs(sv_2mortal(newSVuv(Key)));
        }

void
lj1_PrevEmpty( PJ1Array, Key )
        Pvoid_t PJ1Array
        Word_t Key
    INIT:
        int Rc_int = DEADBEEF;
    PPCODE:
        JLPE(Rc_int,PJ1Array,Key);

        if ( Rc_int ) {
            XPUSHs(sv_2mortal(newSVuv(Key)));
        }

MODULE = Judy PACKAGE = Judy::L PREFIX = ljl_

Word_t*
ljl_Set( PJLArray, Key, Value )
        Pvoid_t PJLArray
        Word_t Key
        Word_t Value
    INIT:
        Word_t *PValue = PDEADBEEF;
    CODE:
        JLI(PValue,PJLArray,Key);
        *PValue = Value;
        RETVAL = PValue;
    OUTPUT:
        PJLArray
        RETVAL


int
ljl_Delete( PJLArray, Key )
        Pvoid_t PJLArray
        Word_t Key
    INIT:
        int Rc_int = DEADBEEF;
    CODE:
        JLD(Rc_int,PJLArray,Key);
        RETVAL = Rc_int;
    OUTPUT:
        PJLArray
        RETVAL

void
ljl_Get( PJLArray, Key )
        Pvoid_t PJLArray
        Word_t Key
    INIT:
        Word_t *PValue = PDEADBEEF;
    PPCODE:
        JLG(PValue,PJLArray,Key);

        if ( PValue ) {
            EXTEND(SP,2);
            PUSHs(sv_2mortal(newSVuv(INT2PTR(UV,PValue))));
            PUSHs(sv_2mortal(newSVuv(*PValue)));
        }

Word_t
ljl_Count( PJLArray, Key1, Key2 )
        Pvoid_t PJLArray
        Word_t Key1
        Word_t Key2
    INIT:
        Word_t Rc_word = DEADBEEF;
    CODE:
        JLC(Rc_word,PJLArray,Key1,Key2);
        RETVAL = Rc_word;
    OUTPUT:
        RETVAL

void
ljl_Nth( PJLArray, Nth )
        Pvoid_t PJLArray
        Word_t Nth
    INIT:
        Word_t Rc_word = DEADBEEF;
        Word_t Index = DEADBEEF;
        Word_t *PValue = PDEADBEEF;
    PPCODE:
        JLBC(PValue,PJLArray,Nth,Index);

        if ( PValue ) {
            EXTEND(SP,3);
            PUSHs(sv_2mortal(newSVuv(INT2PTR(UV,PValue))));
            PUSHs(sv_2mortal(newSVuv(*PValue)));
            PUSHs(sv_2mortal(newSVuv(Index)));
        }

Word_t
ljl_Free( PJLArray )
        Pvoid_t PJLArray
    INIT:
        Word_t Rc_word = DEADBEEF;
    CODE:
        JLFA(Rc_word,PJLArray);
        RETVAL = Rc_word;
    OUTPUT:
        PJLArray
        RETVAL

Word_t
ljl_MemUsed( PJLArray )
        Pvoid_t PJLArray
    INIT:
        Word_t Rc_word = DEADBEEF;
    CODE:
        JLMU(Rc_word,PJLArray);
        RETVAL = Rc_word;
    OUTPUT:
        RETVAL

void
ljl_First( PJLArray, Key )
        Pvoid_t PJLArray
        Word_t Key
    INIT:
        Word_t *PValue = PDEADBEEF;
    PPCODE:
        JLF(PValue,PJLArray,Key);

        if ( PValue ) {
            EXTEND(SP,3);
            PUSHs(sv_2mortal(newSVuv(INT2PTR(UV,PValue))));
            PUSHs(sv_2mortal(newSVuv(*PValue)));
	    PUSHs(sv_2mortal(newSVuv(Key)));
        }


void
ljl_Next( PJLArray, Key )
        Pvoid_t PJLArray
        Word_t Key
    INIT:
        Word_t *PValue = PDEADBEEF;
    PPCODE:
        JLN(PValue,PJLArray,Key);

        if ( PValue ) {
            EXTEND(SP,3);
            PUSHs(sv_2mortal(newSVuv(INT2PTR(UV,PValue))));
            PUSHs(sv_2mortal(newSVuv(*PValue)));
	    PUSHs(sv_2mortal(newSVuv(Key)));
        }



void
ljl_Last( PJLArray, Key )
        Pvoid_t PJLArray
        Word_t Key
    INIT:
        Word_t *PValue = PDEADBEEF;
    PPCODE:
        JLL(PValue,PJLArray,Key);

        if ( PValue ) {
            EXTEND(SP,3);
            PUSHs(sv_2mortal(newSVuv(INT2PTR(UV,PValue))));
            PUSHs(sv_2mortal(newSVuv(*PValue)));
	    PUSHs(sv_2mortal(newSVuv(Key)));
        }


void
ljl_Prev( PJLArray, Key )
        Pvoid_t PJLArray
        Word_t Key
    INIT:
        Word_t *PValue = PDEADBEEF;
    PPCODE:
        JLP(PValue,PJLArray,Key);

        if ( PValue ) {
            EXTEND(SP,3);
            PUSHs(sv_2mortal(newSVuv(INT2PTR(UV,PValue))));
            PUSHs(sv_2mortal(newSVuv(*PValue)));
	    PUSHs(sv_2mortal(newSVuv(Key)));
        }

void
ljl_FirstEmpty( PJLArray, Key )
        Pvoid_t PJLArray
        Word_t Key
    INIT:
        int Rc_int = DEADBEEF;
    PPCODE:
        JLFE(Rc_int,PJLArray,Key);

        if ( Rc_int ) {
            XPUSHs(sv_2mortal(newSVuv(Key)));
        }


void
ljl_NextEmpty( PJLArray, Key )
        Pvoid_t PJLArray
        Word_t Key
    INIT:
        int Rc_int = DEADBEEF;
    PPCODE:
        JLNE(Rc_int,PJLArray,Key);

        if ( Rc_int ) {
            XPUSHs(sv_2mortal(newSVuv(Key)));
        }

void
ljl_LastEmpty( PJLArray, Key )
        Pvoid_t PJLArray
        Word_t Key
    INIT:
        int Rc_int = DEADBEEF;
    PPCODE:
        JLLE(Rc_int,PJLArray,Key);

        if ( Rc_int ) {
            XPUSHs(sv_2mortal(newSVuv(Key)));
        }

void
ljl_PrevEmpty( PJLArray, Key )
        Pvoid_t PJLArray
        Word_t Key
    INIT:
        int Rc_int = DEADBEEF;
    PPCODE:
        JLPE(Rc_int,PJLArray,Key);

        if ( Rc_int ) {
            XPUSHs(sv_2mortal(newSVuv(Key)));
        }

MODULE = Judy PACKAGE = Judy::SL PREFIX = ljsl_

Word_t*
ljsl_Set( PJSLArray, Key, Value )
        Pvoid_t PJSLArray
        Str Key
        Word_t Value
    INIT:
        Word_t *PValue = PDEADBEEF;
    CODE:
        /* Cast from (char*) to (const uint8_t*) to silence a warning. */
        JSLI(PValue,PJSLArray,(const uint8_t*)Key.ptr);
        *PValue = Value;
        RETVAL = PValue;
    OUTPUT:
        PJSLArray
        RETVAL

int
ljsl_Delete( PJSLArray, Key )
        Pvoid_t PJSLArray
        Str Key
    INIT:
        int Rc_int = DEADBEEF;
    CODE:
        /* Cast from (char*) to (const uint8_t*) to silence a warning. */
        JSLD(Rc_int,PJSLArray,(const uint8_t*)Key.ptr);
        RETVAL = Rc_int;
    OUTPUT:
        PJSLArray
        RETVAL

void
ljsl_Get( PJSLArray, Key )
        Pvoid_t PJSLArray
        Str Key
    INIT:
        Word_t *PValue = PDEADBEEF;
    PPCODE:
        /* Cast from (char*) to (const uint8_t*) to silence a warning. */
        JSLG(PValue,PJSLArray,(const uint8_t*)Key.ptr);

        if ( PValue ) {
            EXTEND(SP,2);
            PUSHs(sv_2mortal(newSVuv(INT2PTR(UV,PValue))));
            PUSHs(sv_2mortal(newSVuv(*PValue)));
        }

Word_t
ljsl_Free( PJSLArray )
        Pvoid_t PJSLArray
    INIT:
        Word_t Rc_word = DEADBEEF;
    CODE:
        JSLFA(Rc_word,PJSLArray);
        RETVAL = Rc_word;
    OUTPUT:
        PJSLArray
        RETVAL

void
ljsl_First( PJSLArray, Key )
        Pvoid_t PJSLArray
        Str Key
    INIT:
        Word_t *PValue = PDEADBEEF;
    PPCODE:
        /* Cast from (char*) to (uint8_t*) to silence a warning. */
        JSLF(PValue,PJSLArray,(uint8_t*)Key.ptr);

        if ( PValue ) {
            EXTEND(SP,3);
            PUSHs(sv_2mortal(newSVuv(INT2PTR(UV,PValue))));
            PUSHs(sv_2mortal(newSVuv(*PValue)));
	    PUSHs(sv_2mortal(newSVpv(Key.ptr,0)));
        }

void
ljsl_Next( PJSLArray, Key )
        Pvoid_t PJSLArray
        Str Key
    INIT:
        Word_t *PValue = PDEADBEEF;
    PPCODE:
        /* Cast from (char*) to (uint8_t*) to silence a warning. */
        JSLN(PValue,PJSLArray,(uint8_t*)Key.ptr);

        if ( PValue ) {
            EXTEND(SP,3);
            PUSHs(sv_2mortal(newSVuv(INT2PTR(UV,PValue))));
            PUSHs(sv_2mortal(newSVuv(*PValue)));
	    PUSHs(sv_2mortal(newSVpv(Key.ptr,0)));
        }

void
ljsl_Last( PJSLArray, Key )
        Pvoid_t PJSLArray
        Str Key
    INIT:
        Word_t *PValue = PDEADBEEF;
    PPCODE:
        /* Cast from (char*) to (uint8_t*) to silence a warning. */
        JSLL(PValue,PJSLArray,(uint8_t*)Key.ptr);

        if ( PValue ) {
            EXTEND(SP,3);
            PUSHs(sv_2mortal(newSVuv(INT2PTR(UV,PValue))));
            PUSHs(sv_2mortal(newSVuv(*PValue)));
	    PUSHs(sv_2mortal(newSVpv(Key.ptr,0)));
        }

void
ljsl_Prev( PJSLArray, Key )
        Pvoid_t PJSLArray
        Str Key
    INIT:
        Word_t *PValue = PDEADBEEF;
    PPCODE:
        /* Cast from (char*) to (uint8_t*) to silence a warning. */
        JSLP(PValue,PJSLArray,(uint8_t*)Key.ptr);

        if ( PValue ) {
            EXTEND(SP,3);
            PUSHs(sv_2mortal(newSVuv(INT2PTR(UV,PValue))));
            PUSHs(sv_2mortal(newSVuv(*PValue)));
	    PUSHs(sv_2mortal(newSVpv(Key.ptr,0)));
        }

MODULE = Judy PACKAGE = Judy::HS PREFIX = ljhs_

Word_t
ljhs_Duplicates( PJHSArray, Key )
        Pvoid_t PJHSArray
        Str Key
    INIT:
        Word_t *PValue = PDEADBEEF;
    CODE:
        JHSI(PValue,PJHSArray,Key.ptr,Key.length);
        RETVAL = *PValue;
        ++*PValue;
    OUTPUT:
        PJHSArray
        RETVAL



Word_t*
ljhs_Set( PJHSArray, Key, Value )
        Pvoid_t PJHSArray
        Str Key
        Word_t Value
    INIT:
        Word_t  *PValue = PDEADBEEF;
    CODE:
        JHSI(PValue,PJHSArray,Key.ptr,Key.length);
        *PValue = Value;
        RETVAL = PValue;
    OUTPUT:
        PJHSArray
        RETVAL

int
ljhs_Delete( PJHSArray, Key )
        Pvoid_t PJHSArray
        Str Key
    INIT:
        int Rc_int = DEADBEEF;
    CODE:
        JHSD(Rc_int,PJHSArray,Key.ptr,Key.length);
        RETVAL = Rc_int;
    OUTPUT:
        PJHSArray
        RETVAL

void
ljhs_Get( PJHSArray, Key )
        Pvoid_t PJHSArray
        Str Key
    INIT:
        Word_t *PValue = PDEADBEEF;
    PPCODE:
        JHSG(PValue,PJHSArray,Key.ptr,Key.length);

        /* OUTPUT */
        if ( PValue ) {
            EXTEND(SP,2);
            PUSHs(sv_2mortal(newSVuv(INT2PTR(UV,PValue))));
            PUSHs(sv_2mortal(newSVuv(*PValue)));
        }

Word_t
ljhs_Free( PJHSArray )
        Pvoid_t PJHSArray
    INIT:
        Word_t Rc_word = DEADBEEF;
    CODE:
        JHSFA(Rc_word,PJHSArray);
        RETVAL = Rc_word;
    OUTPUT:
        PJHSArray
        RETVAL

MODULE = Judy PACKAGE = Judy PREFIX = lj_

=pod

Switch back to the Judy

=cut