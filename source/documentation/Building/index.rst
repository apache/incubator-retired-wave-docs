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

Building
========

While in the root source directory ``/source`` the documentation can be built using make.

.. code-block:: python

    make <build-option>

where <build-option> is one of these available options:

    ============== ==========================================================
    <build-option> Description
    ============== ==========================================================
    help           displays the help menu
    clean          clears the build directory (deletes all files under build)
    all            produces all pdf and html docs
    all-pdf        produces all pdf docs
    all-html       produces all html docs
    doc-html       produces "documentation" html doc
    doc-pdf        produces "documentation" pdf doc
    developer-html produces "developer" html doc
    developer-pdf  produces "developer" pdf doc
    api-html       produces "api" html doc
    api-pdf        produces "api" pdf doc
    manual-html    produces "manual" html doc
    manual-pdf     produces "manual" pdf doc
    protocol-html  produces "protocol" html doc
    protocol-pdf   produces "protocol" pdf doc
    ============== ==========================================================

The output will be available in ``/build/<project name>/html`` or ``/build/<project name>/pdf``

