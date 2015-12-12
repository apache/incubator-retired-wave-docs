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

HTTP Protocol
=============

Robots within Google Wave behave and act like any normal participants. However,
unlike human participants, they do not interact directly with the Google Wave
client application. Instead, they use a protocol to interact with Google Wave,
which consists of messages that get sent back and forth to the Google Wave
server. This protocol consists of events which get sent to the robot and
operations which the robot initiates.

This communication protocol is known as the Google Wave Robot HTTP Protocol
(or Robot Protocol for short). In most cases, you may not need to know exactly
what's in this protocol; you can simply use the existing client libraries, and
let them take care of handling and transmitting the appropriate messages over
the "wire."

However, understanding the protocol can help you debug your Robots much more
efficiently, allowing you to inspect and understand the messages which get
transmitted and received. As well, understanding the protocol allows you to
directly communicate with Wave without use of a client library, and could
potentially allow you to create your own client library.

.. toctree::

What Is the Robot Protocol?
---------------------------

The Robot Protocol is a set of messages sent over HTTP that consists of the
following components:

* JSON Message Bundles (containing events) sent from Wave to the Robot
* JSON-RPC operations which the Robot sends back to Wave in response to events
* The Active Robot API, which allows robots to initiate operations instead o

The Robot API which we will discuss here is event-driven, meaning that the
Robot sends operations to Wave in response to events in which it indicates an
interest. The robot then performs actions in response to those events by
sending operations back to Wave.

We will delve a little deeper into each of these messages in the following
sections.

Message Bundles
---------------

When the Wave event system determines that an event has occurred for which a
robot has expressed an interest in being notified, Wave creates a JSON Message
Bundle and sends the message to the robot. Each bundle consists of one or more
components:

* An events element, containing information related to the event
* Optional blips and/or wavelet elements, which may be attached depending on
  the type of event
* Metadata attached to the event, usually information about the robot itself
  such as robotAddress

.. note::
   JSON objects, being associate containers, exhibit some of the same
   properties as a hash map, and may be ordered in any arbitrary fashion. As a
   result, you may not assume that any particular elements at the same nested
   level arrive in a particular order.

Additionally, the Wave event system may bundle multiple events into one events
element and send those as one package. Events within any given bundle will
always pertain to a single wavelet. Any event blips and wavelet state reflect
the state of the client Wave when the event(s) occurred, but may not reflect
the current state of that client. (You should never assume that a Wave hasn't
changed since an event has arrived.)

For example, the following JSON message bundle contains an event bundle for the
BLIP_SUBMITTED event:

.. code-block:: json

   {
     "events":[{
       "modifiedBy": "user@example.com",
       "timestamp": 1255935016481,
       "type": "BLIP_SUBMITTED",
       "properties": {
         "blipId": "b+ja8F_Hw4J"
       }
     }],
     "wavelet": {
       "creationTime": 1255934856713,
       "creator": "user@example.com",
       "lastModifiedTime": 1255935016481,
       "participants": [ "user@example.com","user2@example.com" ],
       "rootBlipId": "b+ja8F_Hw4J",
       "title": "",
       "version": 11,
       "waveId": "example.com!w+ja8F_Hw4I",
       "waveletId": "example.com!conv+root",
       "dataDocuments": {
       }
     },
     "blips": {
       "b+ja8F_Hw4J": {
         "annotations": [{
           "range": {
             "start": 0,
             "end": 1
           },
           "name": "conv/title",
           "value": ""
         }],
         "elements": {},
         "blipId": "b+ja8F_Hw4J",
         "childBlipIds": [],
         "contributors": ["user@example.com"],
         "creator": "user@example.com",
         "content": "\n",
         "lastModifiedTime": 1255934856708,
         "version": 6,
         "waveId": "google.com!w+ja8F_Hw4I",
         "waveletId": "example.com!conv+root"
       }
     },
     "robotAddress": "myrobot@example.com"
   }

The following sections will explain the elements and fields within this message
bundle in more detail.

Events
^^^^^^

Events within a message bundle are passed within an events element which
contains the following fields:

* type indicates the type of the particular event.
* modifiedBy indicates the participant whose action triggered this event.
* timestamp indicates the "Unix time" at which this event occurred. Note that
  this time is expressed in UTC as milliseconds since the epoch (midnight,
  January 1, 1970).
* properties contains a list of properties attached to this event, which vary
  depending on the type of event which has occurred.

In the previous example, the event BLIP_SUBMITTED passed as one of its event
properties values a blipId corresponding to the blip which was in fact
submitted. This property is always passed for all events. For BLIP_ events, the
blipId corresponds to the ID of the blip on which the event occurred. For
WAVELET_ events, this blipId corresponds to the ID of the "root blip."

