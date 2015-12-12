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

Events
======

The Google Wave Robots API is primarily event driven. Robots register for
events, and may respond to events with their own operations. (Note, however,
that the Active Robot API allows robots to initiate operations on their own.)
This document discusses the Robot event model, what events a robot can register
for, and what data gets passed into the event.

A robot (as opposed to a gadget) actively participates in the wave through HTTP
requests and responses using a protocol. You don't need to know the
particulars of this protocol, however, as we provide both Java and Python
client libraries which you can use to create and manage your robots. If you
wish to peer into the internals of the protocol, consult the Wave Robot HTTP
Protocol documentation.

Note that events and operations are intimately tied together, but neither
requires the other. Your robot may listen to events and not initiate operations
in response; as well, a robot could initiate its own operations outside of the
event model.

.. toctree::

Events
------

Events are activities which occur within the Google Wave client for which you
can register, so that you can react to the event by performing an action.
The robot API is primarily an event-driven programming model. Things happen in
the Wave, and you wait for notification of those events and respond in turn.
The API provides several components to help you implement actions to take in
response to events:

* Each API client library defines a set of event handlers which you can
  override (intercept) to provide behavior when the event occurs.
* Each event is passed a typed event object that contains data specific to that
  event.
* Each event passes a context of the current wave where the action occurs. You
  may use the default context provided by the event, or override this default
  to augment or limit the context.

The following sections discuss each of these concerns.

Event Scope
-----------

Events may occur on different elements in the Wave model, which define the
scope for the encapsulated event:

* Wavelet events occur on the wavelet level, but usually have limited scope.
  For example, WAVELET_SELF_ADDED occurs only when a robot adds itself to a
  wave.
* Blip events occur on the blip level. These events are typically more frequent.

A special type of Blip event is that of Document scope, which occur whenever
the contents of individual blips (or data documents) change. These events are
the most granular events within the Wave model, and also the most general. The
DOCUMENT_CHANGED event, for example, is generated each time text is altered.
When using such an event, consider using event filtering to limit the scope for
such events.

In addition, the Wave API defines events which indicate changes in other
associated objects such as gadgets, form buttons, and annotations.

Event Handlers
--------------

Events are generated in the Wave model and communicated to your robots via the
Robot HTTP Protocol. Each client API defines a set of event handlers which will
get triggered when the event occurs.

You handle an event by overriding the event handler (in Java) or registering an
event handler (in Python) and providing code to execute when the event occurs.
(In Java, you should indicate this is an override by using the @Override
keyword.)

For example, when a robot is added to a wave, the Google Wave client will
trigger a WAVELET_SELF_ADDED event using the Robot HTTP protocol, which will
cause the client library to invoke the robot's OnWaveletSelfAdded() event
handler when the robot receives this event:

.. code-block:: python

   def OnWaveletSelfAdded(event, wavelet):

     # Put Event Handling Code Here. We'll just reply.
     wavelet.reply("\nHi everybody! I'm a Python robot!")

As you can see, the event handler is passed the event object and wavelet data
that contains the state of the Wavelet at the time the event occurred. Note
that you can't make guarantees that the wavelet hasn't changed since you've
received the event.

Event Objects
-------------

Events within the Wave API V2 are typed. Each event passes data particular to
its event within a typed event object. For example, within the Python library,
events handled by OnWaveletSelfAdded()pass a WaveletSelfAdded event object to
the handler. (Java events are named ObjectEvent as is customary for event
objects within Java.)

In general, each event passes at least one property: blipId. For Blip level
events, the Blip ID references the blip on which the event occurred. For
Wavelet level events, this blipId corresponds to the ID of the "root blip."
Every wavelet must contain at least one root blip, which will include at least
the newline (\n) character. (There is no such thing as a completely empty
wavelet.)

.. note::
   the blipId always holds the ID of the root blip for Wavelet level events,
   even in cases where you might think the ID refers to another blip (such as
   in WAVELET_BLIP_CREATED). In those cases, the blip of interest is indicated
   by another property (such as newBlipId).

