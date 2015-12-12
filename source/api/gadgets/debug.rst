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

Debugging Tips
==============

When you're developing a gadget to run inside Google Wave, debugging can be
hard. Why? Well, first of all, debugging on the web is hard generally. A bug
could exist in your JavaScript, CSS, HTML, or server, and a bug might only
manifest itself on one browser or operating system. On top of that, debugging
gadgets is harder because everything is contained inside an iframe on a parent
page, and you have to make sure the bug actually originates from your iframe
and not the rest of the page. And then, finally, a Wave gadget is "Wave-y"
because it involves syncing states across multiple participants, and now you
have to figure out if the bug is in the state sharing, and if so, try to
replicate that bug by simulating a sequence of participant interactions.

So, yes, debugging can be hard - but there are ways to make it easier. If
you're new to debugging on the web, read this article on using Firebug for
debugging. If you're new to debugging gadgets, read this article from the Gadget
's developer guide. And if you're new to debugging Wave gadgets, well, you're
in the right place.

This article will step through a variety of suggestions that will make gadget
debugging easier. Note that the Google Wave sandbox as well as the Google Wave
APIs are in preview mode, and we hope to create tools to make debugging easier
in the future and update this article accordingly.

.. toctree::

Reloading New Code
------------------

Many gadget containers offer developer tools to reload a gadget for testing
purposes, so that the developer does not have to reload the entire page. The
Google Wave client does not offer any similar mechanism, so you have two
options for reloading your gadget after you've changed the code:

* If using Firefox, you can right-click on any part of the gadget and click
  "Reload iframe". This will take a few seconds to just reload your gadget, and
  not the rest of the page.
* If you're not using Firefox, there are a few possibilities:
  * You can reload the entire page. To make the page load faster, maximize the
    window for the wave so that all of the other windows are closed.
  * You can load a different Wave than the one you are debugging (any arbitrary
    one will do), and then switch back to the original one. To make this
    technique faster, pick a second wave that's short. Or, you could even have
    the gadget in both waves, and just switch back and forth. Your gadget may
    hold different states in each instance, but that may be fine for what you
    are debugging.

Simulating Multiple Users
-------------------------

Since the power of Wave comes from collaboration amongst multiple participants,
you are most likely creating a gadget that responds to interaction from
participants. This collaborative model means that debugging your gadget can be
hard, particularly if your gadget expects high-speed interaction. Ideally, you
would always be sitting next to a willing tester, and you could watch them as
you both simultaneously use the gadget on different computers.

Assuming this is not an option, an acceptable alternative is for you to open
your gadget while logged into two different accounts. You can register for
multiple accounts, like "johndoe@wavesandbox.com" and
"johndoe-test@wavesandbox.com", and then use them both simultaneously. You may
log into 2 different Wave accounts using several techniques:

* Use two different computers. If you happen to have a desktop/laptop or other
  multi-computer setup, you might prefer this technique.
* Use two different browsers. For example, if you use Firefox as your main
  browser, then you could open the gadget in Chrome or Safari at the same time.
* Use two profiles with the same browser. Firefox has a feature for power
  developers that lets them create multiple profiles and open up multiple
  instances of FF at the same time, provided each has a different profile. See
  Mozilla's article on Managing Profiles.
* Use multiple cookies in the same browser instance. A third-party extension
  for Firefox called CookiePie exists that lets you use different cookies in
  each browser tab, meaning that you can log in to 2 different Wave accounts in
  the same browser. Download this extension from the Nekstra website.
* Use Chrome in "incognito mode". In this mode, cookies are wiped clean for
  each new window, so it is possible to login to multiple accounts in two
  different tabs.

In every technique except the first, you should resize both browser windows to
have 50% width so that you can quickly click on each, and see what's happening
in both at the same time.

Generally, the advantage of using the same browser, like in the last two
techniques, is that your debugging environment is the same and you can safely
eliminate cross-browser issues as the cause of discrepancies between each
instance of the gadget. On the other hand, after you have debugged the
fundamental flow of your gadget, you may specifically want to test the gadget
in multiple browsers at once, to check that you haven't introduced any
cross-browser issues. The best debugging approach likely involves a mix of the
above techniques at different stages in the development cycle, and every so
often, begging a friend or family member to be your live tester.

Debug Messages
--------------

Programmers commonly output messages to the screen to indicate the program and
variable state. JavaScript programmers commonly make the mistake of using the
window.alert() function to output these messages. This function is used because
it's simple to call and exists in all browsers, but it's simplicity is also
dangerous. An alert() can change the flow of a JavaScript program, particularly
one that involves any asynchronous callback functions like Wave gadgets, so
the alert() can both make you think your program works when it doesn't, and
make you think your program doesn't work when in fact it does. In addition,
each alert() prompt must be formally closed by the user, making debugging quite
slow, particularly if you accidentally code an infinite loop.

