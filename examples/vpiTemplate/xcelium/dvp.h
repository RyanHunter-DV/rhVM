#ifndef dvp__h
#define dvp__h

#include "vpi_user.h"
#include "stdio.h"

// macros for dvp
//
#define DVP_INT_VALUE_CHANGED 1

///////////////

class DVProbe {

public:

	DVProbe() {
		__size = 0;
		__index= 0;
		__cbdata = NULL;
	}
	void detector(const char* hier,int event,int (*cb)(struct t_cb_data*));
	p_cb_data* vpiCallbacks();
	int vpiCallbackNumber();
	void run(void (*dvpUser)(DVProbe*));

private:

	p_cb_data* __cbdata;
	int __size;
	int __index;


};


#endif
