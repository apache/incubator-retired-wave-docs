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

Logging
=======

Enable ALL logging
------------------

.. todo:: document the logging levels available.

By requesting Java uses a logging configuration file, we can easily configure the logging level to more than the default. (Default depends on whether WIAB was compiled in demo mode or not).

In run-server.sh, change the exec java to something like:

::

   exec java $DEBUG_FLAGS \
      -Djava.util.logging.config.file=wiab-logging \
      -Djava.security.auth.login.config=jaas.config \
      -Dwave.server.config=server.config \
      -jar dist/$NAME-server-$WAVEINABOX_VERSION.jar

The -Djava.util.logging.config.file=/home/wave/wiab-logging is the only new line.

I have deliberately, turned down the logging from jetty to ERROR only, so that the log fills up with Wave only messages.

Then create the logging configuration file at the path specified:

.. todo:: make this only change logging for Wave.

::

   handlers=java.util.logging.FileHandler, java.util.logging.ConsoleHandler
   .level = ALL
   java.util.logging.ConsoleHandler.level=ALL
   java.util.logging.ConsoleHandler.formatter=java.util.logging.SimpleFormatter
   org.waveprotocol.level=ALL

Then upon rebooting your server, the amount of logging information should be dramatically increased. I suggest pipeing it to a file from here.

Uploading logs
^^^^^^^^^^^^^^

Since the logs consist of huge quantities of almost the same message, dictionary compression schemes work incredibly well on it. So please compress it with something before uploading.

(Anecdotally, a 224M log file compresses to 1.9M using xz)!

Jetty Logging
-------------
Since Jetty 9, the logging implementation in Jetty has changed to have a more extensible backend.

The settings have become completely independent of the rest of the logging settings. To set them, change the run-server script to pass the following flags:
::

   -Dorg.eclipse.jetty.util.log.class=org.eclipse.jetty.util.log.StdErrLog \
   -Dorg.eclipse.jetty.level=INFO \

For more information, refer to the `Jetty9 documentation <https://cwiki.apache.org/confluence/h>`_.

Disable Logging
---------------

.. todo:: write about it here, it simply consists of removing the lines from run-server.sh
