
#include "vpi_user.h"
#include "vpi_user_cds.h"
#include "stdio.h"

int svcMain();

static s_vpi_systf_data systfTestList[] = {
	{vpiSysTask, 0, "$svcMain", svcMain, 0,0,0},
	{0}
};

void setupVPI() {
	s_cb_data cb_data_s;
	p_vpi_systf_data systf_data_p = &(systfTestList[0]);

	while (systf_data_p->type) {
		vpi_register_systf(systf_data_p++);
		if (vpi_chk_error(NULL)) {
			vpi_printf("Error occured while setting up user %s\n",
				"defined system tasks and functions."
			);
			return;
		}
	}
}

void (*vlog_startup_routines[])() = {
	setupVPI,
	0 /*** final entry must be 0 ***/
};


#include "dvp.h"
#include <iostream>
void registerVPICallbacks(p_cb_data* cbs,int num) {
	int i = 0;
	for (i=0;i<num;i++) {
		std::cout<<"p of cbdata get: "<<*(cbs+i)<<std::endl;
		std::cout<<"reason get: "<<(*(cbs+i))->reason<<std::endl;
		vpi_register_cb(*(cbs+i));
	}
}

extern void dvpUser(DVProbe* pDvp);
int svcMain() {
	DVProbe* dvp = new DVProbe();
	dvp->run(dvpUser);
	registerVPICallbacks(dvp->vpiCallbacks(),dvp->vpiCallbackNumber());
}
