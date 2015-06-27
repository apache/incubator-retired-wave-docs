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

Client Design
=============

This page aim to keep track of the technical and user experience design goals for Wave in a Box.
It is likely that discussions will be held in mailing lists and waves.
This page will be updated with the current thinking and outcomes of those discussions.


Current Collaboration Models
----------------------------

There are a few well established collaboration models that currently exists in the electronic frontier. We list them here not because WiaB intends to support all of them, replicate them, or replace them. They are discussed here because it is important to understand the current communication models that users are familiar with, why they work, and why they don't.

Instant Messaging / Chat
------------------------

:strong:`How it Works`

* Typically involves users communicating in near-real time.
* Users have presence state (i.e. they are online or offline).
* Users communicated and send messages typically when they are both online.
* Communication is linear in that messages are always added to the end of the conversation.
* Historical record of the conversation is typically managed by the client.
* Once a message is sent it is usually not editable (some protocols support this, but it is rare).
* Some protocols allow you to see that another user is actively typing, but generally don't deliver the message until the other user "sends" it.
* Multi-User Chat Rooms are supported.
* Private chats between sub groups happens "out of band" in side chat rooms or point to point messages.
* Typically allow sending files between users in the conversation.
* Limited ability to display files inline.
* Files are not stored in the chat for future retrieval.

:strong:`Why It's Useful`

The primary alternative to chat was email. With email, users had no expectation of when their messages would be received or responded to. Chat's use of presence information let users know when another user was available to participate in a live conversation. With this there was an expectation that if another user responded to your chat you would then engage in a near realtime discussion. The social aspects of chat dictated to a degree that conversations would have a well defined start and end (i.e. it was rude to walk away from your computer and terminate a chat without saying goodbye).

:strong:`What It's Good At`

The linear nature of the conversation makes it very simple to understand for one on one conversations that have a reasonable flow. There is a sense of active communication between parties that provides instant gratification communication. User's are generally online and available or not. This lets other users know what to expect in terms of responsiveness before they initiate the communication.

The chat service does not typically log conversations and chat clients generally only have rudimentary history functionality. Users generally don't have an easy way to search for conversations that took place several weeks ago to find information. This is a limitation of the clients but has lead to the perception that chat conversations are ephemeral, much like a face to face conversation. This leads to a much more informal style of communication. Email tends to be more formal since there is a perception that emails are forever. Part of the success of chat depends on users feeling free to "type without thinking". The type, then proof, then edit, then send process often used in email would take away from the liveliness of the chat conversation.

:strong:`What It's Bad At`

Chat is not so great at multi user conversations, or even conversations between two parties that are multi-topic or rapidly changing. The linear nature of chat makes it very difficult to respond to an earlier topic in the chat. For example if a remote user sends you two yes or no questions in back to back messages and you simply reply "no", it is not clear if you were referring to the first question or the second. This problem gets worse in multi user chat where side conversations are likely to pop up. Going back through the linear history and attempting to decipher the conversation threads is difficult.

Typical chat clients do not have sophisticated history and search functionality to allow users to pick up conversations that happened in the past. Additionally, once a chat message is sent it is usually not possible to edit that message. These two together make chat less than ideal for formal conversations and / or decision making.

Email / Mailing Lists
---------------------

Collaborative Document Editing
------------------------------
