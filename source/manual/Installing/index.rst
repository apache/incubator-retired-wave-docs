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

Install Apache Wave
===================

**NOTE: Please be aware this documentation isn't necessary in step with the current code. Consider contributing by updating it with your findings!**

Wave in a Box is delivered as a Java application. Installation comprises installing the server code and (optionally)
configuring federation with XMPP.

.. toctree::

   build
   logging
   run-export

Server installation
-------------------

Getting Java
^^^^^^^^^^^^

Ensure you have Java 8 installed before attempting to install Wave in a Box

From release package
^^^^^^^^^^^^^^^^^^^^

Apache Wave releases can soon be downloaded from the release repository, and are packaged for UNIX and Windows systems.

::

   $ wget https://dist.apache.org/repos/dist/dev/incubator/wave/0.4.0-rc10/apache-wave-bin-0.4.0-incubating.tar.bz2
   $ tar -zxf apache-wave-bin-0.4.tar.gz
   $ cd apache-wave-bin-0.4.0-incubating

Running the server
------------------

Run the server with

::

   $ ./run-server.sh

Running the webclient
---------------------

Once you have followed the instructions on this page about how to get the server running you should be able to reach the
web client by going to: http://localhost:9898 when running locally or by contacting port 9898 on the machine running the
server.

Further steps
-------------

This will get you as far as having a basic Wave server for testing and playing, but other steps should or could be taken:

* Using SSL certificates
* Using MongoDB as data store
* Use Federation to contact with other Wave servers
* Enable Wave Extensions

You can find the most up-to-date documentation at https://github.com/apache/incubator-wave-docs
