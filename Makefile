# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.

# Makefile for Sphinx documentation
#

# You can set these variables from the command line.
SPHINXOPTS    =
SPHINXBUILD   = sphinx-build
PAPER         =
BUILDDIR      = build

# User-friendly check for sphinx-build
ifeq ($(shell which $(SPHINXBUILD) >/dev/null 2>&1; echo $$?), 1)
$(error The '$(SPHINXBUILD)' command was not found. Make sure you have Sphinx installed, then set the SPHINXBUILD environment variable to point to the full path of the '$(SPHINXBUILD)' executable. Alternatively you can add the directory with the executable to your PATH. If you don't have Sphinx installed, grab it from http://sphinx-doc.org/)
endif

# Internal variables.
PAPEROPT_a4     = -D latex_paper_size=a4
PAPEROPT_letter = -D latex_paper_size=letter
ALLSPHINXOPTS   = -d $(BUILDDIR)/doctrees $(PAPEROPT_$(PAPER)) $(SPHINXOPTS)
# the i18n builder cannot share the environment and doctrees with the others
I18NSPHINXOPTS  = $(PAPEROPT_$(PAPER)) $(SPHINXOPTS) source

.PHONY: help clean all all-pdf all-html doc-html doc-pdf developer-html developer-pdf api-html api-pdf manual-html manual-pdf protocol-html protocol-pdf

help:
	@echo "Please use \`make <target>' where <target> is one of"
	@echo "  doc-html       to make standalone HTML files"
	@echo "  doc-pdf        to make standalone PDF files"

clean:
	rm -rf $(BUILDDIR)/*

all: all-html all-pdf

all-html: doc-html developer-html api-html manual-html protocol-html

all-pdf: doc-pdf developer-pdf api-pdf manual-pdf protocol-pdf

doc-html:
	$(SPHINXBUILD) -b html $(ALLSPHINXOPTS) source/documentation $(BUILDDIR)/documentation/html
	@echo
	@echo "Build finished. The HTML pages are in $(BUILDDIR)/documentation/html."

doc-pdf:
	$(SPHINXBUILD) -b latex $(ALLSPHINXOPTS) source/documentation $(BUILDDIR)/documentation/pdf
	@echo "Running LaTeX files through pdflatex..."
	$(MAKE) -C $(BUILDDIR)/documentation/pdf all-pdf
	@echo "pdflatex finished; the PDF files are in $(BUILDDIR)/documentation/pdf."

developer-html:
	$(SPHINXBUILD) -b html $(ALLSPHINXOPTS) source/developer $(BUILDDIR)/developer/html
	@echo
	@echo "Build finished. The HTML pages are in $(BUILDDIR)/developer/html."

developer-pdf:
	$(SPHINXBUILD) -b latex $(ALLSPHINXOPTS) source/developer $(BUILDDIR)/developer/pdf
	@echo "Running LaTeX files through pdflatex..."
	$(MAKE) -C $(BUILDDIR)/developer/pdf all-pdf
	@echo "pdflatex finished; the PDF files are in $(BUILDDIR)/developer/pdf."

api-html:
	$(SPHINXBUILD) -b html $(ALLSPHINXOPTS) source/api $(BUILDDIR)/api/html
	@echo
	@echo "Build finished. The HTML pages are in $(BUILDDIR)/api/html."

api-pdf:
	$(SPHINXBUILD) -b latex $(ALLSPHINXOPTS) source/api $(BUILDDIR)/api/pdf
	@echo "Running LaTeX files through pdflatex..."
	$(MAKE) -C $(BUILDDIR)/api/pdf all-pdf
	@echo "pdflatex finished; the PDF files are in $(BUILDDIR)/api/pdf."

manual-html:
	$(SPHINXBUILD) -b html $(ALLSPHINXOPTS) source/manual $(BUILDDIR)/manual/html
	@echo
	@echo "Build finished. The HTML pages are in $(BUILDDIR)/manual/html."

manual-pdf:
	$(SPHINXBUILD) -b latex $(ALLSPHINXOPTS) source/manual $(BUILDDIR)/manual/pdf
	@echo "Running LaTeX files through pdflatex..."
	$(MAKE) -C $(BUILDDIR)/manual/pdf all-pdf
	@echo "pdflatex finished; the PDF files are in $(BUILDDIR)/manual/pdf."

protocol-html:
	$(SPHINXBUILD) -b html $(ALLSPHINXOPTS) source/protocol $(BUILDDIR)/protocol/html
	@echo
	@echo "Build finished. The HTML pages are in $(BUILDDIR)/protocol/html."

protocol-pdf:
	$(SPHINXBUILD) -b latex $(ALLSPHINXOPTS) source/manual $(BUILDDIR)/protocol/pdf
	@echo "Running LaTeX files through pdflatex..."
	$(MAKE) -C $(BUILDDIR)/protocol/pdf all-pdf
	@echo "pdflatex finished; the PDF files are in $(BUILDDIR)/protocol/pdf."
