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

.. toctree::

   attachments
   authentication
   http_protocol
   operations
   raw_deltas_export

Google Wave Data API
====================

The Wave Data API allows developers to write programs that can read from and
write to Wave on behalf of Wave users. The Wave Data API is built on top of an
HTTP Protocol and we provide client libraries in several languages (Java,
Python)
to ease development.

You can use the Wave Data API to create alternative clients, like for a mobile
or desktop environment, and client applications, like an Android app for
uploading photos to a Wave or a Chrome extension for storing notes in wave.

Using the Client Libraries
--------------------------

When possible, we recommend using our official client libraries, since they
already handle the tricky parts, like authenticating users and de-serializing
JSON. The same client libraries are used for the Data API as the Robot API, as
they share an underlying protocol.

We currently offer 2 official client libraries for use with the Wave Data API:
Python, and Java. You can grab the source and view the reference from those
links, or click the links in the navigation at the side.

After downloading the client libraries, browse the documentation for the Wave
Data API to see how you can use them to authenticate, retrieve, and modify
waves.

Using the HTTP Protocol
-----------------------

If you don't want to use our client libraries or you are developing in a
different language, you can write your own library wrapping the HTTP protocol.
We hope that you will share your code and client libraries in the forum, so that
other developers can benefit from them.
