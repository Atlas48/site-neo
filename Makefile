.PHONY: all list-doc list-sass list-rest list-dir list clean build push
list: list-doc list-sass list-rest list-dir
list-doc:
	@echo "====DOCUMENT FILES===="
	find . -wholename './.hg' -prune , -type f -name '*.txti' , -name '*.org' , -name '*.md'
list-sass:
	@echo "======SASS FILES======"
	find . -wholename './.hg' -prune , -type f -name '*.s[ca]ss'
list-rest:
	@echo "======OTHER FILES====="
	find . -wholename './.hg' -prune , -type f -and ! \( -name '*.org' , -name '*.txti' , -name '*.md' , -name .hg \)
list-dir:
	@echo "=====DIRECTORIES======"
	find . -wholename './.hg' -prune , -type d -not -name .hg
clean:
	rm -rf out
build:
	./render.sh
sitemap: out/sitemap.xml
	./gensimap.sh
push: build
	rclone sync -v out/ neo:/
