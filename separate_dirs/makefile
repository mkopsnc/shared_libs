.PHONY: clean

assert = $(if $2,$(if $1,,$(error $2)))
location = $(CURDIR)/$(word $(words $(MAKEFILE_LIST)),$(MAKEFILE_LIST))

LIBDIR=shared/$(MAJOR).$(MINOR)

all: lib exe

exe: check bin/exe_lib_ldpath_$(MAJOR)_$(MINOR) bin/exe_file_ldpath_$(MAJOR)_$(MINOR) bin/exe_file_ldpath_rpath_$(MAJOR)_$(MINOR)

check:
	$(call assert,$(MINOR),MINOR is not defined call with MINOR=#)
	$(call assert,$(MAJOR),MAJOR is not defined call with MAJOR=#)

src/shared.c: check
	@sed -e 's/@VERSION@/$(MAJOR)\.$(MINOR)/' src/shared.c.template > src/shared.c
	@echo Version is now set to $(MAJOR).$(MINOR)

obj/shared.o: src/shared.c
	@echo Compiling library code with version $(MAJOR).$(MINOR)
	gcc -fPIC -c -o obj/shared.o src/shared.c

lib: obj/shared.o
	@echo Building library with version $(MAJOR).$(MINOR)
	@mkdir -p $(LIBDIR)/lib
	gcc -shared -fpic obj/shared.o -o $(LIBDIR)/lib/libshared.so

bin/exe_lib_ldpath_$(MAJOR)_$(MINOR): src/caller.c
	gcc -o $@ $< -Iinclude -L$(LIBDIR)/lib -lshared

bin/exe_file_ldpath_$(MAJOR)_$(MINOR): src/caller.c
	gcc -o $@ $< -Iinclude $(LIBDIR)/lib/libshared.so

bin/exe_file_ldpath_rpath_$(MAJOR)_$(MINOR): src/caller.c
	gcc -o $@ $< -Iinclude -lshared -L$(LIBDIR)/lib -Wl,-rpath,$(CURDIR)/$(LIBDIR)/lib

clean:
	-rm src/shared.c
	-rm obj/*
	-rm -rf shared/*
	-rm bin/*
