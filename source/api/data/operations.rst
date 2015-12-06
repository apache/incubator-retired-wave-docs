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

Applications can retrieve or modify wave data by using operations. Some
operations are read operations, like fetching a wave, while some are write
operations, like adding tags to a wave.

Contents

.. toctree::

You can use the API to search for waves in the user's account. For example,
this Python code retrieves and logs the top 20 waves in the user's inbox:


search_results = service.search(query='in:inbox', num_results=20)
for digest in search_results.digests:
  logging.info(digest.title)
You can also use the API to do other searches, using the search operations
described in the Wave help guide.

Wave Operations
---------------

You can use the API to do wave-level operations, like adding tags or
participants, and also to fetch or create new waves.

For example, the following Python code snippets show how to do wave-level
operations:


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


# Python
wave = robot.new_wave(domain='wavesandbox.com',
        participants=['someguy@wavesandbox.com'])

# Java
Wavelet wave = robot.newWave("wavesandbox.com",
        Arrays.asList("someguy@wavesandbox.com"));
If you want to find out the ID of the new wave immediately after creating it,
like to store it in a database, you can set the submit argument to true,
which will submit the operation immediately to the server:


wave = robot.new_wave(domain='wavesandbox.com',
        participants=['someguy@wavesandbox.com'], submit=True)
To fetch a wave (given that you have access), you must specify the wave ID and
wavelet ID. The wave ID is of the form 'domain.com!w+characters', and the
wavelet ID is always 'domain.com!conv+root'. The following code snippets show
how to fetch a wave in Python or Java:


wavelet = robot.fetch_wavelet('googlewave.com!w+DYz-iagTK',
         'googlewave.com!conv+root')

wavelet = fetchWavelet(new WaveId('googlewave.com", "w+DYz-iagTK'),
        new WaveletId(domain, "conv+root"))

Blip Operations
---------------

You can use the API to modify the content of blips, and these blip-level
operations are a combination of selections and actions. A selector operation
restricts operation to a subset of the blip, while the action performs the
actual operation on that selection.

The following methods are Blip selector operations:

all(element|text)
    selects all content of the blip which matches the passed criteria.
first()
    selects the first content within the blip which matches the passed criteria.
at(index)
    selects a zero-based character position within the blip at the passed index
    value.
range(start, end)
    selects a selection within the blip between the passed index values.

Each of these operations returns a BlipRefs object which can be acted upon.
A BlipRefs object is an Iterator object and can be acted upon by the
appropriate manner in the client libraries.

The following methods are BlipRefs actions:

insert(element|text)
    inserts the passed text or element(s) at (immediately before) the given
    selection.
insert_after(element|text)
    inserts the passed text or element(s) immediately after the given selection.
replace(element|text)
    replaces the selection with the passed text or element(s).
delete()
    deletes the selection.
annotate(name,value)
    annotates the selection using the passed name/value pair.
clear_annotation()
    clears the annotation at the selection.
update_element(value)
    updates the element at the given selection with the passed value.

The following code illustrates how selectors and actions are typically used
together:


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