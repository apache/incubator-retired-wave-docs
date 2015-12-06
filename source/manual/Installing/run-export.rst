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

run-export.sh
=============

This file allows users and administrators to export and backup waves.

Parameters
----------

.. todo:: ..

General Usage Instructions
--------------------------
The script takes a number of options. It also wants at least two arguments: The url of the server (including http:// or
https://) and the directory to store the exported waves to. All options must follow after these arguments.

If you just run the script with these two arguments, it will show you a URL to paste into the browser. You will then be
asked to allow or deny permission. If you allow it, you’ll see a long string. Paste this into the command line to let
the script proceed. Now it will export all your waves, including their attachments.

You can limit the number of waves to be exported. One way of doing so is with the search parameter. It will take the
same searches that work in the webgui too. (for example in:inbox).

Another way to filter the output would certainly be to use the include and exclude options.