The table below summarizes the event data which gets passed in the event object for each event:

.. csv-table::
   :header: Event,Event Data Passed,Default Wavelet Context
   :delim: ~

   WaveletBlipCreated         ~blipId, newBlipId                              ~PARENT, CHILDREN, ROOT, SELF
   WaveletBlipRemoved         ~blipId, removedBlipId                          ~PARENT, CHILDREN, ROOT, SELF
   WaveletParticipantsChanged ~blipId, participantsAdded, participantsRemoved ~PARENT, CHILDREN, ROOT, SELF
   WaveletSelfAdded           ~blipId                                         ~PARENT, CHILDREN, ROOT, SELF
   WaveletSelfRemoved         ~blipId                                         ~PARENT, CHILDREN, ROOT, SELF
   WaveletTagsChanged         ~blipId                                         ~PARENT, CHILDREN, ROOT, SELF
   WaveletTitleChanged        ~blipId, title                                  ~PARENT, CHILDREN, ROOT, SELF
   BlipContributorChanged     ~blipId, contributorsAdded, contributorsRemoved ~PARENT, CHILDREN, ROOT, SELF
   BlipSubmitted              ~blipId                                         ~PARENT, CHILDREN, ROOT, SELF
   DocumentChanged            ~blipId                                         ~PARENT, CHILDREN, ROOT, SELF
   FormButtonClicked          ~blipId, button                                 ~PARENT, CHILDREN, ROOT, SELF
   GadgetStateChanged         ~blipId, index, oldState                        ~PARENT, CHILDREN, ROOT, SELF
   AnnotatedTextChanged       ~blipId, name, value                            ~PARENT, CHILDREN, ROOT, SELF

Event Context
-------------

The Wave API not only responds to events by noting that the event occurred, and
passing data associated with that event, but also provides the context for that
event. Contexts are defined with respect to the Blip level. The following
contexts are possible:

* PARENT indicates that the event should pass the parent data. Note that PARENT
  makes no difference to Wavelet events.
* CHILDREN indicates that the event should pass any children of the event's
  level. For Wavelets, this context passes all child Blips.
* ALL indicates that the event passes all associated data.
* SIBLINGS indicates that the event passes any siblings. For Blips, this
  context will pass data for all sibling blips within the Wavelet.
* SELF indicates that the event only passes information pertaining to itself.
* ROOT indicates that the event only passes information pertaining to the root
  blip.

By default, the Wave API passes PARENT, CHILDREN, ROOT and SELF. All told, this
context includes a lot of data within each event. You may find it better to
restrict the event to pass more limited information if you find that you don't
need the extraneous data. On the other hand, if you find yourself needing more
context than supplied by default, you can register an event using a context of
ALL, which will pass all Blip content within a wave.

To alter the context of an event in Python, pass an additional context argument
when registering the event handler:

.. code-block:: python

   myrobot.register_handler(events.WaveletParticipantsAdded, OnWaveletParticipantsAdded,
     context = [events.Context.SIBLINGS, events.Context.PARENT])

In Java, use a special @Capability annotation:

.. code-block:: java

   @Capability(contexts = {Context.SIBLINGS, Context.PARENT})
   @Override
   public void onWaveletSelfAdded(WaveletSelfAddedEvent event) {

     // Your event handling here
   }

Event Filtering
---------------

Registering for events in the Robots API can quickly become quite a noisy
business. Some events are — by design — generated very frequently, such as the
DOCUMENT_CHANGED event, which is fired every time the wave changes. Monitoring
frequent events adds a lot of communication chatter between your robot and
Google Wave, using up precious App Engine quota, making robots slower, and, of
course, putting a strain on our internal Wave infrastructure.

