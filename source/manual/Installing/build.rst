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


Building Apache Wave
====================

.. todo:: Add how to download source etc

Windows
-------
Once you have the source and all of the tools installed, open up a Command shell and do the following:
::

   set JAVA_HOME=c:\Program Files\Java\jdk[YOUR_VERSION]
   set ANT=c:\Program Files\winant\bin\ant
   cd [THE_FULL_PATH_TO]wave-protocol
   ANT

Note, this is for a first time build. I would recommend using the Environmental Variables section in Windows to set
these permanently for future builds.

Running ANT will commence the build process. This will build both the Wave Server and the Web Interface.

To rebuild the source (say after you make changes, or pull down the latest version of the code), run the following in
your wave-protocol directory via a Command shell:
::

   ANT clean
   ANT

Linux/MacOSX
------------
Building under OSX and Linux should not require manually setting path elements (as we had to in Windows). Simply move to
the wave-protocol directory and run:
::

   $: ant

To rebuild the server run:
::

   $: ant clean; ant

End Result
----------
At the end of the build process you should have the following files in the dist directory under the wave-protocol
directory:

waveinabox-client-console-0.3.jar
waveinabox-server-0.3.jar

If you don't then go back and check the build process, something probably broke.