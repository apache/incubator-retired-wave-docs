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

Wave Model Code Walk
====================

This doument provides an informal overview of the code providing the wave model. The wave model describes the basic building blocks of a wave application: what a wave is and how it can change. It also provides application models which implement more abstract data structures on top of waves. The most familiar is the conversation model which implements the conversational structure of waves presented in, for example, the Google Wave client.

This walkthrough describes the major modules comprising the wave model in a bottom-up fashion.

The wave model code lives under the src/org/waveprotocol/wave/model directory

Under construction!
-------------------

The wave model code is under active development. The code structure may differ from that described here, though we'll try to keep it up to date. The code as initially released also contains a few pieces of legacy from Google Wave's infancy, pieces of code we've learnt should be done differently. We intend to clean these up over time.

Let's explore the code
----------------------

:strong:`Operations: model.operation.*` |br|
These modules implement operations, which are the fundamental unit of state change. The model.operation package describes purely generic operations simply as things which apply to some target. Sub-packages contain specific operation implementations and their transformation.

* model.operation.core: operations which apply to the data objects in model.wave.data.core.
* model.operation.wave: operations applying to the extended data interfaces in model.wave.data.

Legacy note: The operations in model.operation.core represent our ideal minimum set of operations. The model.operation.wave package contains some legacy operations and concepts. In particular, the concept of a "blip" (a conversational message) and the operations targeting it do not belong at this low level of abstraction.

:strong:`Starting points:` |br|

* model.operation.Operation
* model.operation.core.WaveletOperation

:strong:`Documents: model.document.*` |br|
These modules implement wave documents, which contain almost all the state of a wavelet. A wave document is an XML-like sequence of elements and text nodes plus a set of stand-off key/value annotations.

* model.document.bootstrap: a very simple demonstration document implementation.
* model.document.raw: a raw DOM-style document substrate.
* model.document.operation: operations applying to documents and their transformation, along with utilities including composition and normalization. Also an automaton for generating random operations for testing.
* model.document.indexed: an indexed tree structure providing fast random access to nodes in a document. An indexed document is mutated by accepting operations.
* model.document: mutable and observable document implementations based on a indexed documents.

:strong:`Starting points:` |br|

* model.document.Document: the high-level mutable document interface
* model.document.ObservableDocument: extends Document to provide events

:strong:`Waves: model.wave.*` |br|
This modules implement waves and wavelets. A wavelet comprises a set of documents and a set of participant identifiers.

* model.wave.data: simple, "dumb" ADTs, which are the targets of operations. The core sub-package contains pure, metadata-free implementations sufficient for servers. Also a number of document factories for use with the data objects.
* model.wave: the abstract wave view, wavelet, blip and participant id interfaces which define the semantics of these types.
* model.wave.opbased: operation-based implementation of a wavelet which performs mutations by generating and applying operations to an underlying wavelet data
* model.wave.undo: utilities for reversing wavelet operations

Note that there is a clear separation between the semantic free data types in model.wave.data, which implement pure "dumb" data containers, and the abstract objects in {{model.wav}}e. This separation of data from semantics is repeated in other high-level packages.

Legacy note: The interfaces in these packages conflate wave metadata, such as timestamps and version numbers, with the pure wave data. Themodel.wave.data.core contains our ideals of the data interfaces. The metadata does not behave in the same way as the data and we intend to separate it to reduce confusion. The inclusion of the blip concept here also is a legacy which doesn't belong.

:strong:`Starting points:` |br|

* model.wave.Wavelet
* model.wave.opbased.OpBasedWavelet

:strong:`Identifiers: model.id and model.waveref` |br|
These modules contain implementations of wave identifiers and references plus utility classes for working with them. Wave and wavelet ids uniquely identify their objects.
Waverefs extend wave and wavelet ids to refer to points within a wave. At present this extends just to documents but will soon include locations and versions within those documents.

Legacy note: The code in model.id does not yet implement the draft specification for identifiers and includes an inelegant serialization scheme. Waverefs implement a superior serialization.

:strong:`Starting points:` |br|

* model.id.WaveId and model.id.WaveletId
* model.waveref.WaveRef

:strong:`Abstract data types: model.adt.*` |br|
These modules implement abstract concurrent data types on wave documents, including lists, sets, maps and monotonic values. These data types are safe for use with wave's optimistic concurrency model, guaranteeing convergence when used correctly. These data types are the foundation for all concurrent application models built on waves.

:strong:`Starting points:` |br|

* model.adt.BasicValue and model.adt.docbased.DocumentBasedBasicValue
* model.adt.BasicSet and model.adt.docbased.DocumentBasedBasicSet

:strong:`Document schemas: model.schema.*` |br|
This module implements schema constraints for wave documents. Schemas constrain the content of wave documents so they may be safely interpreted by clients, including as abstract data types. Document schemas are compatible with operational transform such that a change which is valid at a client remains valid at the server and all other clients, regardless of the concurrent operations against which the change is transformed.

Legacy note: The current hard-coded schema implementation has a number of shortcomings and there are plans to move to a more powerful and flexible implementation.

:strong:`The conversation model: model.conversation` |br|
This package implements the abstract conversation model which describes the threaded conversational waves you commonly interact with in the Google Wave client.

:strong:`Starting points:` |br|

* model.conversation.Conversation
* model.conversation.WaveletBasedConversation

:strong:`Testing support: model.testing` |br|
This package contains support classes for testing the wave model and code interacting with the wave model.


.. |br| raw:: html

   <br />