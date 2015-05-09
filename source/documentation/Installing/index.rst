.. Licensed to the Apache Software Foundation (ASF) under one
   or more contributor license agreements.  See the NOTICE file
   distributed with this work for additional information
   regarding copyright ownership.  The ASF licenses this file
   to you under the Apache License, Version 2.0 (the
   "License"); you may not use this file except in compliance
   with the License.  You may obtain a copy of the License at

..   http://www.apache.org/licenses/LICENSE-2.0

.. Unless required by applicable law or agreed to in writing,
   software distributed under the License is distributed on an
   "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
   KIND, either express or implied.  See the License for the
   specific language governing permissions and limitations
   under the License.

Installing
==========

It is assumed knowledge that your able to *clone/fork* the **Git** repository containing the project. This repository can be
found publicly at https://github.com/apache/incubator-wave-docs .

The project also uses the pull request development workflow. At tutorial of this workflow can be found here
https://www.atlassian.com/git/tutorials/making-a-pull-request .

.. topic:: Requirements

        * Python 2.7+
        * Pip
        * make


Installing Sphinx
-----------------

    Sphinx is a easy to use documentation system which is most notably used for the python documentation. It was chosen
    by the project to be used due to its ease of use and available outputs (Html & Pdf). This allows print out
    publications to be made and a large availability for online and offline use.

    Sphinx is recommended to be installed through pip:

    .. code-block:: python
        :linenos:

        pip install sphinx

    **Latex Pdf additional Packages**

        These packages may be required when building the pdf version of the documents.

            Linux:
                Debian Based:

.. code-block:: python

    apt-get install texlive-latex-recommended texlive-latex-extra texlive-fonts-recommended