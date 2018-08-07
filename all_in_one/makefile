.PHONY: clean

assert = $(if $2,$(if $1,,$(error $2)))
location = $(CURDIR)/$(word $(words $(MAKEFILE_LIST)),$(MAKEFILE_LIST))

all: lib exe

exe: bin/exe_lib_ldpath bin/exe_file_ldpath bin/exe_lib_rpath bin/exe_file_rpath bin/exe_file_ldpath_rpath

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
	gcc -shared -fpic -Wl,-soname,libshared.so.$(MAJOR).$(MINOR) obj/shared.o -o lib/libshared.so.$(MAJOR).$(MINOR)
	@ln -s -f libshared.so.$(MAJOR).$(MINOR) lib/libshared.so.$(MAJOR)
	@ln -s -f libshared.so.$(MAJOR) lib/libshared.so

bin/exe_lib_ldpath: src/caller.c
	gcc -o $@ $< -Iinclude -Llib -lshared

bin/exe_file_ldpath: src/caller.c
	gcc -o $@ $< -Iinclude lib/libshared.so.$(MAJOR).$(MINOR) -Llib

bin/exe_file_ldpath_rpath: src/caller.c
	gcc -o $@ $< -Iinclude lib/libshared.so.$(MAJOR).$(MINOR) -Llib -Wl,-rpath,$(CURDIR)/lib

bin/exe_lib_rpath: src/caller.c
	gcc -o $@ $< -Iinclude -Llib -lshared -Wl,-rpath,$(CURDIR)/lib

bin/exe_file_rpath: src/caller.c
	gcc -o $@ $< -Iinclude lib/libshared.so.$(MAJOR).$(MINOR) -Wl,-rpath,$(CURDIR)/lib

bin/exe_file_rpath_link: src/caller.c
	@ln -s lib/libshared.so.$(MAJOR).$(MINOR) libshared.so.$(MAJOR).$(MINOR)
	gcc -o $@ $< -Iinclude libshared.so.$(MAJOR).$(MINOR) -Wl,-rpath,$(CURDIR)/lib
	@rm libshared.so.$(MAJOR).$(MINOR)

clean:
	-rm src/shared.c
	-rm obj/*
	-rm lib/*
	-rm bin/*
