
SHELL = /bin/sh

.SUFFIXES:
.SUFFIXES: .cpp .o


FFTW_DIR = /usr/local/Cellar/fftw/3.3.4_1

#GNU compiler on mac
cxx        = g++
cxxflags   = -std=c++11 -O3 -Wall
libs       = -L$(FFTW_DIR)/lib -lfftw3
exedir     = ../bin/mac-gnu

#Intel compiler on raijin.nci.org.au
#cxx        = icpc
#cxxflags   = -std=c++11 -O3 -Wall -diag-disable remark
#libs       = -L$(FFTW_DIR) -lfftw3
#exedir     = ../bin/raijin-intel

srcdir     = ../src
tntdir     = ../third_party/tnt
objdir     = ./obj
includes   = -I$(srcdir) -I$(tntdir) -I$(FFTW_DIR)/include
executable = $(exedir)/gaforwardmodeltdem.so

all: compile link
allclean: clean compile link

objects = \
	$(objdir)/blocklanguage.o \
	$(objdir)/geometry3d.o \
	$(objdir)/le.o \
	$(objdir)/general_utils.o \
	$(objdir)/file_utils.o \
	$(objdir)/tdemsystem.o \
	$(objdir)/tdem1dmodel.o \
	$(objdir)/gaforwardmodeltdem.o 

$(objects): $(objdir)/%.o: $(srcdir)/%.cpp
	mkdir -p $(objdir)
	@echo ' '
	@echo Compiling $<
	$(cxx) -c $(includes) $(cxxflags) $< -o $@

compile: $(objects)

link: $(objects)
	mkdir -p $(exedir)
	@echo ' '
	@echo Linking
	$(cxx) $(objects) $(libs) -o $(executable)

clean: 
	@echo ' '
	@echo Cleaning
	rm -f $(objects)
	rm -f $(executable)
