#   Stage: Variables
ifeq ($(yaamake_stage),v)
# =======================

# Board
# -----

# MCU clock (crystal) frequency (external or internal)
#   This variable is similar to F_CPU, but defines original clock frequency.
#   For e.g. when you set cpu pre-scaler to 2 then F_CPU = F_CLOCK / 2
#   This information is known for different boards, so F_CPU defaults to it
#   as normally you want to run with full speed.
#   Do not add a "UL" here.
# F_CLOCK

# Processor frequency.
#   Yaal handles setting the processor speed if F_CLOCK and F_CPU are both set.
#   Do not add a "UL" here.
# F_CPU
F_CPU ?= $(F_CLOCK)

# MCU name
#   you MUST set this to match the chip you are using
#   If you use BOARD option, this is set for you.
# MCU



# Project files
# -------------

# Target file name (without extension).
TARGET ?= $(shell basename $(shell pwd))

# List of C, C++ and assembly source files.
#SRC = 
# SRC defaults to main.* or $(TARGET).*, where * is extension we know how to build
# FIXME: get prefixes from build.mk
SRC_MAIN = $(word 1,$(foreach base,main $(TARGET),$(foreach ext,.c .cpp .cc .S,$(wildcard $(base)$(ext)))))
SRC ?= $(SRC_MAIN)

override SRC_ERROR_MSG := No file matching main.* nor TARGET.* were found, also no SRC was specified in Makefile.

# Cache directory for local build time caching and other yaamake caching
override CACHEDIR := $(if $(CACHEDIR),$(CACHEDIR),.cache)


# Commands
# --------
# FIXME: how user could overwrite these as make has it's own defaults?
SHELL = sh
PYTHON := python
WINSHELL = cmd
CC = avr-gcc
OBJCOPY = avr-objcopy
OBJDUMP = avr-objdump
SIZE = avr-size
AR = avr-ar rcs
NM = avr-nm
REMOVE = rm -f
REMOVEDIR = rm -rf
COPY = cp
FIND ?= find

CCVERSION := $(shell $(CC) --version|grep gcc|sed 's/^.* //g')

# Env info
# --------
ARCH := $(shell uname -p)
# FIXME: I'm sure that there is better way to do this
LANG := $(shell locale | grep -E '^(LANG|LANGUAGE|LC_MESSAGES|LC_ALL)' | cut -d '=' -f 2 | tr -d '"' | tr '[\n-_:]' ' ' | cut -d ' ' -f 1)



#   Stage: targets
else ifeq ($(yaamake_stage),t)
# ============================


environment_help:
	$(HELP_TITTLE) environment
	$(HELP_DESC) "This section defines common variables about your avr environment"
	$(HELP_ATTRS)
	$(HELP_ATTR) BOARD "Hardware board, use boards_list to knwo valid options"
	$(HELP_ATTR) MCU "Microcontroller Chip Unit (e.q. attiny8) REQUIRED"
	$(HELP_ATTR) F_CLOCK "Clock source's frequencys frequency."
	$(HELP_ATTR) F_CPU "Processor frequency. (e.g. used by <util/delay.h>) [F_CLOCK]"
	$(HELP_ATTR) CACHEDIR "Directory for local caching of build files etc. [.cache]"


# Stages end
endif
