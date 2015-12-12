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

Operations
==========

Operations within the Google Wave model are a type of remote procedure call
that allow robots to initiate actions on wavelets within Google Wave.
Operations may either be event-driven, in which case the operations are coupled
to receipt of an event within the Google Wave system, or active, in which case
the robot initiates actions on its own. Active robots make use of the Active
Robot API, which is a new feature within version 2 of the Robots API.

.. toctree::

Event Driven Operations
-----------------------

In event-driven mode, a web request from Google Wave includes information about
one or more events. The robot can respond with operations to update the wave in
which the event occurred.

A robot can perform operations on any wavelet in which it is a participant, and
can also create new wavelets and waves. Operations performed by a robot are not
reported back to the robot that did them or to other robots on the wavelet,
though they are reported to other non-robot participants in the affected
wavelet. For example, if a robot updates text within a Blip, it won't receive a
DOCUMENT_CHANGED event for that update.

Operations are handled in the order they are received, and robots do not have
any special privileges over other users. Robot operations are sent to the wave
and performed asynchronously; there is no guarantee that other participants may
not perform their own operations in the intervening time. As a result, it is
best to keep your operations as atomic as possible, and to understand that
operations which you apply to the wave may not be applied immediately. A wave
is a historical entity, and the content of a wave consists of its original
content plus the cumulative operations that occur on that data.

The Java and Python client libraries provide a complete interface for handling
events and performing operations. For example, the Java event handler uses a
web servlet to respond to Wave requests by parsing the event data into objects,
then calling a method on the servlet for each event. The method generates
operations by manipulating objects that represent the Wave data model. When the
method returns, the servlet sends all of the operations back to Google Wave to
be applied to the data.

Blip Operations
---------------

You can use the API to modify the content of blips, and these blip-level
operations are a combination of selections and actions. A selector operation
restricts operation to a subset of the blip, while the action performs the
actual operation on that selection.

The following methods are Blip selector operations:

* all(element|text) selects all content of the blip which matches the passed
  criteria.
* first() selects the first content within the blip which matches the passed
  criteria.
* at(index) selects a zero-based character position within the blip at the
  passed index value.
* range(start, end) selects a selection within the blip between the passed
  index values.

Each of these operations returns a BlipRefs object which can be acted upon. A
BlipRefs object is an Iterator object and can be acted upon by the appropriate
manner in the client libraries.

The following methods are BlipRefs actions:

* insert(element|text) inserts the passed text or element(s) at (immediately
  before) the given selection.
* insert_after(element|text) inserts the passed text or element(s) immediately
  after the given selection.
* replace(element|text) replaces the selection with the passed text or
  element(s).
* delete() deletes the selection.
* annotate(name,value) annotates the selection using the passed name/value pair.
* clear_annotation() clears the annotation at the selection.
* update_element(value) updates the element at the given selection with the
  passed value.


The following code illustrates how selectors and actions are typically used
together:

