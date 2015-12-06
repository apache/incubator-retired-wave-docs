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

.. _Run-Wave-as-a-Windows-Service:

Run Wave as a Windows Service
=============================

Running WIAB as a Windows Service allows Wave to run in the background when the host machine is started. This negates
the need for you to log in and run the batch file from the command line. To accomplish this you must register Wave with
the Windows Service Manager. The Windows Service Manager does not have native support for running batch (.bat) files,
therefore you must use an external program to execute Wave through the Service Manager. The two most prevalent options
are the Windows Resource Kit and NSSM (the Non-Sucking Service Manager). These instructions focus on the NSSM
installation.


Service Installation (NSSM)
---------------------------

Download and extract NSSM-<version>.zip from http://iain.cx/src/nssm/ into a path on local machine (note: advise to use
path without spaces)

Open a Command Prompt at the directory NSSM is installed (if not placed on system path) and run:

* nssm install WaveInABox (note: you can substiture WaveInABox for the service name of your choice)

After executing this command a Graphical UI will appear. On the UI edit the Application field to

* c:\<path-to>\run-nofed-config.bat

Edit Default Behaviour on AppExit
---------------------------------
The default behavior of NSSM is to restart WaveInaBox if it errors out or is killed. To set it to gracefully exit:

* open regedit (start > run > type regedit or open command prompt and type regedit)
* navigate to HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\WaveInABox <or your chosen service name>\Parameters\
  AppExit
* Edit (Default) key to equal Exit or Ignore or Suicide or Restart (Restart is default)

Create a Dependency for Service
-------------------------------
You must edit the registry to set up a dependency for the WaveInABox service. This is useful, for example, to ensure
your XMPP server (e.g. - OpenFire) or persistent store (e.g. - mongodb) is started before WaveInABox is started. Also,
any attempt to kill the XMPP server or mongodb will alert that WaveInABox will also be affected. To create a dependency:

* open regedit (start > run > type regedit or open command prompt and type regedit)
* navigate to HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\WaveInABox <or your chosen service name>
* Right click on this folder (WaveInABox) and select New > Multi-String Value
* Edit the value name to DependOnService and then click OK.
* Double-Click the DependOnService key to open the Data dialog box. Type the name or names of the services that you
  prefer to start before the wave service. You must input one entry for each line, and then click OK. For example:
  MongoDB OpenFire

.. note:: The name of the service you would enter in the Data dialog box is the exact name of the service as it
  appears in the Windows Service Manager (start > run > type services.msc or open command prompt then type services.msc).

Verify Service Installed
------------------------
The final step is to verify the service was installed correctly and to start up your wave in a box service.

* Go to services.msc (start > run > type services.msc or open command prompt then type services.msc). You should see
  your new wave service WaveInABox.
* start WaveInABox by selecting service and clicking Start in left pane. You may also set other options at this point
  by right-clicking on the serice and selecting properties.