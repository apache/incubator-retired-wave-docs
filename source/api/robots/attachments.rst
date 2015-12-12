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

Attachments
===========

An attachment is a type of element. Just like other elements, it can be
created, updated, and deleted from a blip. For more information on doing
operations on a blip, please refer to Selectors and Actions.

.. toctree::

Reading Attachments
-------------------

You can read wave attachment content and attributes by using the getters of the
attributes of an attachment: Attachment Id, Attachment URL, Caption, Data,
and MIME Type.

The following table provides detailed descriptions on these attributes:

.. csv-table::
   :header: Attribute Name, Description
   :delim: |

   Attachment Id    |Unique ID Assigned to an Attachment
   Attachment URL   |URL to Use to Download the Attachment
   Caption          |Caption or File Name for the Attachment
   Data             |Raw Binary Data for the Attachment
   MIME Type        |Attachment MIME Type (If Can be Determined)

The following is a java example of getting a list of urls for all attachments
in the blip. The code first iterates over all of the elements in a blip.
If an element is an attachment, it gets the attachment URL, and puts it into a
list:

* blip.getElements().values() returns all of the elements in a blip.
* element.isAttachment() returns true if the element is an attachment.
* ((Attachment)element).getAttachmentUrl() returns the attachment URL.

.. code-block:: java

   private List<String> getAllAttachmentUrls(Blip blip) {
     List<String> urls = new ArrayList<String>();
     Collection<Element> elements = blip.getElements().values();
     for (Element element : elements) {
       if (element.isAttachment()) {
         urls.add(((Attachment) element).getAttachmentUrl());
       }
     }
     return urls;
   }

The following is a Python example of getting an attachment URL. If the blip has
an attachment, the code appends the first attachment URL to the blip.

.. code-block:: python

   def OnBlipSubmitted(event, wavelet):
     blip = event.blip
     attachment = blip.first(element.Attachment)
     if attachment:
       blip.append("Attachment URL is:" + attachment.value().get("attachmentUrl"))


Writing Attachments
-------------------

Attachments can be created, updated, and deleted. You create an attachment by
providing an attachment caption and data. You update an attachment by replacing
the old attachment with a new attachment. You delete an attachment by removing
the attachment element.

The following is a java example of creating an attachment in wave. The code
iterates over the blips in a wavelet, gets the text content, creates an
attachment with the concatenated content as data, and inserts the attachment in
a new blip:

* wavelet.getBlips().values() returns all of the blips in a wavelet.
* blip.all().values() returns the blip contents
* new Attachment("export.txt", exportedWave.toString().getBytes()) returns a
  new attachment.

.. code-block:: java

   private void exportText(Wavelet wavelet) {
     StringBuilder exportedWave = new StringBuilder();

     for (Blip blip : wavelet.getBlips().values()) {
       exportedWave.append(blip.getContent());
     }
     Attachment attachment = new Attachment("export.txt",
         exportedWave.toString().getBytes());
     wavelet.reply("\n").append(attachment);
   }

The following is a python example of creating an attachment in wave. The code
fetches an URL content, and creates an attachment with the content.

.. code-block:: python

   def OnBlipSubmitted(event, wavelet):
     blip = event.blip
     fileData=urllib2.urlopen("http://www.google.com/logos/poppy09.gif").read()
     attachment = element.Attachment(caption="new file", data=fileData)
     blip.append(attachment)

The following is a java example of importing an attachment into wave by
replacing it with its content. This example assumes that the attachment in the
blip is text attachment. The code finds the first attachment in the blip, and
replaces it with the attachment content:

* blip.first(ElementType.ATTACHMENT) returns a blip content reference of the
  first attachment.
* (Attachment) attachmentRef.value() returns an attachment element.
* attachmentRef.replace(new String(attachment.getData())) replaces an
  attachment with its content.

.. code-block:: java

   private void replaceAttachment(Blip blip) {
     BlipContentRefs attachmentRef = blip.first(ElementType.ATTACHMENT);
     if(attachmentRef != null) {
       Attachment attachment = (Attachment) attachmentRef.value();
       attachmentRef.replace(new String(attachment.getData()));
     }
   }

With the ability of reading and writing attachment in wave, you can do a lot of
things. Below are a few more ideas in addition to import and export:

* Origami Photo Album: you can read a list of images, compose the images with a
  few styles, and attach the images back to wave.
* Chart Creation: you can read a file, transform the content of the file to a
  chart, and insert the chart into wave.
* File concatination: you can read all the files from a wavelet, concatinate
  the contents, create a new file, and insert into wave.

Samples
-------

The following examples demonstrate using attachments:

Static Mappy - Converts a selected address into a static map.