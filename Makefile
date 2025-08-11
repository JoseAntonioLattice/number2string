libname = num2str
FC = gfortran
major = 0
minor = 1
release = 0
version = $(major).$(minor).$(release)
SRCDIR = src
OBJDIR = obj
BUILD = build
SOURCE = number2string.f90

OBJECTS = $(patsubst %.f90, $(OBJDIR)/%.o, $(SOURCE))
LIB = $(HOME)/Fortran/lib
INC = $(HOME)/Fortran/include
.PHONY : install all test readme cleanlib


all : install compile $(LIB)/lib$(libname).so


$(LIB)/lib$(libname).so.$(version): $(OBJDIR)/number2string.o
	$(FC) -shared -o $@ $^   


compile: $(SRCDIR)/number2string.f90
	$(FC) -O3 -fpic -c -J $(INC) $< -o $(OBJDIR)/number2string.o


$(LIB)/lib$(libname).so.$(major) : $(LIB)/lib$(libname).so.$(version)
	ln -s $< $@

$(LIB)/lib$(libname).so : $(LIB)/lib$(libname).so.$(major)
	ln -s $< $@

$(OBJDIR):
	mkdir -p $@

run_test : $(BUILD)
	$(FC) -I $(INC) test/test.f90 -o $(BUILD)/$@ -L $(LIB) -l$(libname)
	LD_LIBRARY_PATH=$(LIB) $(BUILD)/$@

install:
	./install.sh

$(BUILD):
	mkdir -p $@

cleanlib:
	rm -r $(LIB)/lib$(libname).* $(INC)/number2string.*

readme:
	pandoc -f gfm README.md -o doc/README.pdf
