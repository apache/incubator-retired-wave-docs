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

Frequently Asked Questions
==========================

Using the Gadgets API
---------------------

How can I disable caching in gadgets?
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Gadget servers tend to cache the XML and metadata of a gadget to reduce
developer bandwidth and to increase user speed. This caching is great in
production, but makes rapid development quite difficult.

On WaveSandbox.com, no information about gadgets are cached, since that server
is designed for debugging.

On Google Wave Preview, the gadget metadata (height/width/etc) is cached for 10
minutes, and the gadget XML (source) is cached for an hour. The gadget metadata
cache cannot currently be disabled. The gadget XML cache can be disabled by
appending ?gadget_cache=0 to the URL in the browser. For example:
http://wave.google.com/wave/?gadget_cache=0

Gadgets can use gadgets.io.makeRequest to fetch information off other servers,
and that method also uses caching by default. To change the caching for that
method, see the reference.

Can I access the contacts list of a gadget participant?
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The gadgets API only provides access to information of the other participants
in a gadget. If you want to retrieve or manipulate information about a
participant's contacts, you will have to use the Google contacts data API.

How do I host a gadget on App Engine?
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

We recommend using App Engine for hosting gadgets, if you don't have access to
your own server. App Engine both lets you host static files and generate files
dynamically.

If you want to use App Engine just to host some static files (your gadget XML,
images, etc), read this article.

If you're looking for an example of using App Engine to render gadget files
dynamically (using templates), check out the IMDBotty sample.

Does Wave support the use of content type="url" gadgets?
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The Google Wave gadget renderer will currently render gadgets that use content
type="url" in their module spec. However, we do not recommend using this type
of gadget if you will be using the Gadgets API or Wave API. We suggest using
content type="html" when possible. If you need to use the same HTML for both a
gadget and a webpage, you can use server-side templating (like is available on
App Engine) to render it as either.

Are user preferences supported by Wave gadgets?
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The gadgets API has a notion of user preferences that is used in several gadget
containers, like iGoogle. The Google Wave client has no ability for users to
customize user preferences upon adding a gadget, and no guarantee that user
preferences will be retained, so we do not recommended using the gadget user
preferences library.

We recommend that Wave gadget developers use the private state in the Wave
Gadgets API for storing per-person preferences. For more information, see the
reference for setPrivateStateCallback and getPrivateState in the Wave Gadgets
API reference:
http://code.google.com/apis/wave/extensions/gadgets/reference.html

Note that if your gadget is also designed to work in a container like iGoogle,
then you can continue to use user preferences for that container.

Can I place advertisements inside my extension?
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Developers are free to include advertisements from any ad provider, with some
restrictions designed to promote a great user experience. All advertising must
be clearly labeled as an ad or sponsored link. Ads cannot move across the page
or expand beyond their initial bounds, they must hold a persistent location, no
pop-up windows are allowed, and audio/video ads cannot be initiated without
user action.

In the case of AdSense ads, you must not violate the existing AdSense Program
Policies. In particular, ads should not be obscured and should be visible in
the default wave view (3-columns with 1024x768 resolution).

How can I enable "Show debug log"?
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

If you are on Wave sandbox, you can enable the debug log option by typing
"?ll=debug" after the final "/" in the URL (before the hash sign).
For example:

https://wave.google.com/a/wavesandbox.com/?ll=debug#restored:wave:wavesandbox.com!w%252B7NmzY-gUK

Then, when you click the "Debug" menu in the upper right, the topmost option
will be "Show debug log". When you select this, a log will appear at the bottom
of the screen. Among other things, that log is helpful for debugging gadgets.
For more information, see this article on debugging gadgets.

Note: The "Debug" menu is only available in Wave sandbox, not in Wave preview.

Can I use GWT to write a Google Wave Gadget?
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Yes, many developers use GWT (Google Web Toolkit) to develop Google Wave
Gadgets. Since the Gadgets API is offered officially in JavaScript, these
developers write their own GWT Java wrapper, or use existing wrappers, like
cobogwave.

You can check the samples gallery for examples of gadgets written in GWT.

Is there a limit to the size of a gadget?
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Since a gadget is an element within a blip, and the state is stored within the
blip document, the size of the gadget state cannot be greater than the max size
of a blip, and should generally be much lower.

