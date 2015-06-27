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

Release Procedure
=================

Introduction
------------
    This is an attempt to document the release procedure used for Wave whilst under incubation.
    These notes are not complete, so you will probably want to refer to the following documents:

    * https://incubator.apache.org/guides/releasemanagement.html
    * https://incubator.apache.org/guides/release-java.html
    * https://www.apache.org/dev/release.html

    A good guide (used as the basis for this one) is produced by the Apache Commons project:

    * https://commons.apache.org/releases/prepare.html
    * https://commons.apache.org/releases/release.html

Build Environment
-----------------
The release procedure documented has been/is being carried out on a 64-bit Linux machine using Ant and OpenJDK 1.6

Preparation
-----------

Make a release branch
^^^^^^^^^^^^^^^^^^^^^

    This depends on how active the tree is at the time.

    .. code-block:: latex

        git checkout -b wave-X.X.X-release

    Then check out this branch, to do any release work needed.

Check Licensing
^^^^^^^^^^^^^^^

    Ensure that all source files have the Apache License attached, and any dependencies licenses are correctly noted in
    NOTICE. Run the license audit tool and inspect the output:

    .. code-block:: latex

        ant audit-licenses

    Check export status of any cryptographic dependencies.

Set version number in file
--------------------------

The version number is currently stored in build.properties in the waveinabox.version string.
Whilst the project is still incubating, the word 'incubating' must appear in the version string.

The version number should be in the form described at: http://semver.org/

Given a version number **MAJOR** . **MINOR** . **PATCH** , increment the:

1. **MAJOR** version when you make incompatible API changes,
2. **MINOR** version when you add functionality in a backwards-compatible manner, and
3. **PATCH** version when you make backwards-compatible bug fixes.

Additional labels for pre-release and build metadata are available as extensions to the **MAJOR** . **MINOR** . **PATCH**
format. |br|
For example:  0.4.0-rc.6-incubating |br|
Every release should usually increase the MINOR version and reset the PATCH version.

Create CHANGES
--------------
I suggest using the following git log, to produce a one-line-per-change list of all commits.
(An alternative, would be to use the JIRA id's)

.. code-block:: latex

    git log --pretty-medium

Put this the 'Full log' section.
I suggest hand-writing the 'Summary since X' at the start of the file.

Create RELEASE-NOTES
--------------------
**TODO: decide on a format**

Refer to the notes used in the previous release for the format of how to write them. |br|
Break at 80 chars as is conventional. |br|
**Include:**

* Description of the project
* Any major changes (otherwise see CHANGES) Is this really needed given the summary in CHANGES?
* Any compatibility issues (and mention if none)
* Any upgrading procedures needed
* Make another note of the required Java version

Tag the RC
----------

Make the RC
-----------
There are two ways to create the artefacts. The preferred way is to use the artefacts created by Jenkins.
Download zip with all artefacts from https://builds.apache.org/view/S-Z/view/Wave/job/wave-artifacts/lastSuccessfulBuild/artifact/*zip*/archive.zip

.. code-block:: latex

    wget https://builds.apache.org/view/S-Z/view/Wave/job/wave-artifacts/lastSuccessfulBuil
    d/artifact/*zip*/archive.zip
    unzip archive.zip

Or, create the artefacts manually. Make sure to run the unit tests first. Run

.. code-block:: latex

    ant release


Check that the produced code still works! |br|
Check that source packages don't include any binaries. |br|
Sign the release using your GPG key, and record SHA512 checksums for the files. |br|

.. code-block:: bash
    :caption: Sign artefact's

    #!/bin/zsh
    #Assumes it is being run in the folder with artefact's.

    PRE="apache-wave-"
    for f in $PRE*; do
    gpg --armor --output $f.asc --detach-sig $f
    gpg --print-md SHA512 $f > $f.sha
    done

You need to append you signature/public key to the KEYS file, look there for instructions.

Upload the Artefacts.
---------------------

Upload the src+bin tar+zip somewhere so that it can be found. |br|
The release candidate should be uploaded to the "dev" folder first to allow inspection and voting. |br|

.. code-block:: latex
    :caption: Commit new rc

    svn checkout  https://dist.apache.org/repos/dist/dev/incubator/wave/

Create a new folder under dist/dev/incubator/wave for the new release candidate and copy there the signed artefacts and then commit.

Vote for release
----------------

Send a vote mail for RC
^^^^^^^^^^^^^^^^^^^^^^^
Send a message with subject 'VOTE Release Wave 0.3 based on RC1' email to wave-dev@incubator.apache.org. |br|
Post links to the RC artefacts, the subversion tag it is based upon, RELEASE-NOTES so that the artefact doesn't have to be downloaded to see them. |br|
Ensure that KEYS is available somewhere with the artefacts. |br|
Check the voting guide for more information on how to count votes etc. |br|
When posting the RESULT, note that (currently) all committers are also PPMC, so to prevent confusion list as PPMC in the result email.

(Incubator only) Vote for RC
^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Whilst Wave is still an incubating project, send a VOTE email to general@incubator.apache.org to get PMC votes. Handle in the same way as the internal vote.

Publish accepted RC
-------------------
To publish copy the artefacts into https://dist.apache.org/repos/dist/release/incubator/wave/ from the dist/dev/incubator/wave/ (delete old artefacts if needed, they were automatically archived already) and commit.

.. |br| raw:: html

   <br />