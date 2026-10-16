FLAGS      := -g -bin-annot
TEST_FLAGS := -package alcotest
BUILD      := _build
TARGET     := main

ORDERED := $(shell ocamlfind ocamldep -sort $(wildcard *.ml))
CMX     := $(patsubst %.ml,$(BUILD)/%.cmx,$(ORDERED))
LIB_CMO := $(filter-out $(BUILD)/$(TARGET).cmo,$(patsubst %.ml,$(BUILD)/%.cmo,$(ORDERED)))

.PHONY: all run utop test format tags clean
all: $(BUILD)/$(TARGET)

run: all
	@./$(BUILD)/$(TARGET) $(FILE)

$(BUILD)/$(TARGET): $(CMX)
	ocamlfind ocamlopt $(FLAGS) -linkpkg -o $@ $^

$(BUILD)/%.cmi: %.mli
	@mkdir -p $(@D)
	ocamlfind ocamlc $(FLAGS) -I $(BUILD) -c -o $@ $<

$(BUILD)/%.cmo: %.ml
	@mkdir -p $(@D)
	ocamlfind ocamlc $(FLAGS) -I $(BUILD) -c -o $@ $<

$(BUILD)/%.cmx: %.ml
	@mkdir -p $(@D)
	ocamlfind ocamlopt $(FLAGS) -I $(BUILD) -c -o $@ $<

$(BUILD)/.depend: $(wildcard *.ml) $(wildcard *.mli) $(wildcard tests/*.ml)
	@mkdir -p $(@D)
	ocamlfind ocamldep $(wildcard *.mli) $(wildcard *.ml) $(wildcard tests/*.ml) > $@.tmp && sed -e 's,^\([^:]*\):,$(BUILD)/\1:,' -e 's, \([^: ]*\.cm[iox]\), $(BUILD)/\1,g' $@.tmp > $@ && rm -f $@.tmp

-include $(BUILD)/.depend

clean:
	rm -rf $(BUILD)
	rm -f tags

utop: $(LIB_CMO)
	utop -I $(BUILD) $(LIB_CMO)

$(BUILD)/tests/%.cmo: tests/%.ml
	@mkdir -p $(@D)
	ocamlfind ocamlc $(FLAGS) $(TEST_FLAGS) -I $(BUILD) -c -o $@ $<

$(BUILD)/tests/%: $(LIB_CMO) $(BUILD)/tests/%.cmo
	ocamlfind ocamlc $(FLAGS) $(TEST_FLAGS) -linkpkg -o $@ $^

test: $(patsubst tests/%.ml,$(BUILD)/tests/%,$(wildcard tests/*.ml))
	@for t in $^; do echo "--- $$t"; ./$$t || exit 1; done

format:
	ocamlformat --enable-outside-detected-project --profile=janestreet --inplace $(wildcard *.ml) $(wildcard *.mli) $(wildcard tests/*.ml)

tags:
	ctags -R .