Thankfully, many of the modern browsers (Safari, Chrome, Firefox w/Firebug) now
offer a console.log() function, and it will print everything from strings to
objects without blocking program execution.

.. code-block:: javascript

   console.log("The score is now: " + score);
   console.log(wave.getState());


If you're using a browser that doesn't support that function, you can write
string-based messages to a DIV on the screen. This may slightly slow down your
program execution, but if you keep the number and length of messages to a
minimum, then the impact shouldn't be significant.

.. code-block::javascript

   document.getElementById("debugDiv").innerHTML += "The score is now: " + score;
   <div id="debugDiv" style="width:100%; height:200px; overflow:scroll"></div>

The Gadgets API provides a MiniMessages library that makes writing strings to a
DIV even easier, and adds a few features like close buttons and timer-based
closing. To use this library, you must add another <Require> tag under the one
that requests the wave-preview library, construct a new instance of the
MiniMessage class with a designated DIV, and then call one of several
create-message functions:

.. code-block:: javascript

   <Require feature="minimessage"/>

   var msg = new gadgets.MiniMessage(__MODULE_ID__, document.getElementById(
         "messageBox"));
   msg.createDismissibleMessage("The score is now: " + score);

Since you may be testing your gadget on browsers that do not support the
console functions, or you may be asking non-developers to test your gadget for
you, you might consider a solution that mixes the two options. The function
below uses console.log() if supported, and falls back to MiniMessages if not:

.. code-block:: javascript

   function logThis(obj) {
      if (window.console && console.log) {
        console.log(obj);
      } else {
        msg.createDismissibleMessage(obj.toString());
      }
   }


Conditional Debugging
---------------------

When you are beginning your gadget development, you will likely want to be in a
constant debug mode and always see your debug output. When your gadget is
mostly done or ready for general use, you will want to turn off debug output
for your users, but allow you to turn this output on when necessary for
debugging. Web developers often achieve this conditional debugging by setting
a debug flag on their URL, and using the existence of that flag to turn on
debug mode.

Gadget developers cannot set a debug flag through the URL, but they can get a
similar result by creating and setting a user preference in the gadget XML.
The example below creates a Boolean-type preference called "debugMode", which
you can set to true when in the development stage, and to false once deployed
to consumers.

.. code-block:: xml

   <UserPref name="debugMode"
                         display_name="Debug Mode"
                         datatype="bool"
                        default_value="true">
   </UserPref>

To use the value of that preference, you must construct a new instance of the
Prefs() class, then retrieve the boolean value of the preference, and check
for this value within your code when outputting debug messages.

.. code-block:: javascript

   prefs = new gadgets.Prefs();
   var debugMode = prefs.getBool("debugMode");

You can then insert a line in your logging function that only logs if the debug
mode boolean is true:

.. code-block:: javascript

   if (debugMode) {
     ...
   }


Currently, the Google Wave client does not offer an interface for specifying
user preferences when adding a gadget to a Wave through the Debug->Extensions
menu, but it does offer a text box to specify the preferences as a JSON object.
For instance, if you wanted to test your gadget with debugging off, then you
could pass in {"debugMode": "true"}. Note that although the debugMode
preference is a boolean, the value is passed in as a string.

Wave Debug Log
--------------

The Google Wave sandbox client comes with its own debug log, which the
development team uses for troubleshooting issues, but can also be used by
gadget developers for monitoring changes in the gadget state.

To enable the debug log, you first need to insert "?ll=debug" after the last
slash in the URL and before the first "#":


https://wave.google.com/a/wavesandbox.com/?ll=debug#restored:wave:wavesandbox.com!w%252Bbwihmm04%2525B.1

Reload the page after changing the URL. From the Debug Menu, choose the newly
listed option at the top called Show debug log. A console will pop up
underneath the currently opened wave. To filter the output of that console to
only show gadget-relevant messages, click gadgets. While that console is open,
you will see all of the state changes that the gadget sends. You can clear or
close the console at any time.

In addition to seeing state changes, you can also output messages to this log
using the wave.log() function, and each message will be prefixed with a
timestamp:

.. code-block:: javascript

   wave.log("Storing state");

You can add this utility method to the arsenal of message outputting techniques
from the above section. Note that this function can only output strings,
whereas the console.log() function can output any JavaScript object in a way
that makes them easier to inspect, so wave.log() is more equivalent in utility
to the write-to-DIV techniques.

Storing All States
------------------
The above techniques can be useful when debugging the state changes in one view
of a gadget, but it can be tricky to debug the state changes happening
simultaneously in two views of a gadget, particularly if they happen very
quickly.

One way of debugging the sequence and content of state changes from all
participants in a gadget is to save those state changes to a file or database
on a server.

