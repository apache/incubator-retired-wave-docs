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

.. _Openfire-Installation:

Openfire Installation
=====================

.. todo:: check these instructions still work and change links to apache infra

.. note:: THESE INSTRUCTIONS ARE UNTESTED AND VERY OUT-OF-DATE NOW. Please use Prosody instead.

.. note:: :strong:`Be Careful` Openfire (3.6.4) has a bug in it's DNS code.

Introduction
------------
The open source Wave In a Box is delivered as a Java application that conforms to XEP-0114, the Jabber Component
Protocol. In the examples below we show how to install the Wave Federation Prototype Server as an extension to the
http://www.igniterealtime.org/projects/openfire/index.jsp XMPP server, but it should run against any XEP-0114 compliant
server. We also have instructions for using Prosody.

To run the Prototype Server you will first need to install the Openfire server. The instructions for installing Openfire
are included below are for a Debian based Linux distribution and are there for your convenience, but any issues with
installing Openfire should be directed to the standard Openfire community support.

Preliminaries
-------------
Openfire is written in Java so you will need to make sure Java is installed on your machine. While WIAB should run on
any platform with Java 6 the instructions below are only for Mac OSX and a Debian based Linux distribution.

Mac OSX
^^^^^^^
For Mac OSX you will need to download Java from `Apple <http://developer.apple.com/java/download/>`_.

After installing Java you will need to set the following environment variables:

::

   $ export JAVA_HOME=/System/Library/Frameworks/JavaVM.framework/Versions/1.6.0/Home
   $ export PATH=$JAVA_HOME/bin:$PATH

Now visit the http://www.igniterealtime.org/downloads/index.jsp and download and install the Mac OSX version of
Openfire.

Debian/Ubuntu
^^^^^^^^^^^^^

Install Java 6:
::

   $ apt-get install sun-java6-jdk sun-java6-fonts

Now download and install the Openfire server:
::

   $ wget http://www.igniterealtime.org/downloadServlet?filename=openfire/openfire_3.6.4_all.deb
   $ sudo dpkg -i openfire_3.6.4_all.deb
   $ sudo /etc/init.d/openfire restart

Other Linux Distros
^^^^^^^^^^^^^^^^^^^
Other Linux distributions are not directly supported, but installation should work mostly in the same way as for
Debian/Ubuntu. However, there have been many reported configuration issues that we are tracking.

Configure Openfire (all platforms)
----------------------------------
After installing Openfire visit http://localhost:9090 with your browser. Substitute the domain name of the server you
installed Openfire on for localhost if you didn't install it on your local machine. You will be guided through the setup
process by a wizard. For the simplest installation select the defaults.


.. image:: /Resources/openfire01-server-setting.jpg

.. image:: /Resources/openfire02-database-settings.jpg

.. image:: /Resources/openfire03-profile-settings.jpg

.. image:: /Resources/openfire04-administer-account.jpg


Configure Openfire for the Wave extension
-----------------------------------------

Restart the server after you have finished the configuration. On Debian/Ubuntu you would restart it by:
::

   $ sudo /etc/init.d/openfire restart

After the server has restarted login as admin and go to Server -> Server Settings -> External Components.
:strong:`Login using the name 'admin' and not the email address you gave during setup.`

Enable external components on port 5275 and a default shared secret of your own choosing. Press save. Then add wave as
a whitelisted component, by choosing a subdomain of wave and choose a shared secret for the wave extension. The shared
secret and port number are arguments that will be passed to the wave extension.

.. image:: /Resources/openfire05-external-components-02.png

Now go to Server -> Server Settings -> Security Settings. For "Server Connection Security" select "Custom" and enable
"Server Dialback". Also check the "Accept self-signed certificates" check box.

.. image:: /Resources/openfire06-security-settings-tls-custom.jpg

Security
--------
The following changes are not required for the wave extension to work, but are good practices if you are running a
public facing XMPP server.

* Go to Server -> Server Settings -> Registration and Login. Disable
* "Inband Account Registration". Disable "Change Password". Disable "Anonymous Login"
* Enable server-server compression in "Compression Settings"
* Disable file proxy transfer in "File Transfer Settings"
* Now continue following the instructions for installing the server.