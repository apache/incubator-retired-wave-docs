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

Google Wave API Overview
########################

This is a copy of the documentation that was formally at code.google.com/apis/wave

.. todo:: Update these documents to match the capabilities of Wave-in-a-Box,.

.. toctree::

Welcome to Wave Development
---------------------------

The Google Wave API is an open platform allowing developers to extend the functionality of Google Wave itself, or
extend other applications with waves. As a developer, you can think of Google Wave as three pieces:

* The Google Wave client application, the interface designed for users
* The Google Wave APIs, which are documented throughout this site
* The Google Wave Federation Protocol, the underlying network protocol for wave communication

This developer guide discusses the Wave APIs and how you can use them to augment Google Wave through extensions or
augment third-party web applications by embedding Google Wave within them. This overview discusses the elements
that make up the "waves" in the Google Wave model.

Wave Entities
-------------

Programming effectively using the Google Wave APIs requires understanding some basic wave concepts.

A **wave** is a threaded conversation, consisting of one or more participants (which may include both human participants
and robots). The wave is a dynamic entity which contains state and stores historical information. A wave is a living
thing, with participants communicating and modifying the wave in real time. Significantly, a wave serves only as a
container for one or more wavelets defined below; the "wave" itself is simply a group of wavelets

A **wavelet** is a threaded conversation that is spawned from a wave (including the initial conversation). Wavelets
serve as the container for one or more documents (of which the basic conversational document is known as a blip). The
wavelet is the basic unit of access control for data in the wave. All participants on a wavelet have full read/write
access to all of the content within the wavelet. As well, all events that occur within the Google Wave APIs operate on
wavelet level or lower. When you spawn a wavelet from within a wave, you do not inherit any access permissions from the
parent wavelet. During the lifetime of a wave, you may spawn private conversations, which become separate wavelets, but
are bundled together within the same "wave."

A **document** is a unit of content attached to a wavelet. Two basic types of documents exist within the Wave API:

* A blip is the basic unit of conversation and consists of a single messages which appears on a wavelet. Blips may also
  contain other blips as children, forming a blip hierarchy. Each wavelet always consists of at least one root blip.
* Data documents are documents containing data that pertain to the wavelet but are not displayed to the user.
  (For example, Spelly stores spelling suggestions for misspelled words within a data document.) Data may be in any
  format but is typically key/value pairs. Documents are used as an internal datastore for the wavelet. Data documents
  may also act as scratch pads where extensions can place intermediary data and/or logging data.

Although blips and data documents are each "documents," in practice, you treat them quite separately. Each blip consists
of markup (similar to XML) which can be retrieved, modified or added by the API. Generally, you manage the blip through
convenience methods rather than through direct manipulation of the XML data structure. Blips are very structured, while
data documents may have no intrinsic schema (though often contain their oen self-defined structure).




What Is the Google Wave API?
----------------------------

The "Wave API" actually consists of several APIs which provide different functionality (and may be combined together).
Three primary types of development are available within the Wave API:

* Extensions:
  Developers can enhance Google Wave itself by authoring mini-applications (extensions) that interact with the Wave.
  Developers can create robots which interact with waves, or gadgets which participants may interact with (and
  combinations of robots and gadgets are also supported). For more information, consult the Wave Extensions Developer's
  Guide.

* Embedded Waves:
  Developers can enhance their existing web applications by embedding Google Wave directly in their application,
  allowing you to seamlessly integrate communication and collaboration. For more information, consult the Wave Embed
  Developer's Guide.

* Wave Data API Apps:
  Developers can create applications like notifiers or alternative Wave client interfaces using the Wave Data API,
  which lets apps access the data of users that grant access to the app. For more information, consult the Wave Data API
  Developer's Guide.

In addition to the developer's guide and the reference material, you may wish to check out the sample code.

Sandbox Development
-------------------

Developers using Google Wave may work with two instances of Google Wave: the development version of Google Wave known as
the Sandbox (available at http://wave.google.com/a/wavesandbox.com/ ) and the public version known as Google Wave Preview
(available at http://wave.google.com/ ).

All initial Wave API development should take place in the sandbox. The sandbox is a developer-only instance of Google
Wave where you can freely test and debug extensions you develop with other developers. You can request developer access
to the sandbox using this form. When they are ready to share your application with the general population, you will want
to deploy your extensions to Wave Preview. You can access Wave Preview using any Google account.

The sandbox is similar to the Google Wave Preview at http://wave.google.com/ in many ways, though there are some
differences:

* Experimental API features may be deployed to Sandbox before Preview, allowing you to test out the API and offer
  suggestions for improvements before the API solidifies.
* New Wave client features are deployed to Sandbox before Preview, providing you an opportunity to test out new
  functionality before release to the general public.
* The Wave Sandbox provides a Debug menu which provides additional functionality for developers.
* Passing the flag &ll=debug to a Wave Sandbox URL adds a Show debug log menu item to the Debug menu, allowing you to
  dynamically show debug information within a special window.
* The Wave Sandbox works with Federated Wave servers, while the production version works only with Google domains
  (except Wave Sandbox).

Additionally, the Google Wave Preview instance provides a few bells and whistles you won't find in Wave Sandbox,
including additional default Wave content, the Extensions Gallery, and operability with Wave servers running under
Google Apps domains.

Once you've thoroughly experimented and tested your extensions on the Sandbox, you will want to package an extension up
into an Extension Installer and test it with other developers. Once your application is ready for the real world, you
can deploy it to the Google Wave Preview instance and share it with your friends or colleagues. If you want your
extension to be in the public extensions gallery, so that all users can install it, then submit it
`here <http://www.waveprotocol.org/wave-apis/extensions/e>`_.