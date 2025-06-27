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

all : install $(LIB)/lib$(libname).so

$(LIB)/lib$(libname).so.$(version): $(OBJECTS)
	$(FC) -shared -o $@ $^   

$(OBJDIR)/%.o: $(SRCDIR)/%.f90 $(OBJDIR)
	$(FC) -O3 -fpic -c -J $(INC) $< -o $@

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
	rm -r $(LIB)/lib$(libname).* $(INC)/lib$(libname).*

readme:
	pandoc -f gfm README.md -o doc/README.pdf