Some robots have good reasons to receive events such as these in their
entirety; a robot which needs to act on the entire wave content, responding
with immediate user feedback, would need to handle such events. However,
sometimes a robot is only interested in certain cases when handling frequent
events. For example, you might wish to check whether the user entered an email
address and operate on that text. You could reduce communication traffic by
registering BLIP_SUBMITTED, but doing so would take away from the liveliness of
the user experiencel however, handling DOCUMENT_CHANGED for such a rare case
adds too much communication traffic. Instead, we should apply an event filter
on the DOCUMENT_CHANGED event, only sending the event to the robot if it
satisfies certain conditions.

Event filters allow developers to specify an optional regular expression when
registering the event. The exact meaning of the regular expression depends on
the event filtered, but typically Google Wave will match the value associated
with the event against the specified regular expression; if an only if there is
a match, Google Wave will send out the event.

For example, a robot may wish to replace text contained in double square
brackets ([[Amsterdam]]) with links to corresponding Wikipedia articles. We can
do so by registering a regular expression for "\[\[.*\]\]" on the
DOCUMENT_CHANGED event.

The following code snippet registers a filter using the Python SDK:

.. code-block:: python

   myrobot.register_handler(events.DocumentChanged, onNewMatch, filter="\[\[.*\]\]")

The following code snippet registers a filter using the Java SDK:

.. code-block:: java

   // Note that "\" is an escape character in Java strings, so it must be double escaped.
   @Capability(filter = "\\[\\[.*\\]\\]")

   @Override
   public void onDocumentChanged(DocumentChangedEvent event) {
     ...
   }

This filter ensures that our robot only gets called once the filter has been
satisfied. However, note that once the filter matches, it will continue to
match for any events of that type until the filter no longer matches. In
practice, this means that you may wish to alter the regular expression in some
manner after the match occurs, so it doesn't "rematch." Put another way, the
regular expression is matched against the full content of the blip that
changed, not just the specific content that changed. This behavior may change
in the future.

Filtering is currently supported in the following events:

* DOCUMENT_CHANGED: Applies the RegEx to the text of the blip.
* ANNOTATED_TEXT_CHANGED: Applies the RegEx to the key of the changed
  annotation.

For events other than DOCUMENT_CHANGED, different values can be matched. We
expect to add to the number of events that support filtering as the API
develops.

Inspecting Robot Capabilities
-----------------------------

You define the behavior of your robot by defining the events which you wish
your robot to be notified. The Wave API client libraries examine this behavior
and automatically generate a special file, the capabilities.xml, to denote the
robot's behavior.

The capabilities.xml File
^^^^^^^^^^^^^^^^^^^^^^^^^

A sample capabilities.xml file is shown below:

.. code-block:: xml

   <w:robot xmlns:w="http://wave.google.com/extensions/robots/1.0">
   <w:version>ffffde4b96ce40f6</w:version>
   <w:protocolversion>2.0<protocolversion>
   <w:capabilities>
     <w:capability name="BLIP_SUBMITTED" context="PARENT,CHILDREN,ROOT"/>
     <w:capability name="DOCUMENT_CHANGED" context="PARENT,CHILDREN,ROOT"/>
   </w:capabilities>
   </w:robot>

.. note::
   that this file contains a single <capabilities> element consisting of one or
   more <capability> elements. Each capability consists of an event which the
   robot indicates to Wave its interest. When an event of that type occurs,
   the Wave will dispatch to the robot an HTTP request.

Every robot will serve its configuration file at the following URL path:

http://applicationURL/_wave/capabilities.xml

In practice, you don't need to worry about generating this file; however, when
debugging, you may find it useful to retrieve the file to ensure your robot's
capabilities are set up correctly.

Robot Versioning
^^^^^^^^^^^^^^^^

Additionally, the client libraries generate a unique hash value based on the
robot capabilities, which is stored in the version parameter. When the Wave
API encounters an event which the robot may be interested in, it checks this
file and the hash value it stores locally. If the hash value is different than
what it has locally, it will retrieve a new version of the file. This ensures
that if you change a robot, the Wave server will know about it.