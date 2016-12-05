Q:=@
SRCS:=$(sort $(wildcard src/*.cpp))
OBJS:=$(addprefix .obj/,$(SRCS:.cpp=.o))
OBJS_Q:=$(addprefix .obj/q,$(SRCS:.cpp=.o))
OUTS:=$(addprefix .out/,$(SRCS:.cpp=))
CXXFLAGS:=-std=gnu++14 -O3
CXXFLAGS_Q:=$(CXXFLAGS) -DQUICK

all: $(OBJS)

qall: $(OBJS_Q)

run: qall
	@for i in $(OBJS_Q); do echo -n $$i ': ' ; $$i ; done

$(OBJS_Q): .obj/q%.o: %.cpp
	@echo '  [CXX]' $<
	@mkdir -p $(dir $@)
	$(Q)g++ $(CXXFLAGS_Q) -o $@ $<

$(OBJS): .obj/%.o: %.cpp
	@echo '  [CXX]' $<
	@mkdir -p $(dir $@)
	$(Q)g++ $(CXXFLAGS) -o $@ $<