For info on the size limits, see http://wave-api-faq.appspot.com/#sizelimits

Using the Robots API
--------------------

How can a robot insert a gadget?
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Generally, a gadget is an element, and a robot can insert a gadget the same way
that it inserts other elements, like images and forms.

In the Python client library, a gadget can be constructed with the
`element.Gadget` class, and then inserted using any of
the BlipRefs actions.

Sample code is shown below:

.. code-block:: javascript

    gadget = element.Gadget('http://tricky-bot.appspot.com/gadget.xml')
    blip.append(gadget)

In the Java client library, a gadget can be constructed with the `Gadget()`
class, and inserted using `insertElement()` or `appendElement()`.

Sample code is shown below:

.. code-block:: java

    Gadget gadget = new Gadget(gadgetUrl);
    blip.append(gadget)

How can I append an HTML string to a blip?

The usual way to create formatted text in Wave is to set text, and then set
annotations on ranges in that text that correspond to the desired format.
However, some developers may prefer to pass in a string of HTML, and have Wave
convert it to text + annotations.

The Java client library provides this capability via the Blip.append function,
used in the code snippet below:

.. code-block:: java

      @Override
      public void onBlipSubmitted(BlipSubmittedEvent event) {
        Blip bilp = event.getBlip();
        blip.append(new com.google.wave.api.Markup("<b>hello</b>"));
      }

The Python client library provides it via the BlipRefs.append_markup function,
used in the code snippet below:

.. code-block:: python

    def OnBlipSubmitted(event, wavelet):
      blip = event.blip
      blip.append_markup('<b>Hi there, honey!</b>')

Currently, the only supported tags are: <p>, <div>, <b>, <strong>, <i>, <em>,
<u>.

If you pass in an unsupported tag, the operation may fail silently

Is it possible to export a Wave to other formats (like HTML)?
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The API does not provide an export functionality, but it does provide access to
much of the information needed to export a blip in a wave: the text,
annotations, and elements.

It is possible to iterate through this information and convert it into other
formats.

For an example of this, see Exporty Bot.

It is not currently possible to export all of the blips in a large wave, due to
the restriction on context in the current API. See this FAQ for more info.

How can a robot create a private reply in a wave?
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

There is currently no mechanism for robots to create private replies within the
API.

Please star this issue to be notified when it is possible in the API:

http://code.google.com/p/google-wave-resources/issues/detail?id=625

A possible workaround for now is to create a new wave with the participants.

How can I retrieve a submitted blip?
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

When a BLIP_SUBMITTED event occurs, the robot always receives information about
the actual blip that was submitted, and you can retrieve a reference to that
blip using the client libraries.

In the Java client library, you can retrieve the blip with the following code:

.. code-block:: java

    @Override
    public void onBlipSubmitted(BlipSubmittedEvent event) {
      Blip blip = event.getBlip();
    }

In the Python client library, you can retrieve the blip in the Event
properties. The code is shown below:

.. code-block:: python

    def onBlipSubmitted(event, wavelet):
    blip = event.blip

How can I iterate over all the blips in a wave?
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

First, to make sure that the Wave server sends information about all the blips
to the robot, the developer must specify a context of ''ALL" in the
capabilities. See the documentation on capabilities for more information.

Once the context is properly set, then the following code snippets show
retrieving each blip in a wave.

Python:

.. code-block:: python

    for blip_id in wavelet.blips:
      blip = wavelet.blips.get(blip_id)
      # process blip

Java:

.. code-block:: java

    Map <String, Blip> mp = wavelet.getBlips()
    Collection<Blip> vals = mp.values();
    for (Blip val: vals) {
      // Process val
    }

How can I set and retrieve data documents?
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

A wave is actually composed of 1 or more wavelets, and each of those wavelets
can be associated with any number of data documents. A data document can be
used to store non-visible shared data in a Wave, and can be considered similar
to the shared state in gadgets. A data document has a key and a value, and both
of these are strings. Developers may serialize more complex data into the
string value, if desired.

To use data documents in the Python client library, use
`Wavelet.data_documents`.

