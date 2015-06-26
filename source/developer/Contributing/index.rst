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

Contributing
============

.. toctree::
   :maxdepth: 1
   :hidden:

   releaseProcedure
   clientDevSetup
   GadgetsSetup

The following pages are useful if you're starting out with Apache Wave, and detail how to get a development
environment setup.


**Contributing Process**

In order to develop and release software contributions you must follow these steps:

1. Create or assign a JIRA issue for the contribution you want to work in. Any contribution must have an associated `JIRA issue`_.
2. Create a patch per logical set of issues/features. (Create a patch in `Eclipse`_ /`Intellij`_)
3. Submit the patch to the `Review Board`_ with assigned to the "wave" project, and mentioning the JIRA issue number that it is related to.
4. Inform the Mailing List and/or IRC about the request.
5. Fix the patch according to the suggestions in the Review Board until it has gotten approval.
6. Push the patch to git if a committer otherwise one of the reviewers will push the change.
7. Close issues and review board request.








.. Links:
.. _JIRA issue: https://issues.apache.org/jira/browse/WAVE
.. _Eclipse: http://help.eclipse.org/luna/index.jsp?topic=%2Forg.eclipse.platform.doc.user%2Ftasks%2Ftasks-68c.htm
.. _Intellij: https://www.jetbrains.com/idea/help/using-patches.html
.. _Review Board: https://reviews.apache.org/r/