.. note::
   the blipId always holds the ID of the root blip for WAVELET_ events where
   you might think the ID refers to another blip (such as in
   WAVELET_BLIP_CREATED). In those cases, the blip of interest is indicated by
   another property (such as newBlipId).

Events may pass additional properties in addition to the blipId. A table of
events and associated properties appears below:

.. csv-table::
   :header: Event, Properties, Description, Type
   :delim: ~

   WAVELET_BLIP_CREATED~blipId,newBlipId~Blip ID of the root blip, Wave blip ID of the added blip~String, String
   WAVELET_BLIP_REMOVED~blipId, removedBlipId~Blip ID of the root blip, Wave blip ID of the removed blip~String, String
   WAVELET_PARTICIPANTS_CHANGED~blipId, participantsAdded, participantsRemoved~Blip ID of the root blip, Addresses of the participants added and/or removed~String, Array of Strings
   WAVELET_SELF_ADDED~blipId~Blip ID of the root blip~String
   WAVELET_SELF_REMOVED~blipId~Blip ID of the root blip~String
   WAVELET_TAGS_CHANGED~blipId~Blip ID of the root blip~String
   WAVELET_TITLE_CHANGED~blipId,title~Blip ID of the root blip,New title~String,String
   BLIP_CONTRIBUTORS_CHANGED~blipId,contributorsAdded,contributorsRemoved~Blip ID of the blip, Addresses of the contributors added and/or removed~String,Array of Strings
   BLIP_SUBMITTED~blipId~Blip ID of the submitted blip~String
   DOCUMENT_CHANGED~blipId~Blip ID in which the change occurred~String
   FORM_BUTTON_CLICKED~blipId, button~Blip ID of the blip containing the form, Name of the clicked button~String, String
   GADGET_STATE_CHANGED~blipId, index, oldState~Blip ID of the blip containing the gadget, Index of the gadget that changed within the document, Previous state of the gadget~String, Number, String
   ANNOTATED_TEXT_CHANGED~blipId, name, value~Blip ID containing the annotated text, Name of the annotation, Value of the annotation~String, String, Number

Content Attached to Events
--------------------------

Message bundles not only respond to events by denoting that the event occurred
(passing that information within an events element) but also pass data
appropriate to the event as well. In most cases, this data will consist of
wavelet and blips elements.

Wavelets
^^^^^^^^

A wavelet element consists of information pertaining to the particular wavelet
in which the event occurred. A wavelet element contains the following fields:

* creationTime denotes the Unix time at which this wavelet was created.
* creator denotes the address of the participant who created this wavelet.
* lastModifiedTime denotes the Unix time at which the wavelet was last modified
  by any participant.
* participants contains an array of participant IDs for all participants on the
  wave.
* rootBlipId contains the Blip ID of the root blip.
* title contains the title of the wavelet, which by default consists of the
  first line of text up to the first carriage return.
* version contains the version of this wavelet. Each atomic operation on a
  wavelet increases this version number.
* waveId contains the Wave ID of this wavelet.
* waveletId contains the wavelet ID of this wavelet. Note that for waves which
  contain only one wavelet (that don't have private conversations, in other
  words), this wavelet ID is usually of the form conv+root indicating that the
  wavelet is identical to the conversation root, the root wave.
* dataDocuments contains a dictionary (associated array) of the IDs and data of
  any data documents attached to this wavelet.

Blips
^^^^^

A blips element contains an array of blips within a single wavelet that
pertain to the event. A blip passed within an event will reference the blip in
which the event occurred, and any child blips of that blip. A blips array
contains the the following fields:

* blipId contains the ID of blip in which the event occurred.
* childBlipIds contains an array of blip IDs for each of the blip's children.
* contributors denotes participants who have contributed to the state of this
  blip.
* creator denotes the participant who created this blip.
* lastModifiedTime denotes the Unix time at which this blip was last modified
  by any participant.
* content contains the textual content of this blip.
* version contains the version of this blip. Each atomic operation on a blip
  increases this version number.
* waveId contains the Wave ID associated with this blip.
* waveletId contains the wavelet ID associated with this blip. Note that for
  waves which contain only one wavelet (that don't have private conversations,
  in other words), this wavelet ID is usually of the form conv+root indicating
  that the wavelet is identical to the conversation root, the root wave.

In addition, each blips[] array also contains an element for each specific blip
referenced within the event. These blips are indexed by their blip ID within
the passed JSON, and contain the following fields:

