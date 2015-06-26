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

Navigating the Codebase and Making the First Change
===================================================
The following is a description on how to figure out how to implement a tiny feature without know much about the code.
The actual feature is trivial to implement. The main learning of this starter project is to set up the dev environment,
how to navigate the code base and make a change. In this spirit, the instructions below does not go directly to the
feature, rather it includes lots of investigative steps.

1. Follow the instructions at Client Development Setup to set up the dev environment
2. In windows or linux, start the browser with OOPHM plugin installed and navigate to the WIAB server as in the above instruction. This lets you debug the client code.
3. Let's try to see if there are any classes to do with undo.

    a. In eclipse hit ctrl+shift+t (class search), and type "Undo".
    b. Notice there is a class called UndoManagerImpl. Notice there is a method called undoPlus() in this class.
    c. Let's look up where it's called, by putting the cursor over the method and hit ctrl+shft+g, which looks up call references should take you to EditorUndoManagerImpl.undo().
    d. Repeat call reference look up again on EditorUndoMangerImpl.undo(), should take you to EditorImpl:handleCommand(). Notice on line 764 if (event.isUndoCombo()) {. Bingo
    e. Putting cursor over isUndoCombo() and hit ctrl+t, which looks up implementations of the method. This will take you to SignalEventImpl.isUndoCombo()
4. Looks like it currently uses "Z" for undo. Let's change it to "0".
5. Refresh the browser with OOPHM and try the feature. The code now works in debug.
6. Compile the WIAB (slow) to see it works outside of debug

    a. In the wave-protocol directory run ant
    b. Restart WIAB server
7. Open WIAB in a browser without using OOPHM by directly visiting http://localhost:9898 and check the feature works.

    a. Open WIAB client.
    b. Create a new wave
    c. Type some text
    d. ctrl+0