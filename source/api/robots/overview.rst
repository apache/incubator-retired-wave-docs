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

Overview
========

Obtaining a Robot Client Library
--------------------------------

Development of Google Wave robots requires an appropriate client library. We
currently have client libraries for the Java™ and Python programming languages.

You can find out more information about the client libraries, file issues, and
make feature requests on the Google Wave Resources home page on
Google Project Hosting. This page also contains download links for the latest
client libraries.

Deploying a Robot
-----------------

Initially robots for Google Wave could only be deployed on App Engine, using
either the Java™ or Python client libraries. However, robots now can be
deployed on non-App Engine domains, provided that you register your robot via a
three step registration process. Note that at this time non-App Engine robots
can participate only on WaveSandbox.com

Robot Troubleshooting
---------------------

Robots within the Wave API are "versioned" through use of a hash value, which
is based on the robot's event signature. When altering the robot's behavior
when handling events, the Wave API will generate a new hash value. This allows
the Wave system to detect when robots have changed and/or their capabilities
have been altered. You can use this value as well to detect that your changes
have been properly implemented.

If you have trouble during development of your robot, the following tests may
be helpful:

* **Is your robot's capabilities.xml file live?** You can test whether the file
  is properly deployed by accessing the robot at
  http://robotname.appspot.com/_wave/capabilities.xml. If you receive an XML
  response, you know your robot has been properly deployed to App Engine.
  (Depending on your browser, you may need to view the page source to see
  the XML).
* **Has your robot's version changed?** If you've changed the capabilities of
  this robot (by altering the way it handles events), you should see a
  different hash value stored within the version tag of the automatically
  generated capabilities.xml file.
* **Are you monitoring the right events?** Have you set up handlers for each of
  the events you wish to intercept? Do those handlers make use of the event
  data and/or context passed within the event properly? You can inspect the
  capabilities.xml file to ensure that your robot is set up to receive the
  correct events.
* **Is App Engine serving the correct version?** App Engine allows you to
  deploy multiple versions as well. Though you likely should not change this
  during development, you may wish to do so in production to avoid breaking
  existing waves and/or clients.
* **Is there an error in the App Engine Logs?** Consult the App Engine logs at
  https://appengine.google.com for your robot deployment. If you receive an
  error, you likely have a coding error.