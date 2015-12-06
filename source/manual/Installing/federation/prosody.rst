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

.. _Prosody-Installation:

Prosody Installation
====================

Introduction
------------

Prosody is a lightweight XMPP server, written in lua. It's available from http://prosody.im.

Details
-------

Prosody is included in most linux distributions. For debian-based distros, run:
::

   $ sudo aptitude install prosody

To configure it, you may use the Prosody configuration tool provided with WaveInABox:
::

   $ ant -f server-config.xml server-federation-config prosody-config -Dxmpp_server_secret=secret_password
         -Dxmpp_server_ping=example.com -Dxmpp_server_ip=localhost

.. warning:: You may want to provide different -D options to suit your specific setup.

That will generate a prosody configuration file named something like: example.com.cfg.lua. Copy it wherever Prosody can
find it usually /etc/prosody/conf.d and restart the Prosody server:
::

   $ sudo cp example.com.fg.lua /etc/prosody/conf.d/
   $ sudo service prosody restart

You can now continue with the instructions for installing and running the server.
