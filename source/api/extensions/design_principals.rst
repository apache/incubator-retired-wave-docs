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

Design Principles
=================

Before reading this document, please read through the Extensions Overview.

The Google Wave environment is a highly interactive communication environment.
As such, it provides both rewards and challenges to programmers wishing to
extend its functionality. The following design principles can help you develop
extensions that both utilize the power of Wave and also play well within the
Google Wave environment.

.. toctree::

Make it "Wave-y"
----------------

Wave is all about real-time communication and collaboration, and your extension
should do the most to take advantage of that. A wave may have multiple
participants who interact with the extension and (in the case of gadgets)
change its state. A true wave extension should handle each of the following
tasks elegantly:

* Display any shared state
* Indicate active participation by users
* Provide real-time interactivity

A "wave-y" gadget should encourage collaborative participation by using state
objects to store a shared state across participants and reflect that shared
state within the user interface. A wave-y gadget should both handle concurrent
participation while also indicating the contributions of active participants
through the user interface.

For example, a crossword gadget could let multiple participants on a wave solve
the puzzle together. The gadget should allow any participant to enter solutions
while displaying all letters on the grid (perhaps colored differently according
to participant usage). As well, the gadget should display global statistics for
the current number of correct letters and words for each participant. As a
general rule, if you're using a gadget concurrently with another participant,
you should both be aware of each other's actions to the fullest extent
possible. Variations in the view between participants should only serve to
distinguish a particular viewer's state more clearly (such as bolding the
viewer's score in their view).

A "wave-y" robot should react in real-time, responding to user's actions
immediately if the extension sees something relevant to its functionality.
A robot should also act as a co-operative participant and should play well with
other robots. You shouldn't need to instruct users to avoid combining your
robot with other robots; each should work and complement each other. Ideally,
your robot should "mash up" well with other robots to amplify functionality.

For example, the code highlighting robot Syntaxy and the code compiling robot
named Monty were developed independently. When placed in the same wave,
however, they together allow a user to compile syntax-highlighted code: a match
made in robot heaven!

A nice way to take advantage of both the real-time and collaborative nature of
Wave is to create a robot that responds to events by inserting a gadget with
shared state. For example, a robot may monitor a Wave for mentions of
"shopping" and insert a shopping gadget which allows participants to create a
shopping list together.

Make It Easy to Use
-------------------

Google Wave is a real-time collaborative communications client, and for many
people, offers a new and different user experience. For new users who have
likely never had conversations with robots and may not be used to
character-by-character updates, this interactivity presents a bit of a learning
curve. To ease users into this new model of communication, you should make your
extensions easy to use and understand.

A gadget should provide clear instructions for its use, and note any display
and usage of shared state. For example, a drawing gadget might include
instructions to "Draw on the whiteboard with a clicked mouse. When you are done
drawing, release the mouse to complete your drawing; other participants will
see your line. In turn, when other participants are done drawing, their lines
will show up on your whiteboard." These instructions may seem painfully
obvious, but a gadget could implement state-sharing in many ways, so it is
important to let people know how the data is shared — especially if there is
sensitive or private data involved.

On the contrary, a robot should be simple and intuitive enough to not require
instructions. Many robots search for particular patterns of input and respond
to those patterns by modifying the Wave. A robot should be smart enough to
recognize normal human text, and not have to instruct the human to format input
in a particular way.

For example, a mapping robot should search the Wave for anything that looks
like an address without requiring the user to prefix an address with keywords
such as "map:" or "address:". Robots may be able to handle such parsing more
easily, but it will make your robot that much more difficult to use. Humans
are not likely to change the way they write to suit a robot's requirements.
As well, such a robot is much less likely to interact smoothly with other
robots. Even though parsing human text is more difficult, you should cater to
natural language wherever possible.

Note: Currently, users need to click a toolbar icon to enable a robot on their
Wave once they've realized there's something of particular relevance on the
Wave (like an address). We recognize that this behavior is not ideal. In the
future, we will enable extensions to subscribe to certain input signals
(such as "address" or "phone" or even generic regular expressions) and allow
robots to recognize such input and ask the user if they would like to enable
the robot. This auto-recognition should make the robot experience more user
friendly.

Make It Easy to Install
-----------------------

An extension installer not only provides a convenient way to install
extensions, but a consistent paradigm across all types of extensions as well.
Extensions installed in such a manner will provide common UI within the wave
client for initiating the extension, either within the New Wave menu or within
the wave's toolbar.

In the preview of Google Wave, users will have access to an extension gallery
that lets them quickly browse among available extensions, and install the ones
that look promising to them. By providing such a one-stop shop, users will
become accustomed to installing extensions using an installer. We encourage you
to use extension installers, rather than by adding a robot by participant or
embedding a gadget by URL, as the installer provides a common and easily
understood paradigm which users will become accustomed to using.

An installer is also a great way to enable viral spread of your extension.
When you create a Wave with your installer, you can share it directly within
Wave with your friends, who can in turn share it with other friends. In just a
short period of time, dozens of users could be installing your extension just
by clicking the Install button.

Help users have a consistent experience: make an installer!

Make It Look Good
-----------------

Google Wave may revolve around text-based communication, but it is a highly
visual experience, with images and colors making collaboration easy to
understand. Your extension should complement that visual experience.

If your extension adds an icon to the toolbar menu, put a lot of thought into
that icon. When a user looks at it, they should immediately recognize it for
what it does, and they shouldn't confuse it with other extensions. Try to make
the icon be specific, recognizable, and aesthetically pleasing. If your
extension integrates an external product, consider using the product's logo.

A good looking robot should have a full profile: a name, thumbnail, and URL
for more information. The thumbnail will show up as the robot's avatar within
the robot's profile card so, as with any toolbar icons, pick a recognizable
icon. Ideally, the robot's avatar image should be a larger version of its
toolbar icon, or somehow related to it. The user should instantly be able to
associate the icons with each other and recognize that the toolbar icon
initiates that robot.

A good looking gadget should look like a well-designed miniature
web-application because, well, that's what it is. Besides following good web
design guidelines, a gadget should respond well to being flexibly-sized.
Because a user can resize their Google Wave client, and indeed each panel
within Wave, to any size, your gadget can't assume any given dimensions are
available (though it generally can expand vertically). Generally, you should
size by percentage and use the gadget's dynamic height library to adjust
dimensions if the gadget needs more space for its content. You should avoid
ever showing scrollbars, since these scrollbars will conflict with the
scrollbars on the Wave panel itself, and users hate nested scrollbars. Finally,
a gadget should have a well-defined "area" for it to display itself,
differentiated markedly from content in its containing Wave, so that users
don't get confused and think they are typing inside a Wavelet.

Make It Useful — or Fun!
------------------------

It is our hope that this point is self-explanatory. If you aren't sure if your
extension is useful or fun, send it to your parents and see if they beam with
pride when they use it. :)