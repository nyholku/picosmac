#----- Begin Boilerplate
OBJDIRS = ../obj

ifeq (src,$(notdir $(CURDIR)))
include target.mk
else
#----- End Boilerplate

$(info    DEBUG is $(FILES))

.SUFFIXES:
VPATH = $(SRCDIR)
#Normal makefile rules here


PROCESSOR := 18f4550

LOAD := 1

TARGETS := cosmac trial




# brix.asm tetris.asm pong.asm tank.asm chip8.asm vip-pic.asm telmac-rom.asm polkka.asm



progfiles := $(notdir $(wildcard  $(SRCDIR)/cosmacode/*))
cosmacode=$(addprefix cosmacode/,$(progfiles))
$(info    cosmacode is $(cosmacode))


# target 'trial' is used by the regression test with gpsim 
# so it should not be loaded to hardware and should be compiled for pic18f4550
trial : TARGET = TARGET_TRIAL
trial : PROCESSOR = 18f4550
trial : LOAD = 

cosmac : TARGET = TARGET_COSMAC

trial_SRC := cdp1802.asm cdp1861.asm trial.asm
cosmac_SRC :=  cdp1802.asm cdp1861.asm main.asm $(cosmacode)

$(foreach target,$(TARGETS),$(eval $(target)_OBJ := $(addsuffix .o, $(basename $($(target)_SRC)))))

.SECONDEXPANSION:

.PHONY: all

all: cosmac
	

GPLINKFLAGS = -s $(SRCDIR)/${PROCESSOR}.lkr -m

%.o: %.asm	
	@test "." != `dirname $@` && mkdir -p `dirname $@` || true
	gpasm -DSTACK_MODEL_SMALL -D__STACK_MODEL_SMALL -p ${PROCESSOR} -D $(TARGET)=1 -o $@ -c $<

$(TARGETS): $(COMMON_OBJ) $$($$@_OBJ)
	gplink $(GPLINKFLAGS) -o $@.hex  $^
	test ${LOAD} && ../src/load ${PROCESSOR} $@.hex || true

endif