* annotations denotes an array of annotations associated with this blip. Each
  element in the array is a range consisting of a (zero-based) start and end
  text location, a name for the annotation, and a value for the annotation.
* elements specifies an array of elements associated with this blip, which
  include images, gadgets, and form elements.

Robot Metadata
^^^^^^^^^^^^^^

In addition to blips and wavelet elements, an event also passes metadata in any
event that identifies the robot. The following element is the only currently
supplied value passed in an event:

* robotAddress specifies the address of the robot that has been specified to
  receive this event.
* proxyingFor (optional) specifies the address of the robot that has been
  specified to receive this event.

Operations
----------

In response to events, the robot can send operations back to Wave. These
operations consist of JSON-RPC messages. A simple message which sets a wave's
title, creates a blip, and writes "Hello World" is shown below:

.. code-block:: json

   [{
     "params": {
       "capabilitiesHash": "b31821e"
     },
     "id": "0",
     "method": "robot.notifyCapabilitiesHash"
   },
   {
     "params": {
       "waveletId": "google.com!conv+root",
       "waveId": "google.com!w+ja8F_Hw4g",
       "waveletTitle": "A wavelet title"
     },
     "id": "op1",
     "method": "wavelet.setTitle"
   },
   {
     "params": {
       "blipId": "b+ja8F_Hw4h",
       "waveletId": "google.com!conv+root",
       "waveId": "google.com!w+ja8F_Hw4g",
       "blipData": {
         "blipId": "TBD_google.com!conv+root_1",
         "waveletId": "google.com!conv+root",
         "waveId": "google.com!w+ja8F_Hw4g"
       }
     },
     "id": "op2",
     "method": "blip.createChild"
   },
   {
     "params": {
       "blipId": "TBD_google.com!conv+root_1",
       "how": 0,
       "waveId": "google.com!w+ja8F_Hw4g",
       "text": "Hello World",
       "waveletId": "google.com!conv+root"
     },
     "id": "op3",
     "method": "document.modify"
   }]

Note that this JSON message contains no root element. Instead it contains a
params array, which in turn contains several methods. Each method contains
params appropriate to the particular operation. Operations are ordered by their
id value, even though operations are usually bundled together.

Operation methods operate on the following namespaces within the Wave system:

* robot operations
* wavelet operations
* blip operations
* document operations

.. note::
   that all blips contain a document as well, which contains their actual
   content, so most document operations also apply to Blips.

Operations
----------

In response to events, the robot can send operations back to Wave. These
operations consist of JSON-RPC messages. A simple message which sets a wave's
title, creates a blip, and writes "Hello World" is shown below:

.. code-block:: json

   [{
     "params": {
       "capabilitiesHash": "b31821e"
     },
     "id": "0",
     "method": "robot.notifyCapabilitiesHash"
   },
   {
     "params": {
       "waveletId": "google.com!conv+root",
       "waveId": "google.com!w+ja8F_Hw4g",
       "waveletTitle": "A wavelet title"
     },
     "id": "op1",
     "method": "wavelet.setTitle"
   },
   {
     "params": {
       "blipId": "b+ja8F_Hw4h",
       "waveletId": "google.com!conv+root",
       "waveId": "google.com!w+ja8F_Hw4g",
       "blipData": {
         "blipId": "TBD_google.com!conv+root_1",
         "waveletId": "google.com!conv+root",
         "waveId": "google.com!w+ja8F_Hw4g"
       }
     },
     "id": "op2",
     "method": "blip.createChild"
   },
   {
     "params": {
       "blipId": "TBD_google.com!conv+root_1",
       "how": 0,
       "waveId": "google.com!w+ja8F_Hw4g",
       "text": "Hello World",
       "waveletId": "google.com!conv+root"
     },
     "id": "op3",
     "method": "document.modify"
   }]

.. note::
   that this JSON message contains no root element. Instead it contains a
   params array, which in turn contains several methods. Each method contains
   params appropriate to the particular operation. Operations are ordered by
   their id value, even though operations are usually bundled together.

Operation methods operate on the following namespaces within the Wave system:

* robot operations
* wavelet operations
* blip operations
* document operations

.. note::
   that all blips contain a document as well, which contains their actual
   content, so most document operations also apply to Blips.

Robot Operations
----------------

Robot operations are those operations not tied to a particular element in the
wave (e.g. wavelet, blip, etc.) All operations that operate over all these
elements are attached to the "robot" namespace. You can think of robot
operations as global operations.

Some robot operations use a WaveletData object to pass information about a
wavelet back to the Wave server. A sample WaveletData object (in JSON) is
shown below:

