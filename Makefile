.PHONY: build, run

build:
	docker build -t nonchalant/prompt_review:1.0 .

run:
	docker run nonchalant/prompt_review:1.0