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

For more information on developing, read the tutorial.

class EmbedOptions
------------------

Describes the options that can be passed into the opt_config argument of the
WavePanel constructor.

Properties
^^^^^^^^^^

+---------------+------------+-------------------------------------------------+
| Properties    | Type       | Description                                     |
+===============+============+=================================================+
| bgcolor       | string     | The background color CSS property to be set on  |
|               |            | the embedded wave panel. Note: This property    |
|               |            | does not currently work with a value of         |
|               |            | 'transparent'.                                  |
+---------------+------------+-------------------------------------------------+
| footer        | boolean    | A flag indicating whether or not the embed wave |
|               |            | panel footer should be displayed.               |
+---------------+------------+-------------------------------------------------+
| header        | boolean    | A flag indicating whether or not the embed wave |
|               |            | panel header should be displayed.               |
+---------------+------------+-------------------------------------------------+
| height        | number     | The display height of the embedded wave panel   |
|               |            | in pixels. Prefer specifying the width/height of|
|               |            | the containing div in your html if possible.    |
+---------------+------------+-------------------------------------------------+
| rooturl       | string     | The Google Wave server URL that will serve the  |
|               |            | embedded wave. Note that the URL must have a    |
|               |            | trailing '/' By default this value is presumed  |
|               |            | to be google wave preview:                      |
|               |            | https://wave.google.com/wave/                   |
+---------------+------------+-------------------------------------------------+
| target        | element    | The div element inside which to insert the      |
|               |            | embedded wave panel.                            |
+---------------+------------+-------------------------------------------------+
| toolbar       | boolean    | A flag indicating whether or not the embed wave |
|               |            | panel toolbar should be displayed. Note that    |
|               |            | this flag is now valid even if the header is    |
|               |            | disabled.                                       |
+---------------+------------+-------------------------------------------------+
| width         | number     | The display width of the embedded wave panel in |
|               |            | pixels. Prefer specifying the width/height of   |
|               |            | the containing div in your html if possible.    |
+---------------+------------+-------------------------------------------------+


class WavePanel
---------------

This class defines an object to hold the embedded wave, in which an <iframe> is
constructed.

Constructor
^^^^^^^^^^^

+--------------------------------+---------------------------------------------+
| Constructor                    | Description                                 |
+================================+=============================================+
| WavePanel(opt_config?:Object)	 | Constructs a WavePanel in the passed        |
|                                | container. An <iframe> is created inside the|
|                                | target; if no target is specified, the      |
|                                | <iframe> is instead appended to the current |
|                                | document.                                   |
+--------------------------------+---------------------------------------------+

Methods
^^^^^^^

+------------------------+-----------------+-----------------------------------+
| Methods                | Return Value    | Description                       |
+========================+=================+===================================+
| loadWave(waveId:String,| None            | Loads a new wave into the         |
| opt_callback:Function) |                 | Wavepanel.                        |
+------------------------+-----------------+-----------------------------------+
