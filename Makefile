SHELL=/bin/bash
.DEFAULT_GOAL := help

# https://gist.github.com/tadashi-aikawa/da73d277a3c1ec6767ed48d1335900f3
.PHONY: $(shell grep --no-filename -E '^[a-zA-Z0-9_-]+:' $(MAKEFILE_LIST) | sed 's/://')

define run
    docker run -it --rm --cap-add=SYS_PTRACE --security-opt="seccomp=unconfined" -w /work -v $(PWD):/work gcc \
    /bin/bash -c 'nasm -g -f elf64 -o ${1}.o ${1}.asm && ld ${1}.o && ./a.out'
endef

# Phony Targets

bash: ## bash
	docker run -it --rm --cap-add=SYS_PTRACE --security-opt="seccomp=unconfined" -w /work -v $(PWD):/work gcc /bin/bash || true

gdb: ## gdb
	docker run -it --rm --cap-add=SYS_PTRACE --security-opt="seccomp=unconfined" -w /work -v $(PWD):/work gcc gdb ./a.out || true

docker: ## docker build
	docker build -t gcc docker/

# https://postd.cc/auto-documented-makefile/
help: ## Show help
	@grep --no-filename -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-40s\033[0m %s\n", $$1, $$2}'
