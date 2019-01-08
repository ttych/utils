.PHONY: all bin-build bin-clean test test-build test-run test-bin-build test-clean test-pre-clean

all: bin-clean bin-build

bin-build:
	@./.build/build.sh

test: test-pre-clean test-bin-build test-build test-run test-clean

test-bin-build:
	@./.build/build.sh -t .test/bin

test-build:
	@./.build/build.sh -s test -t .test/test

test-run:
	@for test in $$(ls -1 .test/test/tst_*); do \
	    sh $$test ; \
	done

test-pre-clean test-clean:
	@rm -Rf .test

bin-clean:
	@rm -Rf bin