To use data documents in the Java client library, use
`Wavelet.getDataDocuments()` which returns the map of all the data documents of
the wavelet as DataDocuments class. You can retrieve the content of a given
data document with `DataDocuments.get(docName)` or write the content of a data
document with `DataDocuments.set(docName, docContent)`

What is the difference between App Engine versions and capabilities versions?
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Robot developers may find themselves using versions in two different places,
and getting confused about the purpose of each.

First, there is a version for a robot's capabilities (the events that they
subscribe to). That version is automatically generated as a hash of the robot's
capabilities, and programmatically outputted to a capabilities.xml file. The
wave server sees that the version (hash) has updated, and re-fetches the
information about that robot's capabilities.

There is also a version for the App Engine app as a whole, and this is
specified in the appengine-web.xml in the Java SDK, and the app.yaml in the
Python SDK. App Engine allows developers to push multiple versions of their
code live to their servers, to enable testing of new code before releasing it
to users. When you do change the version in your configuration file and upload
your app, that version is served at a special URL, accessible via the
"Versions" page in your dashboard. That version will only be served by default
when you explicitly click the "Make Default" button in the dashboard.

Developers may want to use App Engine versioning if their robot is currently
being used by users, and they do not want to risk breaking them until they have
tested their new changes. Developers that are in the beginning stages of
development should not need to use multiple App Engine versions

How many documents can there be in any given wavelet?
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

A wavelet is composed of both blip documents and data documents. Currently, the
total is not allowed to exceed 1000. If that is exceeded, the wave will no
longer be editable and display a size error message to users. Keep this in mind
when designing your use of blips and data documents in your robots.

Can robots access or create attachments?
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Yes, robots can retrieve and edit attachments. For more information, see this
documentation.

How can a robot access the selected text in a document?
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

If you want to make a robot that processes user-selected text, there are
2 possible techniques.

One way is to create an extension installer that adds your robot and calls the
annotateSelection action when a toolbar icon is clicked:

.. code-block:: xml

   <menuHook location="TOOLBAR" text="Tag Bandname"
   iconUrl="http://band-name.appspot.com/toolbaricon.png">
     <annotateSelection key="band-name.appspot.com/name" />
     <addParticipants>
       <participant id="band-name@appspot.com"/>
     </addParticipants>
   </menuHook>

That action will annotate the selected text with a key of your choosing (e.g.
"band-name.appspot.com/name"), and your robot can look for that annotation in
the document and process the text accordingly. For more information on the
technique, read through the Annotations section of the robot documentation, and
the Extension Installers Guide.


Another way is to have your robot register for the DOCUMENT_CHANGED event, and
then look for an annotation of the form "user/r/username@wavedomain.com". This
annotation specifies the range of text that the user selected when that event
was triggered. You can then process the information within that range. This
technique means that your robot will receive many more events (due to
subscribing to DOCUMENT_CHANGED) so the first technique is recommended for
better use of bandwidth. More information on the "user/r/" annotation is in the
Wave protocol spec.


Can a robot set a participant as read-only?
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The Google Wave client now allows the creator of a wave to set participants as
read-only using a dropdown in the hovercard. The Google Wave APIs also allow
robots that create waves to set the participants on the wave as read-only.

The following code demonstrates making a new wave and setting a participant as
read-only in Python:

.. code-block:: python

    new_wave = sinky.new_wave('googlewave.com', ['pamela.fox@googlewave.com'])
    new_wave.participants.set_role('pamela.fox@googlewave.com',
                                    wavelet_mod.Participants.ROLE_READ_ONLY)

This code shows doing the same in Java:

.. code-block:: java

    Set<String> participants = new HashSet<String>();
    participants.add("pamela.fox@googlewave.com");
    Wavelet newWave = this.newWave("googlewave.com", null, null);
    newWave.getParticipants().setParticipantRole("pamela.fox@googlewave.com",
        Participants.Role.READ_ONLY);


Keep in mind that robots can only set roles if they are the creator of a wave.
If a robot attempts to set the roles of a participant and the robot is not the
creator of a wave, the operations will fail silently.

In the future, Google Wave may create a notion of wave "owners", where the
creator of the wave would be the default owner, and they could delegate other
participants as owners, and any owner could set the roles of other participants.

How do you test robot code that has been deployed to a non-default App Engine version?
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