.. code-block:: python

   #Insert text at position 4
   blip.at(4).insert('text')

   #Insert gadget at position 4
   blip.at(4).insert(elements.Gadget(http://tricky-bot.appspot.com/gadget.xml))

   #Replace content at position 5 by 'hi':
   blip.at(5).replace('hi')

   #Replace content from position 3-7 with 'hi':
   blip.range(3,7).replace('hi')

   #Replace all instances of 'yo' by 'hi':
   blip.all('yo').replace('hi')

Note that these actions are performed on the server, as well as on the client;
as a result, you can inspect these operations within your server logs.

Wave Operations
---------------

You can use the API to do wave-level operations, like adding tags or
participants, and also to fetch or create new waves.

For example, the following Python code snippets show how to do wave-level
operations:

.. code-block:: python

   # Add a participant (making it public, in this case)
   wavelet.participants.add('public@a.gwave.com')

   # Change a participant role
   wavelet.participants.set_role('public@a.gwave.com',
           wavelet.participants.ROLE_READ_ONLY)

   # Add a tag
   wavelet.tags.append('coolwave')

   # Set a data document
   wavelet.data_documents['status'] = 'approved'

To create a new wave, you must specify the desired domain of the wave and the
starting set of participants. The following code snippets show how to create a
new wave in Python or Java:

.. code-block:: python

   # Python
   wave = robot.new_wave(domain='wavesandbox.com',
           participants=['someguy@wavesandbox.com'])

.. code-block:: java

   # Java
   Wavelet wave = robot.newWave("wavesandbox.com",
       Arrays.asList("someguy@wavesandbox.com"));

If you want to find out the ID of the new wave immediately after creating it,
like to store it in a database, you can set the submit argument to true, which
will submit the operation immediately to the server:

.. code-block:: java

   wave = robot.new_wave(domain='wavesandbox.com',
         participants=['someguy@wavesandbox.com'],
         submit=True)

To fetch a wave (given that you have access), you must specify the wave ID and
wavelet ID. The wave ID is of the form 'domain.com!w+characters', and the
wavelet ID is always 'domain.com!conv+root'. The following code snippets show
how to fetch a wave in Python or Java:

.. code-block:: python

   wavelet = robot.fetch_wavelet('googlewave.com!w+DYz-iagTK',
           'googlewave.com!conv+root')

.. code-block:: java

   wavelet = fetchWavelet(new WaveId('googlewave.com", "w+DYz-iagTK'),
       new WaveletId(domain, "conv+root"))

Operation Queues
----------------

Google Wave optimizes operations by bundling together operations pertaining to
a single wavelet within a single operation queue. Each separate wavelet has an
operation queue, on which you implicitly add operations; generally, the API
takes care of the low-level management of these queues.

For example, when handling events on a wavelet, you may receive several events,
and process several operations on the wavelet that spawned those events. Rather
than send each operation separately, the API bundles together operations on a
wavelet into a single operation queue, and executes the operations together as
one unit.

In most cases, the behavior of the operation queue is not important. By
default, the wavelet associated with the event being processed is automatically
sent back to the server when the event processing is done. However, if you
create operations on wavelets outside of your default operation queue (i.e. if
you create new wavelets or reference outside wavelets), or if you make use of
the Active Robot API, you will need to explicitly execute those operations
outside of the default operation queue.

For example, the robot.new_wavelet() method creates a new wavelet and allows
you to apply modifications to it. These operations must be explicitly applied.

When executing operations explicitly, you have two options:

* The wavelet.submit() method immediately applies the operation(s) within the
  passed wavelet.
* The wavelet.submit_with() method attaches the wavelet's operations to the
  passed wavelet's operation queue.

Generally, usage of submit_with() is recommended, as it attaches operations to
an existing wavelet's queue, reducing bandwidth. However, some operations
require that a pending operation complete before they be initiated. In those
cases, use wavelet.submit() to immediately apply the operation.

The following example illustrates these usages:

.. code-block:: python

   # Create a new wavelet and complete the operation
   # within the current operation queue
   new_wavelet = robotty.new_wave(old_wavelet.domain, old_wavelet.participants)
   new_wavelet.submit_with(old_wavelet)

   # Create a new wavelet and complete the operation
   # immediately
   new_wavelet = robotty.new_wave(old_wavelet.domain, old_wavelet.participants)
   robotty.submit(new_wavelet)

.. note::
   that a robot acting on an outside wavelet needs to authenticate, since it
   is operating outside of its default wavelet context. See Robot
   Authentication for more information.

Handling Operation Errors
-------------------------

In most common usages, robots operate in a strictly event-driven fashion. If an
event in which a robot has expressed interest fires, Wave notifies the robot of
the event over HTTP. The robot then responds to Google Wave over HTTP with any
operations it wants to apply to the wave. The operations are then applied
within Google Wave after the packet of operations is delivered.

As with all asynchronous communications, we can't discover problems with the
operation until it has completed its job on the server, by which time the robot
will no longer be connected. The solution to this problem is to provide some
type of callback so that the robot is notified of errors as they occur.

To assist with error handling, robots can register for the OPERATION_ERROR
event. This event is fired and sent to the robot if an operation fails on the
Wave server and an error is detected. The robot can then evaluate the event's
error string to detect the type of error.

By default, robots built using the python client library register for this
event and log the passed error message to the App Engine log. Developers can
inspect this log to check on any operation failures. To illustrate, the client
library implements this as:

.. code-block:: python

   def operation_error_handler(event, wavelet):

     """Default operation error handler, logging what went wrong."""
     if isinstance(event, events.OperationError):
       logging.error('Previous operation failed: id=%s, message: %s' %
           (event.operation_id, event.error_message))

   robot.register_handler(events.OperationError, operation_error_handler)

Proxying for Users
------------------

Robots often play a role in making information outside of Google Wave available
inside a wave. When they connect users outside of Google Wave, they become
gateways.

When robots implement gateways they need to represent users that typically
don't have a Google Wave account. In these cases, you can instruct your robot
to proxy as users that may not have a wave account. This proxying does not
involve any strict authentication of the other user; instead, the proxying
visually indicates that this operation is acting on behalf of some other
entity, and Google Wave will use this information to indicate that within the
client (by changing the robot's avatar, for example).

Robots proxy on behalf of some other entity per operation by calling the
proxyFor method in the Java SDK, and the proxy_for method in the Python SDK.

For example, this code uses the Python SDK to proxy a reply on behalf of the
'userid' user:

.. code-block:: python

   wavelet.proxy_for('userid').reply('\n').append('Hello!')

This code uses the Java SDK to make the same proxied reply:

.. code-block:: java

   wavelet.proxyFor("userid").reply("\n").append("Hello!");

If the wavelet was retrieved using the Active Robot API, using fetch_wavelet,
then you will need to manually add the robot address to the wavelet before
proxying. Using the Python SDK that would look like:

.. code-block:: python

   wavelet.robot_address = 'foo@appspot.com'
   wavelet.proxy_for('userid').reply('\n').append('Hello!')

And in the Java SDK:

.. code-block:: java

   wavelet.setRobotAddress("foo@appspot.com");
   wavelet.proxyFor("userid").reply("\n").append("Hello!");

The wave address of any user (or entity) is proxied in such a manner displays
its address using the form <robotid>+&kt;userid>@appspot.com. When a robot
receives events, these events are passed to the robot <robotid>@appspot.com
with the proxyingFor field set to the value of its proxyed userid. When the
profile of such addresses needs to be resolved, a JSON call is sent to the
robot that returns the profile for the specified user.

Robots can specify the profiles for proxied users by creating a profile
handler that responds with profile information for a given user.

For example, this code uses the Python SDK to return the profile for the
proxied user above:

.. code-block:: python

   robot.register_profile_handler(ProfileHandler)

   def ProfileHandler(name):
     if name == 'userid':
       return {'name': 'External User',
               'imageUrl': 'http://www.fakesite.com/avatar.gif',
               'profileUrl': 'http://www.fakesite.com/'}

This code uses the Java SDK to achieve the same:

.. code-block:: java

  @Override
  protected ParticipantProfile getCustomProfile(String name) {
      if (name.equals('userid') {
      return new ParticipantProfile("External User",
              "http://www.fakesite.com/avatar.gif",
              "http://www.fakesite.com");
      }
  }

The Active Robot API
--------------------

The Active Robot API is a new feature of the Wave Robots API Version 2.

Robots may not only act as passive entities, responding to events as they
occur, but may initiate their own operations as well. The Active Robot API
allows robots to send operations to Wave outside of the event-driven model.
In particular, this API allows for the following:

* Performing scheduled tasks (e.g. cron jobs) at specified intervals
* Creating new waves within Google Wave in response to actions within Google
  Wave itself
* (Most importantly) Responding to outside events or services by updating waves
  or creating new ones

The Active Robot API opens up a new set of possible actions that your robots
can perform. Rather than responding to events within Google Wave itself, robots
can respond to events or services outside of wave and initiate actions within a
wave. The Active Robot API provides an entry point for any outside entities to
contribute to Google Wave.

Additionally, the Active Robot API allows robots to create new waves, either
spawning them from existing waves, or creating them independently based on
outside information. For example, if you want to develop a robot that monitors
news events and alerts you when something interesting happens, the Active Robot
API is what you need.

Authenticating Your Robots
^^^^^^^^^^^^^^^^^^^^^^^^^^

To take advantage of the Active Robot API, you must first register your robot
so that we can authenticate requests the robot makes on your behalf. This
authentication process creates an OAuth token — a private cryptographic key
— which will both serve to identify the robot and authenticate when it
contacts Google Wave.

Robot Registration
__________________

To initate the robot authentication process, first visit the robot registration
page:

http://wave.google.com/wave/robot/register

Upon visiting this URL, you will be asked to supply the address of your
robot. Enter the full address (e.g. robot@appspot.com) and press Next.
You will be presented with a Verification Token and a URL containing an st
parameter, where the parameter value indicates a Security Token. Make sure
you make note of both of these values, as you'll need them later.

You will now need to verify your robot using the returned verification and
security tokens. Complete this process immediately, as these tokens will expire
in 30 minutes. The security token will act as a private shared secret
between you and Google. Whenever our server contacts your robot, it will set
the st parameter to this security token value so you can trust that the
response is from Google.

If you are using the Python API you can verify your robot using the
set_verification_token() method, passing the two token values. You can call
this method after creating the robot. See the sample code below:

.. code-block:: python

   verification_token = "VERIFICATION_TOKEN"
   security_token = "SECURITY_TOKEN"
   robot.set_verification_token_info(verification_token, security_token)

In Java, use setupVerificationToken(). You can create a constructor for your
robot, and call the method in there. See the sample code below:

.. code-block:: java

   public MyRobot() {
     String verificationToken = "VERIFICATION_TOKEN";
     String securityToken = "SECURITY_TOKEN";
     setupVerificationToken(verificationToken, securityToken);
   }

.. note::
   do not leave these tokens in code! As soon as you properly verify your
   robot, remove them from your code. (You may also store them in a separate
   file on your local file system and retrieve them programmatically).

Now upload your updated application to AppEngine. Once your application is
uploaded, click the Verify button on the verification page. If successful,
you will be brought to a page that contains your Consumer Key and
Consumer Secret.

Establishing Credentials
________________________

Once you have verified your robot as noted above, you can establish OAuth
credentials within your code anytime you wish to initiate operations from your
robot. Once those credentials are established with a handshake, the Active
Robot API is enabled.

The following code shows how the robot authenticates, which is similar using
both Python and Java client libraries:

In Python, you can authenticate the robot by calling setup_oauth after creating
the robot. See the sample code below:

.. code-block:: python

   robot.setup_oauth(CONSUMER_KEY, CONSUMER_SECRET,
       server_rpc_base='http://www-opensocial-sandbox.googleusercontent.com/api/rpc')

In Java, you can authenticate the robot by calling setupOauth in the
constructor for your robot. See the sample code below:

.. code-block:: java

   public MyRobot() {
     setupOAuth(CONSUMER_KEY, CONSUMER_SECRET,
         "http://www-opensocial-sandbox.googleusercontent.com/api/rpc");
   }

The third parameter depends on which Wave instance you are utilizing:

* Sandbox: http://www-opensocial-sandbox.googleusercontent.com/api/rpc
* Preview: http://www-opensocial.googleusercontent.com/api/rpc

Using the Active API
^^^^^^^^^^^^^^^^^^^^

Once your robot authenticates, you can initiate Active Robot API requests.
An example of such a request to create a new wave is shown below:

.. code-block:: python

   # Python
   wave = robot.new_wave(domain='wavesandbox.com',
       participants=['someguy@wavesandbox.com',])

.. code-block:: java

   # Java
   Wavelet wave = robot.newWave("wavesandbox.com",
       Arrays.asList("someguy@wavesandbox.com"));

Once your robot has obtained the ID of a wave for which it has access, it can
apply operations in the same manner as if it were responding to an event.
However, unlike in the event-driven API, where operations are submitted by the
API in response to events, you must specifically call the submit() method to
apply any Active Robot operations. For more information, see Operation Queues.

Using Blind Wavelets
^^^^^^^^^^^^^^^^^^^^

Active Robots may not only want to create new waves; they may of course want to
update existing waves as well. You can use the fetch_wavelet() method to
retrieve a wavelet with which you want to apply operations. However, because
waves are dynamic entities, you can't assume that any given snapshot of the
wave you have reflects the wave as it now exists.

To indicate this uncertainty the call to instantiate a wave based on the json
snapshot is performed using blind_wavelet() like this:

.. code-block:: python

   wave = robot.blind_wavelet(json_snapshot)

After creating a wave in this manner, you can apply operations at will, but you
must take special care to ensure that these operations won't conflict with any
pending changes. The append() and replace() methods should work relatively well
in that circumstance.