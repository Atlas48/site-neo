FILES != find -name '*.txti' -o -name '*.org' -o -name '*.md'
all: build
.PHONY: list
list:
	@echo $(FILES)
out:
	mkdir out
.PHONY: clean
clean:
	rm -r out
%.html: %.org
	org-ruby $< > $@
%.html: %.txti
	redcloth $< > $@
.PHONY: build
build: $(FILES)
.PHONY: push
push: build
	rclone sync -v out/ neo:/