When you change the version of your App Engine application and deploy it, that
version does not become the default code that is served from
http://your-robot.appspot.com. This allows you to test new code without
affecting users using your robot.

To find the URL for your newly deployed version, navigate to your dashboard at
http://appengine.google.com and click "Versions" in the sidebar. That will show
you all the deployed versions and which is default. You will see a URL like
http://2.latest.your-robot.appspot.com. You can then convert that into a robot
address like 2.latest.your-robot@appspot.com, and add that as a participant to
your waves. As a shortcut, you can use your-robot#2@appspot.com, and that
should alias to the same address.

If you often query your logs for information on how your robot is doing, be
aware that App Engine displays the logs for the default version by default. You
will need to change the version in the upper left dropdown to the version you
are currently testing.

When you are ready to make your new version the default version, select that
version and click "Make default".

How can a user customize settings for a robot?
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

There is currently no built in mechanism for a user to specify a set of
settings for a robot, but there are several techniques that can be used
regardless.

- Make the robot insert a gadget, ask the user to specify configuration options
  in the gadget, then delete the gadget. The article on Embeddy shows that
  technique. A variation on this technique is to ask the robot to specify
  operations via form elements or text elements in the root blip.
- Use info after the "+" in the robot address (bla+config@appspot.com), and
  extract that information to guide your robot in the server code. The Emaily
  sample demonstrates that technique.

What annotations are supported by the Google Wave Client?
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Robots can set annotations with specified key/values on ranges within a blip.
These annotations can either be custom annotations, used by the robot for its
own needs, or they can be annotations that are interpreted by the Google Wave
client and used to affect the rendering of the blip.

The following keys can be used to affect the text style. The values for these
annotations should be the same as what you would specify in CSS for the
corresponding style rule.

- style/backgroundColor
- style/color
- style/fontFamily
- style/fontSize
- style/fontStyle
- style/fontWeight
- style/textDecoration
- style/verticalAlign

The "link/manual" annotation can be used to turn text into a hyperlink. The
value for that annotation should be the URL. Right now, only URLs starting with
the HTTP protocol are supported.

The "link/wave" annotation can be used to make a link that will open a wave
inside the current client. The value for that annotation should be the wave ID,
like "googlewave.com!w+d7NJm4nWF".

The annotation keys are case sensitive - use the case shown here.

Note: These keys are subject to change, and it is probable that they will
change in the future when the Wave data model is revised. Be prepared to
upgrade your robots that make use of these annotation keys.

Is it possible to disable the spell-checking agent for a document?
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Google Wave uses an agent called Spelly that automatically performs
spell-checking on gives spelling suggestions or auto-corrects. This is useful
for users, but some developers may find themselves wanting to disable the spell
suggestions (if, for example, they know that a particular range of text is not
in a spoken language, but is instead programming or math syntax). It is not
currently possible for developers to disable Spelly, but it should be possible
in the future.

To be notified of updates, star this issue:
http://code.google.com/p/google-wave-resources/issues/detail?id=195

How can a robot remove a participant?
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The Google Wave client allows the removal of participants, but the Google Wave
API does not support removal of any types of participants (humans or robots) at
this time.

How can I iterate through a gadget's state keys in a robot?
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Once you have a handle to a gadget you can iterate through all the gadget
state's keys.

The following code demonstrates how to do so in the Java client library:

.. code-block:: java

   Map<String, String> states = gadget.getProperties();
   Set<Entry<String, String>> entries = states.entrySet();

   for (Entry entry : entries) {
     String key = (String) entry.getKey();
     String value = (String) entry.getValue();
   }


How can I delete all the contents in a blip?
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The best way to delete all the content in a blip is to use the all() selector
and the delete() action.

For example, the following code deletes the content of the root blip using the
Python SDK:

.. code-block:: python

    wavelet.root_blip.all().delete()


Is there a limit to the number of operations a robot can send?
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

There is a limit to the number of operations a robot can send to the Wave
server over certain periods of time. There is both a "short term" limit, which
restricts robots from sending more than 2000 operations in 20 seconds (about
100 ops per second), and there is a "long term" limit, which restricts robots
from doing more than 6000 operations in 10 minutes (about 10 ops pers second).
These limits protect our servers against robots which send bursts of activity or
prolonged high activity. Most typical robots will not approach these limits.
If your robot exceeds these limits, please fill out a robot limit request wave.

