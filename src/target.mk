SUFFIXES:

MAKETARGET = $(MAKE) --no-print-directory -C $@ -f $(CURDIR)/Makefile SRCDIR=$(CURDIR) $(MAKECMDGOALS)

.PHONY: $(OBJDIR) $(OBJDIRS)
$(OBJDIR) $(OBJDIRS):
	        +@[ -d $@ ] || mkdir -p $@
	        +@$(MAKETARGET)

$(OBJDIR) : $(OBJDIRS)

Makefile : ;
%.mk :: ;

% :: $(OBJDIRS) $(OBJDIR) ; :

.PHONY: clean
clean:
	        rm -rf $(OBJDIRS)
