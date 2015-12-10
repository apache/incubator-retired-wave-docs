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

Raw deltas export
-----------------

To support importing wave data from wave.google.com to your own wave server, we
have added an option to the ROBOT_FETCH_WAVE method in the Wave Data API
(see example below) to get the raw deltas from a wavelet. These raw deltas
provide the wave's complete history. They're exported "as-is" and we expect
there will be a little work to postprocess them into a form suitable for import
into your own wave server.

You can try it out the new raw deltas option as follows:

First, authenticate with OAuth to get an access token. You can do that at the
OAuth Playground

(http://googlecodesamples.com/oauth_playground/):

* Choose your Scope(s): tick the Wave box
* Modify the OAuth Parameters: select HMAC-SHA1 and enter "anonymous" in the two
  first fields, oauth_consumer_key and consumer secret
* Follow steps 3-5 (using your googlewave.com account) to get the request
  token, authorize the roken, and finally get the access token which will be
  displayed in the request/response window. (If that window says invalid at any
  point along the way, retry from the beginning.) The access token has the
  form  oauth_token=1%2F...&oauth_token_secret=....

Download and unzip the python robot client library in a fresh directory with
the commands:

`curl -O http://wave-robot-python-client.googlecode.com/files/wave-robot-api-v2-20101202.zip
unzip wave-robot-api-v2-20101202.zip`

start python in this directory and run the following commands:

.. code-block:: python

    import waveservice
    w = waveservice.WaveService()
    w.set_access_token("oauth_token=1%2F...&oauth_token_secret=...")
    # the access token string from above
    f = w.fetch_wavelet('googlewave.com!w+tYBKatJxA', raw_deltas_from_version=0)
    # this wave is public
    f.raw_deltas  # prints the base64 encoded raw deltas

The `WaveService()` method takes an optional use_sandbox=True argument, if you
want to access waves from WaveSandbox.com. Replace the wave id above with the
id of the wave which you want to export.

Each raw delta is returned as a base 64 encoding of the binary representation
of  ProtocolAppliedWaveletDelta protocol buffer. You can use the ParseRawDelta
program to parse the base 64 string. The deltas have no signatures and no
history hashes.

Some caveats:
    Because of the simplistic access control in the Data API, you can only
    export a wavelet on which you are an explicit participant or which is public
    (has public@a.gwave.com as participant).

You can only export conversation wavelets, not userdata wavelets.

Some old waves on WaveSandbox.com cannot be exported because they contain some
bad legacy data in old deltas.
Each call returns at most X operations and at most Y MB of data. If you run up
against these limits, make another call with raw_deltas_from_version set to the
end version of the last delta returned.
FYI, we have also implemented a ROBOT_FETCH_WAVE option to return a raw
snapshot of a wavelet. Unfortunately, the data is in an internal undocumented
format and we may not be able to publish a specification for that, so please
try to make do with the raw deltas, at least for now.