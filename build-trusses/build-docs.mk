######
# Makefile to build uberSpark documentation
# author: amit vasudevan (amitvasudevan@acm.org)
######

include ./commondefs.mk

###### targets

### common documentation build prep
.PHONY: docs_build_prep
docs_build_prep:
	mkdir -p $(UBERSPARK_DOCSDIR)/_build

### generate .pdf documentation
.PHONY: docs_pdf
docs_pdf: docs_clean docs_build_prep
	sphinx-build -b latex "$(UBERSPARK_DOCSDIR)" "$(UBERSPARK_DOCSDIR)"/docs
	@cd "$(UBERSPARK_BUILDDIR)"/docs && make 

### generate .html documentation
.PHONY: docs_html
docs_html: docs_clean docs_build_prep
	sphinx-build -b html "$(UBERSPARK_DOCSDIR)" "$(UBERSPARK_DOCSDIR)"/docs

### cleanup documentation build
.PHONY: docs_clean
docs_clean:
	mkdir -p $(UBERSPARK_DOCSDIR)/_build
