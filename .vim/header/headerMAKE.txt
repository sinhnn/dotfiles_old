################################################################################
# Project name   :
# File name      : !!FILE
# Created date   : !!DATE
# Author         : Ngoc-Sinh Nguyen
# Last modified  : !!DATE
# Guide          :
###############################################################################

CC := gcc
FLAGS += -g
INC += -I ./inc -I ../
LD_LIB +=
#VPATH := inc src
vpath %.h inc
vpath %.c src
vpath %.o obj
SRC_FILE := $(notdir $(wildcard src/*.c))
OBJ_FILE := $(addprefix obj/,$(notdir $(SRC_FILE:.c=.o)))
TEST_FILE := $(notdir $(wildcard test/*c))
H_FILE := $(notdir $(wildcard inc/*.h))


bin/run : $(OBJ_FILE)
	    $(CC) $(FLAGS) $(INC) $^ -o $@ $(LD_LIB)

bin/rungprof : $(OBJ_FILE)
		$(CC) $(FLAGS) -pg $(INC) $^ -o $@ $(LD_LIB)


obj/%.o : %.c config.h
	      $(CC) $(FLAGS) -c $(INC) $< -o $@


tags : $(SRC_FILE) $(H_FILE)
	ctags -f ./.tags --c-kinds=+p --fields=+iaS --extra=+fq ./inc

syntatic:
	  echo "$(INC)" > .syntastic_c_config
	  echo "$(FLAGS)" >> .syntastic_c_config
	  echo "$(LD_LIB)" >> .syntastic_c_config
	  sed -i 's/ -/\n-/g' .syntastic_c_config

clean :
	rm -rf obj/*.o bin/run bin/rungprof