What are the size limits for blips and wavelets?
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

To maintain good server performance, we impose a size limit on each blip as
well as the entire wavelet. For a blip, the limit is between 100KB and 1MB,
depending on how the data is structured. For a wavelet, the limit is between
500KB and 5MB.

When designing your robots to modify blips and wavelets, you should aim to stay
well below these limits.

How can I link to a wave?
^^^^^^^^^^^^^^^^^^^^^^^^^

There are several ways to link to a wave, depending on where you are linking
from.

If you are linking to a wave from an external page, we recommend using the
permalink format that is offered by the "Link to this wave" button. That format
looks like this:

`wave.google.com/wave/waveref/{{domain}}/{{wave_id_without_domain}}`

In the template above, you would replace the domain with something like
"googlewave.com" or "wavesandbox.com", and replace the wave_id_without_domain
with something like "w+M4nDhzgpB".

If you are using the robot API or gadgets API to obtain the wave ID, those
APIs will report an ID like "googlewave.com!w+M4nDhzgpB". You can split that
ID into the necessary parts using the "!" as the delimiter.

If you are linking to a wave from a wave, then we recommend setting the
"link/manual" annotation on the desired link text, and setting the key to a
waveref format. That format looks like this:

`waveid://{{ domain }}/{{ wave_id_without_domain }}`

As above with the permalink format, you would make the same substitutions to
this one.

Here's how you would append a link to a wave in Python:

.. code-block:: python

   domain = wavelet.domain
   wave_id = wavelet.wave_id.split('!')[1]
   wave_ref = 'waveid://%s/%s' % (domain, wave_id)
   blip.append('Cool wave', bundled_annotations=[('link/manual', wave_ref)])

How can a robot add a group to a wave?
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

At this time, robots may add groups to a wave only if the group settings are
such that "anyone on the web can post". There is no way to make a robot a
member of a group, so robots can't add groups that restrict posting.

How can I link to a blip?
^^^^^^^^^^^^^^^^^^^^^^^^^

There are several ways to link to a blip, depending on where you are linking
from.

If you are linking to a blipfrom an external page, we recommend using the
permalink format that is offered by the "Link to this message" item in the blip
menu. That format looks like this:

`wave.google.com/wave/waveref/{{ domain }}/{{ wave_id_without_domain }}/
~/{{ wavelet_id }}/{{ blip_id }}`

In the template above, you would replace the domain with something like
"googlewave.com" or "wavesandbox.com", replace the wave_id_without_domain with
something like "w+M4nDhzgpB", replace wavelet_id with 'conv+root' for the main
wavelet or the wavelet is if the blip is in a private reply, and replace
blip_id with something like 'b+3GagyivTJ'.

If you are using the robot API or gadgets API to obtain the wave ID, those APIs
will report an ID like "googlewave.com!w+M4nDhzgpB". You can split that ID into
the necessary parts using the "!" as the delimiter.

If you are linking to a wave from a wave, then we recommend setting the
"link/manual" annotation on the desired link text, and setting the key to a
waveref format. That format looks like this:

`waveid://{{ domain }}/{{ wave_id_without_domain }}/
~/{{ wavelet_id }}/{{ blip_id }}`

As above with the permalink format, you would make the same substitutions to
this one.

Here's an example of adding a blip link in Python, from the BlipLinky sample:

.. code-block:: python

    domain = wavelet.domain
    wave_id = wavelet.wave_id.split('!')[1]
    blip_id = event.blip.blip_id
    blip_ref = 'waveid://%s/%s/~/conv+root/%s/' % (domain, wave_id, blip_id)
    wavelet.root_blip.append(title, [('link/manual', blip_ref)])


How can I find the index of an element in a blip?
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

You can find the index of an element in the blip by iterating through the
matches in a BlipRefs/BlipContentRefs object, and retrieving the start position
of the matches or first match.

For example, this code finds the index of the first image in a blip in Python:

.. code-block:: python

    blip = wavelet.root_blip
    start = blip.first(element.Image).__iter__().next()[0]