Before doing any state saving, you first need to assign an identifier to each
gadget "session" - i.e. there should be a different number for each Wave that
a gadget is embedded in. This identifier will allow you to save per-Wave logs,
reflecting only the sequences of state for the gadget in one Wave, but for all
participants on that gadget. You should generate the identifier when the gadget
is first embedded in the Wave &mdash when the first participant is viewing the
gadget for the first time. You can use the Date() class to generate a unique
ID, and then save that ID into the state, so that all participants will see it.

.. code-block:: javascript

   var newDate = new Date();
   var stateDelta = {"sessionId": ("" + newDate.getTime() + "")};
   state.submitDelta(stateDelta);

Now, everytime that you submit a state delta, you should save that delta into
a file on your server, where the filename includes the unique identifier. To
send the delta to your server, you can use the Gadgets API makeRequest()
function, and pass the ID and a stringifed version of the state delta as POST
parametrs.

.. code-block:: javascript

   function submitDelta(state, stateDelta) {
     state.submitDelta(stateDelta);
     var url = "http://www.mydomain.com/storestate.php";
     var params = {};
     postdata = gadgets.io.encodeValues({
             id: state.get('sessionId') || stateDelta['sessionId'],
             state: JSON.stringify(stateDelta)});
     params[gadgets.io.RequestParameters.METHOD] = gadgets.io.MethodType.POST;
     params[gadgets.io.RequestParameters.POST_DATA]= postdata;
     gadgets.io.makeRequest(url, function(){}, params);
   }

To save the delta to your server, you can setup a script that retrieves the
state and ID from the POST parameters, and appends the state to the file
identified by the ID. If the file doesn't exist yet (if it is the first
submission of a state delta), then the script needs to create the file first.

.. code-block:: php

   <?php
   $state = $_POST["state"];
   $id = $_POST["id"];

   $filename = "wavestate_" . $id . ".txt";
   $fp = fopen($filename, "a+");
   fwrite($fp, "\"" . $state . "\",\n");
   fclose($fp);
   ?>

Now, whenever you are testing your gadget, you can load the debug file for the
current ID and see what deltas are being submitted by various participants.
This technique is particularly helpful if you're testing with participants that
are located remotely.

Note that you could attain similar debug information using a database and a
language like Python or Java; the PHP file-writing code is just one possible
variation.

Re-playing State Changes
------------------------

When you're developing a gadget and debugging, you may find yourself tire of
constant gadget interaction to trigger state changes. Conveniently, if you
followed the design pattern above of storing state to your server, you can
re-play those state changes in your gadget, and save yourself the effort.

First, create a few form fields and a button in your gadget, so that you can
enter the desired session ID and speed for playback. Connect a function to the
button that will load the state deltas to playback:

.. code-block:: html

   <div id="testBox" style="display:none">
       Id: <input id="idText" type="text" value="1251874497293"/>
       MS: <input id="speedText" type="text" value="2000"/>
       <input id="testButton" type="button" value="Test" onclick="loadStateDeltas()" disabled/>
   </div>

Then, inside that function, load the state deltas for the given ID by
requesting them in JSONP form from your server. This function first needs to
restate the state in your gadget, and that can be done by submitting a state
delta where each key is set to null.

.. code-block:: javascript

   function loadStateDeltas() {
     resetState();
     var id = document.getElementById("idText").value;
     var script = document.createElement("script");
     script.src = "http://imagine-it.org/google/wave/getdeltas.php?id=" + id;
     document.body.appendChild(script);
   }

   function resetState() {
     var state = wave.getState();
     wave.setStateCallback(function() {});
     var stateDelta = {"key1": null, "key2": null, "key3": null};
     state.submitDelta(stateDelta);
   }

The PHP script on your server can read the file and pass the concatenated
deltas as a JavaScript array into a callback function which you'll define in
your Gadget code:

.. code-block:: php

   <?php
   $id = $_GET["id"];

   $filename = "wavestate_" . $id . ".txt";
   $deltas = file_get_contents($filename);
   echo "onStateDeltasLoaded([" . $deltas . "]);";
   ?>

The callback function submits each state delta using window.setInterval at the
given speed:

.. code-block:: javascript

   function onStateDeltasLoaded(stateDeltas) {
     var speed = parseInt(document.getElementById("speedText").value);
     var state = wave.getState();
     wave.setStateCallback(stateCallback);
     var currentNum = 0;
     window.setInterval(function() {
       state.submitDelta(JSON.parse(stateDeltas[currentNum]));
       currentNum++;
      }, speed);
   }

Once you've implemented the ability to re-play state, you might want to enable
the re-play functionality using user preferences as noted above in Conditional
Debugging.

Conclusion
----------

You may find yourself using only some of these suggestions, using all of them,
or coming up with your own variations. The techniques you use depend largely on
the type of gadget that you're creating, and your typical development
environment. Either way, please do share your ideas and feedback in the
Google Wave APIs discussion forum.