#ifndef dvpBuiltIns__h
#define dvpBuiltIns__h

#include "vpi_user.h"
#include <iostream>
using namespace std;

int reportIntValue(p_cb_data info) {
	cout<<"obj is: "<<vpi_get_str(vpiFullName,info->obj)<<endl;
	cout<<"changed value is: "<<info->value->value.integer<<endl;
	cout<<"changed time is: "<<info->time->low<<endl;
	return 0;
}



#endif