And this code finds the index of the first gadget in Java:

.. code-block:: java

    Map<String, String> restrictions = new HashMap<String, String>();
    ElementIterator iterator = new BlipIterator.ElementIterator(blip,
        ElementType.GADGET, restrictions, -1);
    int start = iterator.next().getStart();

If you want to retrieve the index of all of elements of a particular type in a
blip, you can use a for loop like this:

.. code-block:: bash

    for start, end in blip.all(element.Line):
       # do something with start and end


How does Google Wave handle titles?
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

In the Google Wave model, a title is not actually a distinct element, but
instead, it is an annotation on text in the root blip, with the key
"conv/title". When a Wave user types text into a wave, the client attempts to
automatically designate part of the text as the title. It finds the title by
first looking for punctuation ("!", ".", or "?") followed by a whitespace, and
if it doesn't find that, it looks for the first newline after the text. For
example, if the user typed "So Exciting! A brand new day", the Wave client
would designate "So Exciting!" as the title. If the user typed "No way, Jose",
the Wave client would designate that full line as the title.

When you set the title of the wave using the API, the wave server tries to
follow the same rules, so if you want to make sure your programmatically set
title remains the title, then make sure to keep in mind the truncation rules
detailed above.


Is there a limit to the number of blips in a wave?
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

There is currently a limit to the number of blips in a wave, and it is 999.
Please keep that in mind when developing robots that append blips. If your
robot tries to append a blip past the limit, the operation will fail silently.

How can I change the font size of the title of the wave?
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Normally, you would be able to change the font size of a wave title either by
changing the lineType attribute on the first Line element or by setting an
annotation to make the font size larger. However, there is currently an issue
with the first technique, so only the second technique is viable.

Here is how you would set the annotation in Python:

.. code-block:: python

    # Don't annotate the first character of the blip, as that's a Line element
    blip.range(1, len(wavelet.title)+1).annotate('style/fontSize', '3em');

How do you copy an attachment from one blip to another?
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

When we send attachments to robots, we only send the caption and attachment
URL, we do not send the raw data. In order to create a new attachment, you need
to specify the actual data, not a URL. So, to copy an attachment, you must
retrieve the data at the URL, pass that into a new attachment object, and add
that new attachment object to the desired target blip.

The following code demonstrates doing so in Python:

.. code-block:: python

   def OnBlipSubmitted(event, wavelet):
     blip = event.blip
     attachment = blip.first(element.Attachment).value()
     new_blip = wavelet.reply('\ncopy')
     attachment_data = urllib2.urlopen(attachment.attachmentUrl).read()
     new_blip.append(element.Attachment(caption = attachment.caption,
        data = attachment_data))


Debugging & Development
-----------------------

What is the difference between App Engine versions and capabilities versions?
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Robot developers may find themselves using versions in two different places,
and getting confused about the purpose of each.

First, there is a version for a robot's capabilities (the events that they
subscribe to). That version is automatically generated as a hash of the robot's
capabilities, and programmatically outputted to a capabilities.xml file. The
wave server sees that the version (hash) has updated, and re-fetches the
information about that robot's capabilities.

There is also a version for the App Engine app as a whole, and this is
specified in the appengine-web.xml in the Java SDK, and the app.yaml in the
Python SDK. App Engine allows developers to push multiple versions of their
code live to their servers, to enable testing of new code before releasing it
to users. When you do change the version in your configuration file and upload
your app, that version is served at a special URL, accessible via the
"Versions" page in your dashboard. That version will only be served by default
when you explicitly click the "Make Default" button in the dashboard.

Developers may want to use App Engine versioning if their robot is currently
being used by users, and they do not want to risk breaking them until they have
tested their new changes. Developers that are in the beginning stages of
development should not need to use multiple App Engine versions

How can I enable "Show debug log"?
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

If you are on Wave sandbox, you can enable the debug log option by typing
"?ll=debug" after the final "/" in the URL (before the hash sign). For example:

https://wave.google.com/a/wavesandbox.com/?ll=debug#restored:wave:wavesandbox.com!w%252B7NmzY-gUK

Then, when you click the "Debug" menu in the upper right, the topmost option
will be "Show debug log". When you select this, a log will appear at the bottom
of the screen. Among other things, that log is helpful for debugging gadgets.
For more information, see this article on debugging gadgets.

