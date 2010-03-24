#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

/* FIXME: omg, this is a buffer overflow. Store nothing in Judy::SL
   that is larger than this. */
#define MAXLINELEN 1000000

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
#        define PDEADBEEF (void*)0xdeadbeef
#else
#        define PDEADBEEF (void*)0xdeadbeefdeadbeef
#endif

#if LONGSIZE == 4
#        define DEADBEEF 0xdeadbeef
#else
#        define DEADBEEF 0xdeadbeefdeadbeef
#endif


int trace = 0;
#define OOGA(...)\
  do {\
    if ( trace ) {\
      PerlIO_printf(PerlIO_stdout(),__VA_ARGS__);\
      PerlIO_flush(PerlIO_stdout());\
    }\
  } while (0);




MODULE = Judy PACKAGE = Judy PREFIX = lj_

PROTOTYPES: ENABLE

=for FIXME Constants aren't used as constants. The functions are
getting called anyway.

=cut

void
trace( x )
        int x
    CODE:
        trace = x;

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
        PWord_t ptr
    CODE:
        OOGA("%s:%d Peek(0x%x)\n",__FILE__,__LINE__,ptr);
        OOGA("%s:%d *0x%x=0x",__FILE__,__LINE__,ptr);
        OOGA("%x\n",*ptr);
        RETVAL = (Word_t)*ptr;
    OUTPUT:
        RETVAL

void
Poke(ptr,v)
        Word_t *ptr
        Word_t v
    CODE:
        OOGA("%s:%d Poke(0x%x,0x%x)\n",__FILE__,__LINE__,ptr,v);
        *ptr = v;






MODULE = Judy PACKAGE = Judy::1 PREFIX = lj1_

int
lj1_Set( PJ1Array, Key )
        Pvoid_t PJ1Array
        Word_t Key
    INIT:
        int Rc_int = DEADBEEF;
    CODE:
        OOGA("%s:%d  J1S(0x%x,0x%x,0x%x)\n",__FILE__,__LINE__,Rc_int,PJ1Array,Key);
        J1S(Rc_int,PJ1Array,Key);
        OOGA("%s:%d .J1S(0x%x,0x%x,0x%x)\n",__FILE__,__LINE__,Rc_int,PJ1Array,Key);

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
        OOGA("%s:%d  J1U(0x%x,0x%x,0x%x)\n",__FILE__,__LINE__,Rc_int,PJ1Array,Key);
        J1U(Rc_int,PJ1Array,Key);
        OOGA("%s:%d .J1U(0x%x,0x%x,0x%x)\n",__FILE__,__LINE__,Rc_int,PJ1Array,Key);

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
        OOGA("%s:%d  J1T(0x%x,0x%x,0x%x)\n",__FILE__,__LINE__,Rc_int,PJ1Array,Key);
        J1T(Rc_int,PJ1Array,Key);
        OOGA("%s:%d .J1T(0x%x,0x%x,0x%x)\n",__FILE__,__LINE__,Rc_int,PJ1Array,Key);
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
        OOGA("%s:%d Judy1Count(0x%x,0x%x,0x%x,0x%x)\n",__FILE__,__LINE__,PJ1Array,Key1,Key2,&JError);
        Rc_word = Judy1Count(PJ1Array,Key1,Key2,&JError);
        OOGA("%s:%d Judy1Count(0x%x,0x%x,0x%x,0x%x)\n",__FILE__,__LINE__,PJ1Array,Key1,Key2,&JError);
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
        OOGA("%s:%d  J1BC(0x%x,0x%x,0x%x,0x%x)\n",__FILE__,__LINE__,Rc_int,PJ1Array,Nth,Index);
        J1BC(Rc_int,PJ1Array,Nth,Index);
        OOGA("%s:%d .J1BC(0x%x,0x%x,0x%x,0x%x)\n",__FILE__,__LINE__,Rc_int,PJ1Array,Nth,Index);

        if ( Rc_int ) {
            XPUSHs(sv_2mortal(newSViv(Index)));
        }