.. code-block:: json

   {
     "rootBlipId": "b+VY9jKnm3B",
     "creator": "wperson5@google.com",
     "blips": {
       "b+VY9jKnm3B": {
         "blipId": "b+VY9jKnm3B",
         "waveletId": "google.com!conv+root",
         "elements": {
           "0": {
             "type": "LINE",
             "properties": {
             }
           },
           "1": {
             "type": "IMAGE",
             "properties": {
               "url": "http://www.google.com/logos/clickortreat1.gif",
               "width": 320,
               "height": 118
             }
           }
         },
         "contributors": [
           "wperson5@google.com"
         ],
         "creator": "wperson5@google.com",
         "parentBlipId": null,
         "annotations": [
           {
             "range": {
               "start": 0,
               "end": 1
             },
             "name": "conv/title",
             "value": ""
           }
         ],
         "content": "n ",
         "lastModifiedTime": 1260506637489,
         "childBlipIds": [
         ],
         "waveId": "google.com!w+VY9jKnm3A"
       }
     },
     "title": "A wavelet title",
     "creationTime": 1260506637495,
     "dataDocuments": {
     },
     "waveletId": "google.com!conv+root",
     "participants": [
       "kitchensinky+proxy@appspot.com",
       "kitchensinky@appspot.com",
       "wperson5@google.com"
     ],
     "waveId": "google.com!w+VY9jKnm3A",
     "lastModifiedTime": 1260506637489
   }

.. csv-table::
   :header: Method name, Description
   :delim: ~

   robot.notifyCapabilitiesHash(capabilitiesHash: String)~This operation is automatically prepended to any operation bundle sent back to the server, passing a hash of the current robot capabilities.xml file. This hash identifies the signature of the robot; if this hash is different from the version currently on the server, the server can fetch a new capabilities document before processing the rest of the operations.
   robot.createWavelet(waveletData: WaveletData, message: String)~This operation creates a new wavelet within a new wave. The waveletData parameter specifies the details of the wavelet. The client should provide the system with temporary string ids (using a "TBD_" prefix) in the specified waveletData object, that the client can use to send subsequent operations to the created wavelet. Upon creating the wavelet, the server will immediately generate a wavelet_created event, containing the passed message parameter. This message allows you to track the wavelet. Note: There is not yet an operation for robots to create wavelets within the current wave ("private replies").
   robot.fetchWavelet(waveId: String, waveletId: String, message: String)~This operation requests a wavelet. Two objects are returned: a waveletData object of type WaveletData that describes the wave and a list of blips of type BlipData.

Wavelet Operations
------------------

Wavelet operations are operations specific to a particular wavelet within the wave.

.. csv-table::
   :header: Method name, Description
   :delim: ~

   wavelet.appendBlip(waveId: String, waveletId: String, blipData: BlipData)~Appends a blip to the specified wave.
   wavelet.setTitle(waveId: String, waveletId: String, waveletTitle: String)~Sets the the title of the specified wave.
   wavelet.addParticipant(waveId: String, waveletId: String, participantId: String)~Adds a participant to the wave. The participantId is the address of the participant to add.
   wavelet.setDatadoc(waveId: String, waveletId: String, datadocName: String, datadocValue: String)~Sets a data document for a wavelet. Data documents are comparable to normal (blip) documents but are typically not shown to the user and do not have any schema applied to them.

Blip Operations
---------------

Blip operations are operations specific to particular blips within a wavelet.

.. note::
   that all blips are also documents as well, so operations specific to
   documents are also applicable to blips (but not vice-versa).

.. csv-table::
   :header: Method name, Description
   :delim: ~

   blip.createChild(waveId: String, waveletId: String, blipdId: String, blipData: BlipData)~Creates a reply to the current blip, taking the data for the new blip from blipData.
   blip.delete(waveId: String, waveletId: String, blipdId: String)~Deletes the blip with the specified blipId.

Document Operations
-------------------
Document operations are operations specific to documents (and blips).


.. csv-table::
   :header: Method name, Description
   :delim: ~

   document.appendMarkup(waveId: String, waveletId: String, blipdId: String, content: String)~Appends HTML (or XHTML) markup passed in the content parameter to the current wave. The built-in copy & paste functionality of wave is used to convert the content to something wavey.
   document.modify(range: Range, index: Integer, modifyQuery: DocumentModifyQuery, modifyAction: DocumentModifyAction)~This operation modifies a document and encodes two parts. Only one of range, index and modifyQuery can be set. This determines where the modification will be applied. The modifyAction parameter specifies what needs to be done.