Note: The "Debug" menu is only available in Wave sandbox, not in Wave preview.

How can I view the XML representation of a Wave?
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Google Wave stores all of the Wave and wavelet information as XML behind the
scenes, and developers can view that XML representation. Viewing the XML
version of a wave can help you understand Wave and the API better, and
sometimes help you debug your robot or gadget operations.

To view the XML representation of a wave, select "Show all wavelets" from the
"Debug" menu. This shows all the wavelets associated with a particular Wave,
including the main conversation, private replies, and the user wavelet
(reserved for use by the Wave client). Each wavelet contains a table of XML
documents. In the case of conversation wavelets, these are often documents
representing blips, but they may also represent data documents or tags.

To view just the XML representation of a single blip, click the upper
right-hand arrow in the blip, and select "Editor Debug" from the bottom. This
will pop up a window that is default to the "persistentDocument" view of the
blip. For an easier to read view, try the "localXml" option. To see just the
annotations and annotation ranges associated with a blip, select the
"annotations" option.

How can I retrieve the ID of a wave on Google Wave Preview?
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The URL bar is dynamically updated on navigation to include your wave ID.

For example, here is what a URL in the status bar might look like:

https://wave.google.com/wave/#restored:search:with%253Apublic,restored:wave:googlewave.com!w%252BKbPLzrfNB

Let's break it down:
https://wave.google.com/wave - the wave app

- # - separator for virtual vs real navigation
- restored:search:with%253Apublic - the search panel, currently searching
  with:public waves
- restored:wave: - the wave panel
- googlewave.com!w%252BKbPLzrfNB - the wave ID, in URL-encoded form.

To get the wave ID from here, simply change the "%252B" to a + sign. Thus, the
Wave ID is: googlewave.com!w+KbPLzrfNB

How long is an installer cached for?
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The Wave server caches the installer XML in two ways:

1) Per-wave: Once an installer element is inserted into a wave, the wave stores
   all of the information about the installer into the wave.

If you need to update an installer in an existing wave, you can change the
version attribute the installer XML to a higher value, and refresh the wave.
You'll see a "Refresh" button in the installer, and you can click that to
re-fetch the installer information.

Alternatively, you can delete the installer and re-insert it with a random
query parameter at the end of it, like
http://www.example.com/installer.xml?rand=12345.

2) Global: Once the Wave server sees an installer XML, it remembers the
   contents of that XML for about an hour - i.e.
   it does not re-fetch the XML for another hour. If you are testing changes
   to your installer, either insert it using
   the trick above or at a new URL.

These caching rules are the same on Wave Sandbox and Wave Preview.

How can I link to a wave?
^^^^^^^^^^^^^^^^^^^^^^^^^

There are several ways to link to a wave, depending on where you are linking
from.

If you are linking to a wave from an external page, we recommend using the
permalink format that is offered by the "Link to this wave" button. That format
looks like this:

`wave.google.com/wave/waveref/{{domain}}/{{wave_id_without_domain}}`

In the template above, you would replace the domain with something like
"googlewave.com" or "wavesandbox.com", and
replace the wave_id_without_domain with something like "w+M4nDhzgpB".

If you are using the robot API or gadgets API to obtain the wave ID, those APIs
will report an ID like "googlewave.com!w+M4nDhzgpB". You can split that ID into
the necessary parts using the "!" as the delimiter.

If you are linking to a wave from a wave, then we recommend setting the
"link/manual" annotation on the desired link text, and setting the key to a
waveref format. That format looks like this:

`waveid://{{ domain }}/{{ wave_id_without_domain }}`

As above with the permalink format, you would make the same substitutions to
this one.

Here's how you would append a link to a wave in Python:

.. code-block:: python

   domain = wavelet.domain
   wave_id = wavelet.wave_id.split('!')[1]
   wave_ref = 'waveid://%s/%s' % (domain, wave_id)
   blip.append('Cool wave', bundled_annotations=[('link/manual', wave_ref)])



What image types can be used in extension installers?
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

