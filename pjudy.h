#include <string.h>

typedef struct {
	char *ptr;
	STRLEN length;
} Str;

Word_t
pvtJudyHSMemUsedV(Pvoid_t PJLArray, Word_t remainingLength, Word_t keyLength );

Word_t
pvtJudyHSMemUsed( Pvoid_t PJHSArray );
