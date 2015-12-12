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

Annotations
===========

The Google Wave document model supports tagging sections of text within a
wavelet's Document elements via annotations. The Google Wave client uses some
reserved annotations itself to denote textual styling issues, hyperlinks, and
some metadata. You can also use your own annotations to tag certain strings of
text for your own purposes. Many robots use annotations to perform operations
on strings of text.

Note that these annotations, by themselves, are simply ways to mark selections
of text. They may, or may not, have visible effects. How you use or process
annotations is up to you. An annotation may simply contain meta-information
about a text selection, or it may require additional processing by your robot
to have some effect. (For an example of annotation processing, see Custom
Annotations below.)

.. toctree::

Wave Annotations
----------------

The Google Wave client uses annotations to style runs of text strings,
defining each annotation with a start and end point (known as a range). For
example, the following text string (as displayed to the user in the client) and
its annotations are shown below:

The *quick brown fox* jumped over the **lazy** dog.

-- pretend the brown is coloured brown.


(4,19) : style/fontStyle=italic
(10,15) : style/color=rgb(150,75,0)
(36,40) : style/fontWeight=bold

The following table lists these reserved annotations:

.. csv-table::
   :header: Annotation Name, namespace, Usage, Example
   :delim: |

   style/backgroundColor  |google| Styling, Background (Highlight) color                      |style/backgroundColor=rgb(255,0,0)
   style/color            |google| Styling, Text color                                        |style/color=rgb(150,75,0)
   style/fontFamily       |google| Styling, Font Name                                         |style/fontFamily=arial
   style/fontSize         |google| Styling, Font Size (Expects units of either "pts" or "em") |style/fontSize=2em
   style/fontStyle        |google| Styling (italic)                                           |style/fontStyle=italic
   style/fontWeight       |google| Styling, Font Weight (bold)                                |style/fontWeight=bold
   style/textDecoration   |google| Styling                                                    |style/textDecoration=none
   style/verticalAlign    |google| Styling, Vertical Alignment                                |style/verticalAlign=center
   link/manual            |google| Hyperlink                                                  |link/manual=http://www.google.com/
   link/wave              |google| Wave ID                                                    |link/wave=googlewave.com!w+d7NJm4nWF
   lang                   |google| Language of the wrapped text                               |lang=en
   conv/title             |google| Title of Wavelet (usually the first sentence unless set explicitly here) | conv/title=Introduction

.. note::
   These annotations are defined as part of the Wave Conversation Model and
   subject to change as we revise the Wave Federation Protocol.

You can view a Blip's annotations within Wave Sandbox by selecting Editor Debug
from the right hand menu on a blip and then clicking on annotations in the
Editor Debug dialog box.

Custom Annotations
------------------

You can also create your own annotations. Robots often use annotations to mark
text and repurpose it for some other use. For example, a shopping robot might
allow users to select items within a wavelet for a shopping list, extract those
annotated items, and add them to a gadget.

Annotations should be tagged using unique identifiers. It's good practice to
preface your annotations using a namespace, so that they don't collide with
other annotations (or system annotations). Using the robot's
robotname.appspot.com address as the annotation prefix neatly serves this
purpose. (A typical annotation in such as case would be
robotname.appspot.com/tagname.)

Annotations may additionally take on a value. In many cases, a value is not
necessary; the annotation and its underlying text contains all information that
is needed for designating the range of text. In other cases, an annotation
requires a value. The system styling annotations take on values, for example,
to denote font sizes, colors, families, and weights, for example.

Using annotations effectively within a robot generally requires one (or both)
the following patterns (one active and one passive):

* Actively scan the document for patterns, process the text, and add
  annotations. Some of our internal robots use this pattern to discover web
  links, for example.
* Passively respond to <annotateSelection> actions within an extension
  installer, process the text, and remove the annotations. This pattern is
  described below.

.. note:: that the first pattern is more computationally expensive.

Annotating Selections
---------------------

If you wish to have a robot respond to new annotations, the following pattern
is recommended:

* Create some way to annotate the text initially. An extension installer that
  implements the <annotateSelection> action performs this task nicely.
* Have the robot handle ANNOTATED_TEXT_CHANGED events.
* Within the robot's handler for the ANNOTATED_TEXT_CHANGED event, filter on
  the name of the annotation.
* Process the annotations in whatever manner is appropriate.
* Finally, delete the annotations when you're done, so that you don't "redo"
  any annotation logic. Alternatively, you could mark the annotations as
  processed in the annotation's value and check for that value next time
  (i.e. "annotationName:done").

The following extension installer annotates a selection as a "band name"
using band-name.appspot.com/name as the annotation's key:

.. code-block:: xml

    <extension
        name="Band Name Tagger"
        description="Tags selected text as a band name and adds it to a blip"
        thumbnailUrl="http://band-name.appspot.com/preview.png">
      <author name="Tom Manshreck"/>
      <menuHook location="TOOLBAR" text="Tag Bandname"
          iconUrl="http://band-name.appspot.com/toolbaricon.png">
        <annotateSelection key="band-name.appspot.com/name" />
        <addParticipants>
          <participant id="band-name@appspot.com"/>
        </addParticipants>
      </menuHook>
    </extension>

The following code will then monitor ANNOTATED_TEXT_CHANGED events and process
any annotations denoted with the band-name.appspot.com/name key. Note that we
delete the annotation and then process it by passing it to an addBandName()
method.

.. code-block:: python

    def onAnnotationChanged(event, wavelet):
      # Get the text of the blip
      blip = event.blip
      text = blip.text

      # Set up our array to hold the retrieved annotations
      bandnames = []

      # Get the annotation start and end points and add
      # them to the array
      for ann in blip.annotations:
        if ann.name == 'band-name.appspot.com/name':
          bandnames.append((ann.range.start, ann.range.end))

      # For each bandname, call addBandName to do any post processing
      # Also make sure to delete the existing annotation
      for start, end in bandnames:
        bandname = text[start:end]
        blip.range(start, end).clear_annotation('band-name.appspot.com/name')
        addBandName(bandname)

For more details on annotations and events see the article Responding to User
Selection, which covers annotations in Extension Installers and robots.

Samples
-------

The following examples demonstrate using annotations:

* Pirate Selection Translator - Translates selected text into Pirate-ish.
  Uses annotateSelection to annotate selected text with a custom annotation,
  and the robot processes the custom annotations.
* Bug Triagey - Brings in a list of issues from a Google code issue tracker
  into a wave and lets triagers click buttons to indicate what they're working
  on. The robot annotates text with custom data annotations and after a user
  clicks a button near it, the robot adds additional styles to the annotated
  text.