When specifying an image for your extension installer thumbnail or iconUrl, you
can refer to files that are PNG, JPG, GIF or data URI, which lets you encode
the image as a string. The data URI technique can be useful for
reducing bandwidth to your server.

How can I link to a blip?
^^^^^^^^^^^^^^^^^^^^^^^^^

There are several ways to link to a blip, depending on where you are linking
from.

If you are linking to a blipfrom an external page, we recommend using the
permalink format that is offered by the "Link to this message" item in the blip
menu. That format looks like this:

`wave.google.com/wave/waveref/{{ domain }}/{{ wave_id_without_domain }}/
~/{{ wavelet_id }}/{{ blip_id }}`

In the template above, you would replace the domain with something like
"googlewave.com" or "wavesandbox.com", replace the wave_id_without_domain with
something like "w+M4nDhzgpB", replace wavelet_id with 'conv+root' for the main
wavelet or the wavelet is if the blip is in a private reply, and replace
blip_id with something like 'b+3GagyivTJ'.

If you are using the robot API or gadgets API to obtain the wave ID, those APIs
will report an ID like "googlewave.com!w+M4nDhzgpB". You can split that ID into
the necessary parts using the "!" as the delimiter.

If you are linking to a wave from a wave, then we recommend setting the
"link/manual" annotation on the desired link text, and setting the key to a
waveref format. That format looks like this:

`waveid://{{ domain }}/{{ wave_id_without_domain }}/
~/{{ wavelet_id }}/{{ blip_id }}`

As above with the permalink format, you would make the same substitutions to
this one.

Here's an example of adding a blip link in Python, from the BlipLinky sample:

.. code-block:: python

    domain = wavelet.domain
    wave_id = wavelet.wave_id.split('!')[1]
    blip_id = event.blip.blip_id
    blip_ref = 'waveid://%s/%s/~/conv+root/%s/' % (domain, wave_id, blip_id)
    wavelet.root_blip.append(title, [('link/manual', blip_ref)])


What is the maximum length of descriptions in installers?
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The description in an installer should not be longer than 150 characters.
If it is longer than that, it will be truncated.

Google Wave Servers & Accounts

Do developers on Wave Sandbox have the ability to invite other developers to
Wave Sandbox?

There is no invite mechanism on Wave Sandbox, only on Wave Preview. If you are
trying to test your extension with multiple users, use your "-test" account in
a different browser, or ask one of the users in the forum to help test.
There is a long list of sandbox usernames of developers who are happy to wave
with you in this public wave.

How can I get a Wave account?
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

If you're a developer and want Wave sandbox access to test out your extensions,
fill out the form at

https://services.google.com/fb/forms/wavesignupfordev/.

If you want Wave preview access, fill out the form at

https://services.google.com/fb/forms/wavesignup/.

These are the only official ways to get an account.

I forgot my password - How can I have it reset?
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Since Wave sandbox is on a Google Apps domain, it does not have an automated
password reset system. This means that every request for a password reset must
be manually processed by the domain adminstrator (us).

We have received an unexpected number of requests for password resets for
Wave sandbox, and after trying to fulfill them, we have realized that we are
unable to fulfill all the reset requests.

Please request a new sandbox account if you have forgotten your password or
are unable to access your current one for whatever reason:

http://code.google.com/apis/wave/sandboxform.html

We are working to fulfill sandbox account requests within a week of sign-up.

Can developers on Wave Sandbox wave with developers on Wave preview?
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

There is currently no interop between the Wave Sandbox and Wave Preview
servers, so you cannot have a Wave with participants from the two different
servers. There will be a time in the future when the servers are federated, and
at that time, users will be able to wave across servers.

In the meantime, if you would like to communicate with users in Wave preview,
request an account here:

http://wave.google.com

How can I find other Wave sandbox users to wave with me or test my extensions?
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Many developers have put their Wave sandbox usernames in a forum thread.

We have closed that forum topic to reduce noise on the forum, however.
Going forward, willing developers can put their usernames in this public wave.

Using the Embed API

How can I embed waves in Blogger?
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

You can embed waves by pasting the JavaScript from the "Link to this wave"
dialog into your blogger posts. For full instructions, see this wave.

How can I embed waves in Sites?
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

You can embed waves using the Google Wave gadget for Google Sites. For full
instructions, see this wave.