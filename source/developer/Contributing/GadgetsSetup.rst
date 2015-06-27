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

Gadget Server Setup
===================

This is the instructions for running your WIAB as well as your own gadget server (Shindig). These instructions uses the Apache Tomcat version of Shindig.

.. note::

    Currently gadgets does not work on Firefox 3.x

1. Download Shindig distribution from https://shindig.apache.org/download.html - make sure do download the war file and not jars.

    .. code-block:: latex

        wget http://www.apache.org/dist/shindig/2.5.2/shindig-server-2.5.2.war
2. Extract the war and edit the file WEB-INF/classes/containers/default/container.js - add "wave" to "gadgets.container" property. "gadgets.container" : "default", "accel", "wave",
3. The easiest way to run shindig is by using jetty-runner.

    .. code-block:: latex

        wget http://repo2.maven.org/maven2/org/mortbay/jetty/jetty-runner/
        8.1.9.v20130131/jetty-runner-8.1.9.v20130131.jar
4. Run the Shindig application war with:

    .. code-block:: latex

        java -jar jetty-runner-8.1.9.v20130131.jar shindig-server-2.5.2

    Please note that you can specify either folder of extracted war or the war file itself. The gadget server will start on localhost:8080
5. Get WIAB (See Installing)

    Edit server.config and add the following:

    .. code-block:: latex

        gadget_server_hostname=<the server host name of shindig>
        gadget_server_port=8080

6. Start WIAB