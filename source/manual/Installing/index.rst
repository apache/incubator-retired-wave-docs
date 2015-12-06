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

Ensure you have Java 6 installed before attempting to install Wave in a Box

Building the code
^^^^^^^^^^^^^^^^^
WIAB is currently distributed on in source code form. Obtain the source for the project:

::

   $ svn co https://svn.apache.org/repos/asf/incubator/wave/trunk
   $ cd wave-protocol
   $ ant

If the build is successful you should see:

::

   BUILD SUCCESSFUL
   Total time: NN minutes MM seconds

Running the server
------------------
Copy the run-nofed-config.sh.example to run-config.sh, then edit run-config.sh to configure it to your setup.
The example file explains the configuration options. You can ignore all those concerning federation and certificates
for now.

Run the server with

::

   $ ./run-server.sh

Running the client
------------------

The configuration in run-config.sh is used by the client too, so nothing extra should be necessary to run the console
client.

::

   $ ./run-client-console.sh <username>

Running the webclient
---------------------

Once you have followed the instructions on this page about how to get the server running you should be able to reach the
web client by going to: http://localhost:9898 when running locally or by contacting port 9898 on the machine running the
server. Note that if you have changed the websocket server port in your settings you should use that port instead.

Mongo DB Installation (optional)
--------------------------------

It is possible to use Mongo DB to store Waves, instead of a filesystem-based system.

Download and extract the MongoDB `distribution <http://www.mongodb.org/>`_ for your system.

By default MongoDB will store data in /data/db/ which means you need to create and set the properties for that folder.
You can use any other location if you'd like just remember to give the server the --dbpath option. ::

   sudo mkdir -p /data/db/
   sudo chown `id -u` /data/db/

Run the server in a terminal window or use whatever means necessary to start the server process:
./<mongodb_location>/bin/mongod.

You can test whether it works by running ./<mongodb_location>/bin/mongo.

* Default connection port: 27017
* Default webadmin port: 28017

For more information read the `manual <http://www.mongodb.org/display/DOCS/Manual>`_.

Running the Server as a Windows Service (optional)
--------------------------------------------------

It is possible to run Wave in a Box as a Windows Service, so it starts and stops automatically.
See :ref:`Run-Wave-as-a-Windows-Service`

.. toctree::
   :hidden:

   Wave-As-Service


Federation configuration (optional)
-----------------------------------

The server conforms to XEP-0114, the Jabber Component Protocol. The first step in
running the Federation Prototype Server is to install an XMPP server that is
XEP-0114 compatible.

Follow the instructions below for your server of choice:

* :ref:`Openfire-Installation`
* :ref:`Prosody-Installation`

There are many XEP-0114 compatible XMPP servers and we don't have instructions for
all of them. Please contribute instructions if you have them for a server we don't
have listed.

See :ref:`federation-background` the explanation of DNS, SRV records, and ports.

.. toctree::

   federation

Configure Your XMPP Server
--------------------------

WIAB runs as a separate process that communicates with the XMPP server. For that communication to take place the XMPP
server has to be notified of which port the WIAB extension will be using and also will need a shared secret for security
purposes. In your XMPP server enable external components on port 5275 and a default shared secret of your own choosing.
The extesion should be named wave.<domain-name> where <domain-name> is the domain name of your XMPP server. You will
also need to enable Server Dialback for server to server communication. Each type of XMPP server is configured
differently, so look to their specific installation instructions for details.

Security
--------

The following changes are not required for the wave extension to work, but are good practices if you are running a
public facing XMPP server.

* Disable inband account registration.
* Disable anonymous login
* Enable server-server compression
* Disable file proxy transfer

Wave Extension Installation
---------------------------
To run the extension you will need some of the parameters you used to set up the XMPP server. They are the extension
port, the extension shared secret, the server name, and finally the component name which is "wave".

The wave server requires a set of certificates used for signing deltas. Please see the [certificates|:ref:`Certificates`
page for help generating these.

Copy the *run-config.sh.example* to *run-config.sh*, then edit *run-config.sh* to configure it to your setup.

When you're done editing the script, run check-certificates.sh to verify that the certificates are configured correctly:

::

   $ ./check-certificates.sh

If that runs successfully then run the server:

::

   $ ./run-server.sh
