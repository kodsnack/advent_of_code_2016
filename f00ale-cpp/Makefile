Q:=@
SRCS:=$(sort $(wildcard src/*.cpp))
OBJS:=$(addprefix .obj/,$(SRCS:.cpp=.o))
OUTS:=$(addprefix .out/,$(SRCS:.cpp=))
CXXFLAGS:=-std=gnu++14

run: $(OBJS)
	@for i in $(OBJS); do echo -n $$i ': ' ; $$i ; done

$(OBJS): .obj/%.o: %.cpp
	@echo '  [CXX]' $<
	@mkdir -p $(dir $@)
	$(Q)g++ $(CXXFLAGS) -o $@ $<

