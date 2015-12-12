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

Reference
=========

This is the reference for the Google Wave Gadgets JavaScript API.

namespace gadgets
-----------------

This namespace is used by the Gadgets API for the features it offers in all
containers, including Wave. Those are documented here:
http://code.google.com/apis/gadgets/docs/reference/

namespace gadgets.window
------------------------

This namespace is defined by the Gadgets API, and documented here:

http://code.google.com/apis/gadgets/docs/reference/#gadgets.window

The Wave Gadgets API adds an additional method on top of the set documented
there.

.. csv-table::
   :header: Static methods, Return Value, Description
   :widths: 10, 10, 10

   adjustWidth(opt_width:number=),None,Adjusts the gadget width


namespace wave
--------------

This namespace defines the top level wave object within the Wave Gadgets API.

Static Methods
^^^^^^^^^^^^^^

.. csv-table::
   :header: Static methods, Return Value, Description
   :widths: 10, 70, 10
   :delim: ~

   getHost()~wave.Participant~Returns the Participant who added this gadget to the blip. Note that the host may no longer be in the participant list.
   getMode()~wave.Mode~Returns the gadget wave.Mode.
   getParticipantById(id:string)~wave.Participant~Returns a Participant with the given id.
   getParticipants()~Array~Returns a list of Participants on the Wave.
   getPrivateState()~wave.State~Returns the private gadget state as a wave.State object.
   getState()~wave.State~Returns the gadget state as a wave.State object.
   getTime()~number~Retrieves the current time of the viewer. TODO: Define the necessary gadget <-> container communication and implement playback time.
   getViewer()~wave.Participant~Get the Participant whose client renders this gadget.
   getWaveId()~?string~Returns serialized wave ID or null if not known.
   isInWaveContainer()~boolean~Indicates whether the gadget runs inside a wave container.
   isPlayback()~boolean~Returns the playback state of the wave/wavelet/gadget. Note: For compatibility UNKNOWN mode identified as PLAYBACK.
   log(message:string)~None~Requests the container to output a log message.
   `setModeCallback( callback:function(wave.Mode), opt_context?:Object=)`~None~Sets the mode change callback.
   `setParticipantCallback( callback:function(Array.), opt_context?:Object=)`~None~Sets the participant update callback. If the participant information is already received, the callback is invoked immediately to report the current participant information. Only one callback can be defined. Consecutive calls would remove old callback and set the new one.
   `setPrivateStateCallback( callback:function(wave.State=|Object.=), opt_context:Object=)`~None~Sets the private gadget state update callback. Works similarly to setStateCallback but handles the private state events.
   `setSnippet( snippet:string)`~None~Requests the container to update the snippet visible in wave digest.
   `setStateCallback( callback:function(wave.State=|Object.=), opt_context:Object=)`~None~Sets the gadget state update callback. If the state is already received from the container, the callback is invoked immediately to report the current gadget state. Only invoke callback can be defined. Consecutive calls would remove the old callback and set the new one.

class Callback
--------------

This class is an immutable utility class for handlings callbacks with variable
arguments and an optional context.

Constructor
^^^^^^^^^^^
.. csv-table::
   :header: Constructor, Description
   :delim: ~

   wave.Callback(callback:?(function(wave.State=|Object.=)| function(Array.=)| function(wave.Mode.=) ), opt_context:Object=)~Constructs a callback given the provided callback and an optional context.

Methods
^^^^^^^

.. csv-table::
   :header: Methods, Return Value, Description

   invoke(var_args:...),None,Invokes the callback method with any arguments passed.

class Mode
----------

Identifiers for wave modes exhibited by the blip containing the gadget.

Constant
^^^^^^^^

.. csv-table::
   :header: Constant, Description
   :delim: ~

   DIFF_ON_OPEN~The blip containing the gadget has changed since the last time it was opened and the gadget should notify this change to the user.
   EDIT~Editing the gadget blip
   PLAYBACK~The blip containing the gadget is in playback mode.
   UNKNOWN~The blip containing the gadget is in an unknown mode. In this case, you should not attempt to edit the blip.
   VIEW~The blip containing the gadget is in view, but not edit mode.

class Participant
-----------------

This class specifies participants on a wave.

Constructor
^^^^^^^^^^^

.. csv-table::
   :header: Constructor, Description
   :delim: ~

   wave.Participant(id:string=, displayName:string=, thumbnailUrl:string=)~Creates a new participant.

Methods
^^^^^^^

.. csv-table::
   :header: Methods, Return Value, Description

   getDisplayName(),string,Gets the human-readable display name of this participant.
   getId(),string,Gets the unique identifier of this participant.
   getThumbnailUrl(),string,Gets the url of the thumbnail image for this participant.

class State
-----------

This class contains state properties of the Gadget.

Constructor
^^^^^^^^^^^
.. csv-table::
   :header: Constructor, Description

   wave.State(opt_rpc:string=),Creates a new state object to hold properties of the gadget.

Methods
^^^^^^^

.. csv-table::
   :header: Methods, Return Value, Description
   :delim: ~

   get(key:string, opt_default:?string=)~?string~Retrieve a value from the synchronized state. As of now, get always returns a string. This will change at some point to return whatever was set.
   getKeys()~Array.~Retrieve the valid keys for the synchronized state.
   reset()~None~Submits a delta to remove all key-values in the state.
   submitDelta(delta:!Object.)~None~Updates the state delta. This is an asynchronous call that will update the state and not take effect immediately. Creating any key with a null value will attempt to delete the key.
   submitValue(key:string, value:?string)~None~Submits delta that contains only one key-value pair. Note that if value is null the key will be removed from the state. See submitDelta(delta) for semantic details.
   toString()~string~Pretty prints the current state object. Note this is a debug method only.

namespace wave.ui
-----------------

This namespace defines methods for creating a wave look & feel inside a gadget.

Static Methods
^^^^^^^^^^^^^^

.. csv-table::
   :header: Static Methods, Return Value, Description
   :delim: ~

   loadCss()~None~Loads a CSS with Wave-like styles into the gadget, including font properties, link properties, and the properties for the wave-styled button, dialog, and frame.
   makeButton(target:Element)~None~Converts the passed in target into a wave-styled button.
   makeDialog(target:Element, title:string, onclick:)~None~Converts the passed in target into a wave-styled dialog. For now it only creates a centered box. The close button in the upper right corner will be default do nothing.
   makeFrame(target:Element)~None~Converts the passed in target into a wave-styled frame.

namespace wave.util
-------------------

This namespace defines utility methods for use within the Wave Gadgets API.

Static Methods
^^^^^^^^^^^^^^

.. csv-table::
   :header: Static methods, Return Value, Description
   :delim: ~

   printJson(obj:Object, opt_pretty:boolean=, opt_tabs:number=)~string~Outputs JSON objects in text format. Optionally pretty print.