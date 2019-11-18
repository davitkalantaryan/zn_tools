#
# File doocs_names.pro
# File created : 18 Nov 2019
# Created by : Davit Kalantaryan (davit.kalantaryan@desy.de)
# This file can be used to produce Makefile for doocs_names mex file
#

TEMPLATE = lib

win32{

} else {

    GCCPATH = $$system(which gcc)
    message("!!!!!!!!!!! GCCPATH=$$GCCPATH")
    QMAKE_CXXFLAGS += -std=c++11
    INCLUDEPATH += /afs/ifh.de/group/pitz/doocs/lib/include
    LIBS += -L/afs/ifh.de/group/pitz/doocs/lib

}


message("!!!!!!!!!!! doocs_names.pro  creating MEX")
include( $${PWD}/../../../contrib/matlab/prj/common/common_qt/matlab_matrix_without_libs_common.pri )
LIBS += -lDOOCSapi
LIBS += -lldap

#LIBS += -L$${PWD}/../../../sys/$$CODENAME/lib
#LIBS += -lpitz_daq_data_matlab

QT -= gui
QT -= core
QT -= widgets
CONFIG -= qt

INCLUDEPATH += $${PWD}/../../../include
INCLUDEPATH += $${PWD}/../../../src/include_p

SOURCES += \
    $${PWD}/../../../src/mtools/doocs_names.cpp

HEADERS += \
    $${PWD}/../../../include/zn_tools_internal.h
