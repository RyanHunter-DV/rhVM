#ifndef dvpUser__cpp
#define dvpUser__cpp

#include "dvp.h"
#include "dvpBuiltIns.h"


void dvpUser(DVProbe* pDvp) {
	pDvp->detector("top.ia",DVP_INT_VALUE_CHANGED,&reportIntValue);
	pDvp->detector("top.clk",DVP_INT_VALUE_CHANGED,&reportIntValue);
}


#endif
