# Minimal makefile for Sphinx documentation
#

# You can set these variables from the command line, and also
# from the environment for the first two.
SPHINXOPTS    ?=
SPHINXBUILD   ?= sphinx-build-3.6
SOURCEDIR     = source
BUILDDIR      = build

# Put it first so that "make" without argument is like "make help".
help:
	@$(SPHINXBUILD) -M help "$(SOURCEDIR)" "$(BUILDDIR)" $(SPHINXOPTS) $(O)

.PHONY: help Makefile

# Catch-all target: route all unknown targets to Sphinx using the new
# "make mode" option.  $(O) is meant as a shortcut for $(SPHINXOPTS).
%: Makefile
	@$(SPHINXBUILD) -M $@ "$(SOURCEDIR)" "$(BUILDDIR)" $(SPHINXOPTS) $(O)

	# Copy compiled files to root for rendering on github.io pages
	cp -f ./$(BUILDDIR)/html/*.html .
	cp -f ./$(BUILDDIR)/html/*.js .
	cp -f ./$(BUILDDIR)/html/.nojekyll .
	cp -fr ./$(BUILDDIR)/html/_sources .
	cp -fr ./$(BUILDDIR)/html/_static .
	cp -fr ./$(BUILDDIR)/html/_tutorials .