Word_t
lj1_Free( PJ1Array )
        Pvoid_t PJ1Array
    INIT:
        Word_t Rc_word = DEADBEEF;
    CODE:
        OOGA("%s:%d  J1FA(0x%x,0x%x)\n",__FILE__,__LINE__,Rc_word,PJ1Array);
        J1FA(Rc_word,PJ1Array);
        OOGA("%s:%d .J1FA(0x%x,0x%x)\n",__FILE__,__LINE__,Rc_word,PJ1Array);
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
        OOGA("%s:%d  J1F(0x%x,0x%x,0x%x)\n",__FILE__,__LINE__,Rc_int,PJ1Array,Key);
        J1F(Rc_int,PJ1Array,Key);
        OOGA("%s:%d .J1F(0x%x,0x%x,0x%x)\n",__FILE__,__LINE__,Rc_int,PJ1Array,Key);

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
        OOGA("%s:%d  J1N(0x%x,0x%x,0x%x)\n",__FILE__,__LINE__,Rc_int,PJ1Array,Key);
        J1N(Rc_int,PJ1Array,Key);
        OOGA("%s:%d .J1N(0x%x,0x%x,0x%x)\n",__FILE__,__LINE__,Rc_int,PJ1Array,Key);

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
        OOGA("%s:%d  J1L(0x%x,0x%x,0x%x)\n",__FILE__,__LINE__,Rc_int,PJ1Array,Key);
        J1L(Rc_int,PJ1Array,Key);
        OOGA("%s:%d .J1L(0x%x,0x%x,0x%x)\n",__FILE__,__LINE__,Rc_int,PJ1Array,Key);

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
        OOGA("%s:%d  J1P(0x%x,0x%x,0x%x)\n",__FILE__,__LINE__,Rc_int,PJ1Array,Key);
        J1P(Rc_int,PJ1Array,Key);
        OOGA("%s:%d .J1P(0x%x,0x%x,0x%x)\n",__FILE__,__LINE__,Rc_int,PJ1Array,Key);

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
        OOGA("%s:%d  J1FE(0x%x,0x%x,0x%x)\n",__FILE__,__LINE__,Rc_int,PJ1Array,Key);
        J1FE(Rc_int,PJ1Array,Key);
        OOGA("%s:%d .J1FE(0x%x,0x%x,0x%x)\n",__FILE__,__LINE__,Rc_int,PJ1Array,Key);

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
        OOGA("%s:%d  J1NE(0x%x,0x%x,0x%x)\n",__FILE__,__LINE__,Rc_int,PJ1Array,Key);
        J1NE(Rc_int,PJ1Array,Key);
        OOGA("%s:%d .J1NE(0x%x,0x%x,0x%x)\n",__FILE__,__LINE__,Rc_int,PJ1Array,Key);

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
        OOGA("%s:%d  J1LE(0x%x,0x%x,0x%x)\n",__FILE__,__LINE__,Rc_int,PJ1Array,Key);
        J1LE(Rc_int,PJ1Array,Key);
        OOGA("%s:%d .J1LE(0x%x,0x%x,0x%x)\n",__FILE__,__LINE__,Rc_int,PJ1Array,Key);

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
        OOGA("%s:%d  J1PE(0x%x,0x%x,0x%x)\n",__FILE__,__LINE__,Rc_int,PJ1Array,Key);
        J1PE(Rc_int,PJ1Array,Key);
        OOGA("%s:%d .J1PE(0x%x,0x%x,0x%x)\n",__FILE__,__LINE__,Rc_int,PJ1Array,Key);

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
        OOGA("%s:%d  JLI(0x%x,0x%x,0x%x)\n",__FILE__,__LINE__,PValue,PJLArray,Key);
        JLI(PValue,PJLArray,Key);
        OOGA("%s:%d .JLI(0x%x,0x%x,0x%x)\n",__FILE__,__LINE__,PValue,PJLArray,Key);
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
        OOGA("%s:%d  JLD(0x%x,0x%x,0x%x)\n",__FILE__,__LINE__,Rc_int,PJLArray,Key);
        JLD(Rc_int,PJLArray,Key);
        OOGA("%s:%d .JLD(0x%x,0x%x,0x%x)\n",__FILE__,__LINE__,Rc_int,PJLArray,Key);
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
        OOGA("%s:%d  JLG(0x%x,0x%x,0x%x)\n",__FILE__,__LINE__,PValue,PJLArray,Key);
        JLG(PValue,PJLArray,Key);
        OOGA("%s:%d .JLG(0x%x,0x%x,0x%x)\n",__FILE__,__LINE__,PValue,PJLArray,Key);

        if ( PValue ) {
            OOGA("%s:%d *0x%x,0x",__FILE__,__LINE__,PValue);
            OOGA("%x)\n",*PValue);
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
        OOGA("%s:%d  JLC(0x%x,0x%x,0x%x,0x%x)\n",__FILE__,__LINE__,Rc_word,PJLArray,Key1,Key2);
        JLC(Rc_word,PJLArray,Key1,Key2);
        OOGA("%s:%d .JLC(0x%x,0x%x,0x%x,0x%x)\n",__FILE__,__LINE__,Rc_word,PJLArray,Key1,Key2);

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
        OOGA("%s:%d  JLBC(0x%x,0x%x,%d,0x%x)\n",__FILE__,__LINE__,Rc_word,PJLArray,Nth,Index);
        JLBC(PValue,PJLArray,Nth,Index);
        OOGA("%s:%d .JLBC(0x%x,0x%x,%d,0x%x)\n",__FILE__,__LINE__,Rc_word,PJLArray,Nth,Index);

        if ( PValue ) {
            OOGA("%s:%d *0x%x=0x",__FILE__,__LINE__,PValue);
            OOGA("%x)\n",*PValue);
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
        OOGA("%s:%d  JLFA(0x%x,0x%x)\n",__FILE__,__LINE__,Rc_word,PJLArray);
        JLFA(Rc_word,PJLArray);
        OOGA("%s:%d .JLFA(0x%x,0x%x)\n",__FILE__,__LINE__,Rc_word,PJLArray);

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
        OOGA("%s:%d  JLMU(0x%x,0x%x,0x%x)\n",__FILE__,__LINE__,Rc_word,PJLArray);
        JLMU(Rc_word,PJLArray);
        OOGA("%s:%d .JLMU(0x%x,0x%x,0x%x)\n",__FILE__,__LINE__,Rc_word,PJLArray);

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
        OOGA("%s:%d  JLF(0x%x,0x%x,0x%x)\n",__FILE__,__LINE__,PValue,PJLArray,Key);
        JLF(PValue,PJLArray,Key);
        OOGA("%s:%d .JLF(0x%x,0x%x,0x%x)\n",__FILE__,__LINE__,PValue,PJLArray,Key);

        if ( PValue ) {
            OOGA("%s:%d *0x%x=0x",__FILE__,__LINE__,PValue);
            OOGA("%x)\n",*PValue);
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
        OOGA("%s:%d  JLN(0x%x,0x%x,0x%x)\n",__FILE__,__LINE__,PValue,PJLArray,Key);
        JLN(PValue,PJLArray,Key);
        OOGA("%s:%d .JLN(0x%x,0x%x,0x%x)\n",__FILE__,__LINE__,PValue,PJLArray,Key);

        if ( PValue ) {
            OOGA("%s:%d *0x%x=0x",__FILE__,__LINE__,PValue);
            OOGA("%x\n",*PValue);
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
        OOGA("%s:%d  JLL(0x%x,0x%x,0x%x)\n",__FILE__,__LINE__,PValue,PJLArray,Key);
        JLL(PValue,PJLArray,Key);
        OOGA("%s:%d .JLL(0x%x,0x%x,0x%x)\n",__FILE__,__LINE__,PValue,PJLArray,Key);

        if ( PValue ) {
            OOGA("%s:%d *0x%x=0x",__FILE__,__LINE__,PValue);
            OOGA("%x)\n",*PValue);
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
        OOGA("%s:%d  JLP(0x%x,0x%x,0x%x)\n",__FILE__,__LINE__,PValue,PJLArray,Key);
        JLP(PValue,PJLArray,Key);
        OOGA("%s:%d .JLP(0x%x,0x%x,0x%x)\n",__FILE__,__LINE__,PValue,PJLArray,Key);

        if ( PValue ) {
            OOGA("%s:%d *0x%x=0x",__FILE__,__LINE__,PValue);
            OOGA("%x)\n",*PValue);
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
        OOGA("%s:%d  JLFE(0x%x,0x%x,0x%x)\n",__FILE__,__LINE__,Rc_int,PJLArray,Key);
        JLFE(Rc_int,PJLArray,Key);
        OOGA("%s:%d .JLFE(0x%x,0x%x,0x%x)\n",__FILE__,__LINE__,Rc_int,PJLArray,Key);

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
        OOGA("%s:%d  JLNE(0x%x,0x%x,0x%x)\n",__FILE__,__LINE__,Rc_int,PJLArray,Key);
        JLNE(Rc_int,PJLArray,Key);
        OOGA("%s:%d .JLNE(0x%x,0x%x,0x%x)\n",__FILE__,__LINE__,Rc_int,PJLArray,Key);

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
        OOGA("%s:%d  JLLE(0x%x,0x%x,0x%x)\n",__FILE__,__LINE__,Rc_int,PJLArray,Key);
        JLLE(Rc_int,PJLArray,Key);
        OOGA("%s:%d .JLLE(0x%x,0x%x,0x%x)\n",__FILE__,__LINE__,Rc_int,PJLArray,Key);

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
        OOGA("%s:%d  JLPE(0x%x,0x%x,0x%x)\n",__FILE__,__LINE__,Rc_int,PJLArray,Key);
        JLPE(Rc_int,PJLArray,Key);
        OOGA("%s:%d .JLPE(0x%x,0x%x,0x%x)\n",__FILE__,__LINE__,Rc_int,PJLArray,Key);

        if ( Rc_int ) {
            XPUSHs(sv_2mortal(newSVuv(Key)));
        }






MODULE = Judy PACKAGE = Judy::SL PREFIX = ljsl_

PWord_t
ljsl_Set( PJSLArray, Key, Value )
        Pvoid_t PJSLArray
        Str Key
        Word_t Value
    INIT:
        PWord_t PValue = PDEADBEEF;
        uint8_t Index[MAXLINELEN];
    CODE:
        if ( Key.length > MAXLINELEN ) {
           croak("Sorry, can't store keys longer than MAXLINELEN for now. This is a bug.");
        }
        Copy((const char* const)Key.ptr,Index,(const int)Key.length,char);
        Index[Key.length] = '\0';

        /* Cast from (char*) to (const uint8_t*) to silence a warning. */
        OOGA("%s:%d  JSLI(0x%x,0x%x,\"%s\"@0x%x)\n",__FILE__,__LINE__,(int)PValue,(int)PJSLArray,Index,(int)&Index);
        JSLI(PValue,PJSLArray,(const uint8_t* const)Index);
        OOGA("%s:%d .JSLI(0x%x,0x%x,\"%s\"@0x%x)\n",__FILE__,__LINE__,(int)PValue,(int)PJSLArray,Index,(int)&Index);

        OOGA("%s:%d *0x%x=0x",__FILE__,__LINE__,PValue);
        *PValue = Value;
        OOGA("%x)\n",*PValue);

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
        OOGA("%s:%d  JSLD(0x%x,0x%x,\"%s\"@0x%x)\n",__FILE__,__LINE__,Rc_int,PJSLArray,Key.ptr,Key.ptr);
        JSLD(Rc_int,PJSLArray,(const uint8_t*)Key.ptr);
        OOGA("%s:%d .JSLD(0x%x,0x%x,\"%s\"@0x%x)\n",__FILE__,__LINE__,Rc_int,PJSLArray,Key.ptr,Key.ptr);

        RETVAL = Rc_int;
    OUTPUT:
        PJSLArray
        RETVAL

void
ljsl_Get( PJSLArray, Key )
        Pvoid_t PJSLArray
        Str Key
    INIT:
        PWord_t PValue = PDEADBEEF;
        uint8_t Index[MAXLINELEN];
    PPCODE:
        Copy(Key.ptr,Index,Key.length,uint8_t);
        Index[Key.length] = '\0';

        /* Cast from (char*) to (const uint8_t*) to silence a warning. */
        OOGA("%s:%d PSLG(0x%x,0x%x,\"%s\"@0x%x)\n",__FILE__,__LINE__,PValue,(int)PJSLArray,Key.ptr,Key.length);
        JSLG(PValue,PJSLArray,Index);
        OOGA("%s:%d PSLG(0x%x,0x%x,\"%s\"@0x%x)\n",__FILE__,__LINE__,PValue,(int)PJSLArray,Key.ptr,Key.length);

        if ( PValue ) {
            OOGA("%s:%d *0x%x=0x",__FILE__,__LINE__,PValue);
            OOGA("%x)\n",*PValue);
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
        OOGA("%s:%d  JSLFA(0x%x,0x%x)\n",__FILE__,__LINE__,Rc_word,(int)PJSLArray);
        JSLFA(Rc_word,PJSLArray);
        OOGA("%s:%d .JSLFA(0x%x,0x%x)\n",__FILE__,__LINE__,Rc_word,(int)PJSLArray);

        RETVAL = Rc_word;
    OUTPUT:
        PJSLArray
        RETVAL

void
ljsl_First( PJSLArray, Key )
        Pvoid_t PJSLArray
        Str Key
    INIT:
        PWord_t PValue  = PDEADBEEF;
        uint8_t Index[MAXLINELEN];
    PPCODE:
        /* Copy Index because it is both input and output. */
        Copy(Key.ptr,Index,Key.length,uint8_t);
        Index[Key.length] = '\0';

        /* Cast from (char*) to (uint8_t*) to silence a warning. */ 
        OOGA("%s:%d  JSLF(0x%x,0x%x,\"%s\"@0x%x)\n",__FILE__,__LINE__,PValue,(int)PJSLArray,Index,Index);
        JSLF(PValue,PJSLArray,Index);
        OOGA("%s:%d .JSLF(0x%x,0x%x,\"%s\"@0x%x)\n",__FILE__,__LINE__,PValue,(int)PJSLArray,Index,Index);

        if ( PValue ) {
            OOGA("%s:%d *0x%x=0x",__FILE__,__LINE__,PValue);
            OOGA("%x)\n",*PValue);
            EXTEND(SP,3);
            PUSHs(sv_2mortal(newSVuv(INT2PTR(UV,PValue))));
            PUSHs(sv_2mortal(newSVuv(*PValue)));
            PUSHs(sv_2mortal(newSVpv((char*)Index,0)));
        }

void
ljsl_Next( PJSLArray, Key )
        Pvoid_t PJSLArray
        Str Key
    INIT:
        PWord_t PValue = PDEADBEEF;
        uint8_t Index[MAXLINELEN];
    PPCODE:
        /* Copy Index because it is both input and output. */
        Copy(Key.ptr,Index,Key.length,uint8_t);
        Index[Key.length] = '\0';

        /* Cast from (char*) to (uint8_t*) to silence a warning. */
        OOGA("%s:%d  JSLN(0x%x,0x%x,\"%s\"@0x%x)\n",__FILE__,__LINE__,PValue,(int)PJSLArray,Index,Index);
        JSLN(PValue,PJSLArray,Index);
        OOGA("%s:%d .JSLN(0x%x,0x%x,\"%s\"@0x%x)\n",__FILE__,__LINE__,PValue,(int)PJSLArray,Index,Index);

        if ( PValue ) {
            OOGA("%s:%d *0x%x=0x",__FILE__,__LINE__,PValue);
            OOGA("%x)\n",*PValue);
            EXTEND(SP,3);
            PUSHs(sv_2mortal(newSVuv(INT2PTR(UV,PValue))));
            PUSHs(sv_2mortal(newSVuv(*PValue)));
            PUSHs(sv_2mortal(newSVpv((char*)Index,0)));
        }

void
ljsl_Last( PJSLArray, Key )
        Pvoid_t PJSLArray
        Str Key
    INIT:
        Word_t *PValue = PDEADBEEF;
        uint8_t Index[MAXLINELEN];
    PPCODE:
        /* Copy Index because it is both input and output. */
        Copy(Key.ptr,Index,Key.length,uint8_t);
        Index[Key.length] = '\0';

        /* Cast from (char*) to (uint8_t*) to silence a warning. */
        OOGA("%s:%d  JSLL(0x%x,0x%x,\"%s\"@0x%x)\n",__FILE__,__LINE__,PValue,(int)PJSLArray,Index,Index);
        JSLL(PValue,PJSLArray,Index);
        OOGA("%s:%d .JSLL(0x%x,0x%x,\"%s\"@0x%x)\n",__FILE__,__LINE__,PValue,(int)PJSLArray,Index,Index);

        if ( PValue ) {
            OOGA("%s:%d *0x%x=0x",__FILE__,__LINE__,PValue);
            OOGA("%x)\n",*PValue);
            EXTEND(SP,3);
            PUSHs(sv_2mortal(newSVuv(INT2PTR(UV,PValue))));
            PUSHs(sv_2mortal(newSVuv(*PValue)));
            PUSHs(sv_2mortal(newSVpv((char*)Index,0)));
        }

void
ljsl_Prev( PJSLArray, Key )
        Pvoid_t PJSLArray
        Str Key
    INIT:
        PWord_t PValue = PDEADBEEF;
        uint8_t Index[MAXLINELEN];
    PPCODE:
        /* Copy Index because it is both input and output. */
        Copy(Key.ptr,Index,Key.length,uint8_t);
        Index[Key.length] = '\0';

        /* Cast from (char*) to (uint8_t*) to silence a warning. */
        OOGA("%s:%d  JSLP(0x%x,0x%x,\"%s\"@0x%x)\n",__FILE__,__LINE__,PValue,(int)PJSLArray,Index,Index);
        JSLP(PValue,PJSLArray,Index);
        OOGA("%s:%d .JSLP(0x%x,0x%x,\"%s\"@0x%x)\n",__FILE__,__LINE__,PValue,(int)PJSLArray,Index,Index);

        if ( PValue ) {
            OOGA("%s:%d *0x%x=0x",__FILE__,__LINE__,PValue);
            OOGA("%x)\n",*PValue);
            EXTEND(SP,3);
            PUSHs(sv_2mortal(newSVuv(INT2PTR(UV,PValue))));
            PUSHs(sv_2mortal(newSVuv(*PValue)));
            PUSHs(sv_2mortal(newSVpv((char*)Index,0)));
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



PWord_t
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
