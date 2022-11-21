LIBPATH := ${CDS_INST_DIR}/tools.lnx86/include

build: objs link

xbuild: ncvlog_lib compile elab

ncvlog_lib:
	mkdir ncvlog_lib

run: sim

link:
	g++ -fPIC -shared -o libvpi.so svcMain.o dvp.o dvpUser.o

objs: svcMain.o dvp.o dvpUser.o

svcMain.o: svcMain.cpp
	g++ -c -fPIC -fpermissive -I${LIBPATH} -I. svcMain.cpp -o svcMain.o
dvp.o: dvp.cpp dvp.h
	g++ -c -fPIC -fpermissive -I${LIBPATH} -I. dvp.cpp -o dvp.o

dvpUser.o: dvpUser.cpp dvpBuiltIns.h
	g++ -c -fPIC -fpermissive -I${LIBPATH} -I. dvpUser.cpp -o dvpUser.o


##show_memwd: show_memwd.cpp
##	g++ -c -fPIC -I ${LIBPATH} show_memwd.cpp -o show_memwd.o
##vpi_user: vpi_user.cpp
##	g++ -fpermissive -fPIC -c -I ${LIBPATH} vpi_user.cpp -o vpi_user.o

compile:
	xmvlog -64BIT -SV top.sv -LOGFILE xmvlog.log


DEFAULT_LIBPATH = /grid/common/pkgs/gcc/v4.8.3/lib:/grid/common/pkgs/gcc/v4.8.3/lib64:$(CDS_INST_DIR)/tools/inca/lib:$(CDS_INST_DIR)/tools/lib:$(CDS_INST_DIR)/tools/lib/64bit
EXPORT_LIB_PATH = LD_LIBRARY_PATH="./:$(DEFAULT_LIBPATH)"; export LD_LIBRARY_PATH

elab:
	-$(EXPORT_LIB_PATH); xmelab -64BIT -ACCWARN -LIBNAME ncvlog_lib -LOGFILE xmelab.log -access +RWC ncvlog_lib.top -SNAPSHOT ncvlog_lib.ncvlog_lib:ncvlog_lib

sim:
	-$(EXPORT_LIB_PATH); xmsim -64BIT -NOCOPYRIGHT -ACCWARN -RUN -LOGFILE xmsim.log ncvlog_lib.ncvlog_lib:ncvlog_lib
clean:
	rm -rf *.o *.so *.log ncvlog_lib/
