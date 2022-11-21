#ifndef dvp__cpp
#define dvp__cpp

#include "dvp.h"
#include <iostream>

void DVProbe::run(void (*dvpUser)(DVProbe*)) {
	dvpUser(this);
}

void DVProbe::detector(
	const char* hier,
	int event,
	int (*cb)(struct t_cb_data*)
) {

	p_cb_data* pOrig = __cbdata;
	int origS = __size;

	__size++;
	__cbdata = new p_cb_data[__size];

	int i=0;
	for (i=0;i<origS;i++) {
		*(__cbdata+i) = *(pOrig+i);
	}
	delete [] pOrig;

	switch (event) {
		case DVP_INT_VALUE_CHANGED:
			p_vpi_value v = new s_vpi_value;
			vpiHandle oh = vpi_handle_by_name(hier,NULL);
			v->format = vpiIntVal;
			p_vpi_time t = new s_vpi_time;
			t->type = vpiSimTime;
			p_cb_data pd= new s_cb_data{cbValueChange,cb,oh,t,v,0,0};
			__cbdata[__index] = pd;
			__index++;
		break;
	}

}

p_cb_data* DVProbe::vpiCallbacks() {
	return __cbdata;
}
int DVProbe::vpiCallbackNumber() {
	return __size;
}

#endif
