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

Google Wave allows client applications to fetch and modify waves on behalf of
users, using the Wave Data Protocol detailed in this document. The protocol is
based on sending JSON-RPC messages to the Wave server, and receiving JSON
in response.

Instead of using the protocol to create your application, you can use the
existing client libraries, and let them take care of forming and parsing the
JSON messages.

However, understanding the protocol can help you debug your application much
more efficiently, allowing you to inspect and understand the messages which get
transmitted and received. As well, understanding the protocol allows you to
directly communicate with Wave without use of a client library, and could
potentially allow you to create your own client library.

Contents

.. toctree::

Authentication
--------------

All interactions with Wave data require authentication via OAuth. For
information about authentication a user of your application this way, read
OAuth for Web Applications.

When accessing the Wave Data APIs, an authorization token must be authorized
for this scope:

http://wave.googleusercontent.com/api/rpc

All other parameters, like the endpoints for generating access tokens, are the
same as other Google services and defined in the documentaton linked above.

Operations
----------

To interact with waves, an application can send operations to Wave. These
operations consist of JSON-RPC messages. A simple message which sets a wave's
title, creates a blip, and writes "Hello World" is shown below:


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

robot operations
wavelet operations
blip operations
document operations

Note that all blips contain a document as well, which contains their actual
content, so most document operations also apply to Blips.

Robot Operations
----------------

Robot operations are those operations not tied to a particular element in the
wave (e.g. wavelet, blip, etc.) All operations that operate over all these
elements are attached to the "robot" namespace. You can think of robot
operations as global operations.

Some robot operations use a WaveletData object to pass information about a
wavelet back to the Wave server. A sample WaveletData object (in JSON) is shown
below:


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

Method Name - Description
robot.notifyCapabilitiesHash(capabilitiesHash: String)
   This operation is automatically prepended to any operation bundle sent back
   to the server, passing a hash of the current robot capabilities.xml file.
   This hash identifies the signature of the robot; if this hash is different
   from the version currently on the server, the server can fetch a new
   capabilities document before processing the rest of the operations.

robot.createWavelet(waveletData: WaveletData, message: String)
   This operation creates a new wavelet within a new wave. The waveletData
   parameter specifies the details of the wavelet. The client should provide
   the system with temporary string ids (using a "TBD_" prefix) in the specified
   waveletData object, that the client can use to send subsequent operations to
   the created wavelet. Upon creating the wavelet, the server will immediately
   generate a wavelet_created event, containing the passed message parameter.
   This message allows you to track the wavelet. Note: There is not yet an
   operation for robots to create wavelets within the current wave
   ("private replies").

robot.fetchWavelet(waveId: String, waveletId: String, message: String)
   This operation requests a wavelet. Two objects are returned: a waveletData
   object of type WaveletData that describes the wave and a list of blips of
   type BlipData.

wave.robot.search(query: String, index: Integer, numResults: Integer)
   This operation searches across the user's waves. This first parameter,
   query, is the search string, similar to the one that you specify in the
   search panel in the client, for example, "in:inbox". The numResults
   indicates desired number of results, and defaults to 10 if not specified.
   This operation returns a list of search snippets. Each entry contains
   several properties: title, snippet, waveId, lastModified, unreadCount,
   blipCount, and a list of participants. Note that lastModified is expressed
   in UTC as milliseconds since the epoch (midnight, January 1, 1970).

wave.robot.folderAction(modifyHow: String, waveId: String)
   This operation modifies the state of the given waveId. This first parameter,
   modifyHow, dictates the action that needs to be done. Available actions:

      markAsRead
      markAsUnread
      mute
      archive (Note: this is the default action, if you don't pass in the
      modifyHow parameter)

Wavelet Operations
------------------

Wavelet operations are operations specific to a particular wavelet within the
wave.

Method Name	Description
wavelet.appendBlip(waveId: String, waveletId: String, blipData: BlipData)
    Appends a blip to the specified wave.
wavelet.setTitle(waveId: String, waveletId: String, waveletTitle: String)
    Sets the the title of the specified wave.
wavelet.addParticipant(waveId: String, waveletId: String, participantId: String)
    Adds a participant to the wave. The participantId is the address of the
    participant to add.
wavelet.setDatadoc(waveId: String, waveletId: String, datadocName: String,
datadocValue: String)
    Sets a data document for a wavelet. Data documents are comparable to normal
    (blip) documents but are typically not shown to the user and do not have
    any schema applied to them.

Blip Operations
---------------

Blip operations are operations specific to particular blips within a wavelet.
Note that all blips are also documents as well, so operations specific to
documents are also applicable to blips (but not vice-versa).

Method Name	Description
blip.createChild(waveId: String, waveletId: String, blipdId: String,
blipData: BlipData)
    Creates a reply to the current blip, taking the data for the new blip from
    blipData.
blip.delete(waveId: String, waveletId: String, blipdId: String)
    Deletes the blip with the specified blipId.

Document Operations
-------------------

Document operations are operations specific to documents (and blips).

Method Name	Description
document.appendMarkup(waveId: String, waveletId: String, blipdId: String,
content: String)
    Appends HTML (or XHTML) markup passed in the content parameter to the
    current wave. The built-in copy & paste functionality of wave is used to
    convert the content to something wavey.
document.modify(range: Range, index: Integer, modifyQuery: DocumentModifyQuery,
modifyAction: DocumentModifyAction)
    This operation modifies a document and encodes two parts. Only one of
    range, index and modifyQuery can be set. This determines where the
    modification will be applied. The modifyAction parameter specifies what
    needs to be done.

Events
------

There is currently no way for an application using the Wave Data API to
register for events on a user's wave state changes. The only way to detect
changes it to call search and fetchWave and then compare the returned waves to
older known versions of the the waves.