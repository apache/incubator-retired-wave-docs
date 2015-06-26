..  Licensed to the Apache Software Foundation (ASF) under one
    or more contributor license agreements.  See the NOTICE file
    distributed with this work for additional information
    regarding copyright ownership.  The ASF licenses this file
    to you under the Apache License, Version 2.0 (the
    "License"); you may not use this file except in compliance
    with the License.  You may obtain a copy of the License at

..    http://www.apache.org/licenses/LICENSE-2.0

..  Unless required by applicable law or agreed to in writing,
    software distributed under the License is distributed on an
    "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
    KIND, either express or implied.  See the License for the
    specific language governing permissions and limitations
    under the License.


Writing a DooDad
================

**TODO:** Add images to help

**TODO:** High level overview of what doodads are and how they work, conceptually (wave editor presentation contains
a lot of this)

In this tutorial we will build up a simple Image doodad, similar to the image thumbnails we are familiar with.
We'll cover many editor features as we move through various versions of our doodad. We'll build up the code that can be
found in org.waveprotocol.wave.client.editor.examples.img, if you'd like to follow along from scratch, simply replace
that package in the examples with whatever package you're working in.

Set up the environment
----------------------
Follow the instructions on setting up "Editor Test Harness" in Client Development Setup

Create a new Test Harness
-------------------------
In the package of your choosing, add the following files. The examples below will assume this has been done in
org.waveprotocol.wave.client.editor.tutorial
The complete solution is at org.waveprotocol.wave.client.editor.examples.img

:strong:`TestModule.java:`

.. note::

    Use Ctrl+Shift+O to get the required import statements in eclipse.
    In later examples, some import statements that are ambiguous will be explicitly listed for clarification

To get up and running, you need is this code:

.. code-block:: java

    public class TestModule implements EntryPoint {

        @Override
        public void onModuleLoad() {
            final EditorHarness harness = new EditorHarness();
            harness.run();
        }
    }

:strong:`TestModule.gwt.xml:` |br|
And of course a GWT module definition. Just declare the entry point, and a dependency on the EditorHarness.

.. code-block:: xml

    <module>
        <source path=""/>
        <entry-point class="org.waveprotocol.wave.client.editor.tutorial.TestModule" />
        <inherits name="org.waveprotocol.wave.client.editor.harness.EditorHarness" />
    </module>

:strong:`Launch`

1. Edit build.xml

    * Copy and paste <target name="editor_hosted" ...>...</target>
    * Rename

        * editor_hosted -> img_hosted
        * org.waveprotocol.wave.client.editor.harness.EditorTest -> org.waveprotocol.wave.client.editor.harness.tutorial.TestModule
    * The result looks like:

.. code-block:: xml

    <target name="img_hosted" depends="compile,compile_proto_gwt"
    description="Runs the editor harness through the GWT hosted mode server,
    for debugging in a JVM.">
        <java failonerror="true" fork="true" classname="com.google.gwt.dev.DevMode">
            <classpath>
                <pathelement location="proto_gwt_src"/>
                <pathelement location="src"/>
                <path refid="libpath"/>
            </classpath>
            <jvmarg value="-Xmx512M"/>
            <jvmarg value="-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,
            address=8001"/>
            <arg line="${gwt.args}"/>
            <arg line="-war war"/>
            <arg line="-startupUrl
            org.waveprotocol.wave.client.editor.tutorial.TestModule/EditorTest.html"/>
            <arg value="org.waveprotocol.wave.client.editor.tutorial.TestModule"/>
        </java>
    </target>


2. Start oophm

    * ant img_hosted
    * Open a browser and connect eclipse debugging session to oophm. See Client Development Setup

        * e.g. browser url `click meh <http://127.0.0.1:8888/org.waveprotocol.wave.client.editor.tutorial.TestModule/EditorTest.html?gwt.codesvr=127.0.0.1:9997>`_

:strong:`Get Going`

Let's see what happens when we try to create one of our doodads before doing anything.

    * In the "set content" area, type <mydoodad/>
    * You should see an error: |br|
      test (1289350503.948): That content does not conform to the schema: [more details....

The reason is, we haven't permitted our new element in the schema. To fix this, let's define the schema for our element.
Override EditorHarness's getSchema() method like so:

.. code-block:: java

    // Anonymous subclass of EditorHarness.
        final EditorHarness harness = new EditorHarness() {
        /**
        * Extend the schema with our experimental new doodad.
        *
        * Note that this is only necessary for new element types that are not
        * already in the main document schema.
        */
        @Override
        public DocumentSchema getSchema() {
            return new DefaultDocumentSchema() {
                {
                    // Permit our doodad to appear inside the <body> element
                    addChildren("body", "mydoodad");
                }
            };
        }
    };


Now refresh and try again.

This time it should not give any error, instead we should get a grey box that looks like this <mydoodad>. That's
the default renderer we get when we haven't registered one for that element type. So let's go and do that...


Create a Simple Renderer
------------------------

Let's create a class MyDoodad. We'll put our renderer as an inner class for now, since we'll be adding a few more small
classes later to do other things, and it's convenient to group them together.

.. code-block:: java

    // Listing import statements when they might be ambiguous.
    // For the rest, Ctrl+Shift+O in eclipse does the trick.
    //
    import com.google.gwt.dom.client.Document;
    import com.google.gwt.dom.client.Element;

    public class MyDoodad {
        public static String TAGNAME = "mydoodad";
        public static String REF_ATTR = "ref";

        /**
        * A trivial renderer that keeps the image's src attribute up-to-date with the
        * model's ref attribute.
        */
        static class SimpleRenderer extends RenderingMutationHandler {

            @Override
            public Element createDomImpl(Renderable element) {
                Element imgTag = Document.get().createImageElement();
                DomHelper.setContentEditable(imgTag, false, false);
                return imgTag;
            }

            @Override
            public void onActivatedSubtree(ContentElement element) {
                fanoutAttrs(element);
            }

            @Override
            public void onAttributeModified(
                ContentElement element, String name, String oldValue, String newValue) {
                    if (REF_ATTR.equals(name)) {
                        element.getImplNodelet().setAttribute("src", newValue);
                    }
            }
        }
    }


Explanation: there's two parts to the methods we add to our handler here:

1. The createDomImpl method is called to provide the skeleton DOM of our doodad, i.e. DOM that would be the same for all instances, regardless of the actual state of the XML (attributes, child nodes).

.. note::

    We use the setContentEditable method to stop the browser from putting fancy resize 9-boxes on our poor image.

2. The onXYZ methods are part of the NodeMutationHandler interface, that gets called when changes actually happen.

    * onAttributeModified gets called whenever an attribute changes. In this case, we'll introduce a simple "ref" attribute that will refer to the image URL we want to display. The code simply checks the name, and then updates the HTML DOM accordingly.

    .. note::

        the term "nodelet" is a convention used to refer to HTML nodes, as an abbreviated way to disambiguate between our XML model nodes and our HTML rendering nodes.

    * However, we also want to update the rendering for an initial state as well, since our handler will get attached to the document after it has been created. It could also be added or removed at any time. So we override onActivatedSubtree(), which will get called whenever our handler gets applied to an element.

        * We use a convenience utility "fanoutAttrs" which will simulate attribute-modified events for all existing attributes. For most simple doodads, this trick is sufficient, and lets us reuse code.

        .. note::

            there is also an onActivationStart() method we could choose to override. The only difference is that onActivationStart() gets called before these methods get called for child nodes, and onSubtreeActivated() gets called after. If in doubt, it's usually better to override onSubtreeActivated().

        OK, now we want to register our renderer with the mydoodad tag name, so it gets applied to elements matching that name.

Let's head back to TestModule.java

First thing's first, we've introduced a 'ref' attribute, so let's go and add that to the schema:

.. code-block:: java

    // Permit a 'ref' attribute on the <mydoodad> element. We'll use this in the next step.
    // e.g. permit content like <mydoodad ref='pics/wave.gif'/>
    addAttrs(MyDoodad.TAGNAME, MyDoodad.REF_ATTR);

Now, let's register our renderer. It's convention to create a static "register" method inside the doodad class,
in this case, MyDoodad, and put all the registration in there. It's a good convention because it means less boilerplate
for callers; also, the register method acts as a sort of manifest, and declares all the dependencies of the doodad
(just add more arguments to the register method if there are other things your doodad handlers need to be set up).
Currently there's just one line of code in it, but we're going to add a few more later, and this makes it easier. |br|
So, in MyDoodad.java:

.. code-block:: java

    public static void register(ElementHandlerRegistry registry) {
        registry.register(Renderer.class, TAGNAME, new SimpleRenderer());
    }

And then, to actually hook it up, back in TestModule.java we override a new method from EditorHarness, the extend()
method, like so:

.. code-block:: java

    @Override
    public void extend(Registries registries) {
        MyDoodad.register(registries.getElementHandlerRegistry());
    }

Done. Refresh, and try <mydoodad ref='pics/wave.gif'/> for content. You should see a nice wave logo.

Adding a simple UI event handler
--------------------------------
Let's add something to let users change the image, which will also exercise the onAttributeModified() code in a
different way. Add this code to MyDoodad.java:

.. code-block:: java

    import com.google.gwt.user.client.Event;

    static class SimpleEventHandler extends NodeEventHandlerImpl {

        @Override
        public void onActivated(final ContentElement element) {
            Helper.registerJsHandler(
                element, element.getImplNodelet(), "click", new JavaScriptEventListener() {
                    @Override
                    public void onJavaScriptEvent(String name, Event event) {
                      promptNewRef(element);
                    }
                });
        }

        @Override
        public void onDeactivated(ContentElement element) {
            // Cleanup
            Helper.removeJsHandlers(element);
        }
    }

    static void promptNewRef(ContentElement element) {
        String newRef = Window.prompt("New Ref", element.getAttribute(REF_ATTR));
        if (newRef != null) {
            // Get the document view for mutating the persistent state, then update it
            element.getMutableDoc().setElementAttribute(element, REF_ATTR, newRef);
        }
    }

Now we simply need to register this class for the mydoodad tag name against NodeEventHandler.class. Let's add another
line to our register method. So, in MyDoodad.java, it should look like this:

.. code-block:: java

    public static void register(ElementHandlerRegistry registry) {
        registry.register(Renderer.class, TAGNAME, new SimpleRenderer());
        registry.register(NodeEventHandler.class, TAGNAME, new SimpleEventHandler());
    }

Done. Refresh, and try <mydoodad ref='pics/wave.gif'/> for content. Now, clicking the doodad should let us change its
image. Try changing it to pics/yosemite-sm.jpg

Canned content for debugging
----------------------------
To save us some typing so we don't have to type in the content we want to test each time, we can set up some canned
content for the suggest box. To do this, simply override this method for EditorHarness:

.. code-block:: java

    @Override
    public String[] extendSampleContent() {
        return new String[] {
            "<mydoodad ref='pics/wave.gif'/>",
            "<mydoodad ref='pics/yosemite-sm.jpg'/>",
            "<mydoodad ref='pics/hills-sm.jpg'><mycaption>Howdy</mycaption></mydoodad>",
        };
    }

(Run it, and start typing in the content box as you would, and auto-complete suggestions will popup).
I've also added an example with a caption there that won't work yet, but we'll use it in the next example.

Using a full-blown GWT widget, and adding an editable sub-region
----------------------------------------------------------------
Let's spruce things up a bit. We want to add support for adding captions, and put a bit of nice chrome around our
doodad. Instead of just using a plain image element, we can use a GWT widget. Elements with manual event handlers are
good because they are lightweight, but in this case we've decided we want to use a widget.

:strong:`Write our vanilla GWT widget`

Create a file CaptionedImageWidget.ui.xml:

.. code-block:: xml

    <ui:UiBinder
        xmlns:ui='urn:ui:com.google.gwt.uibinder'
        xmlns:gwt='urn:import:com.google.gwt.user.client.ui'
        >

      <ui:style>
        .top {
          margin-left: 2px;
          margin-right: 1px;
          border-left: 1px solid #ccf;
          border-top: 1px solid #ccf;
          border-right: 2px solid #88a;
          border-bottom: 2px solid #88a;
          background: #eee;
          padding: 4px;

          /* NOTE(danilatos): More rules are needed to get this to work in IE.
           * See ImageThumbnail */
          display: inline-block;
          position: relative;
        }

        /*
         * For some reason, the programmatic fixing of whitespace doesn't work for
         * FF, need to figure out why...
         */
        @if user.agent gecko1_8 {
          .top {
            white-space: normal;
          }
        }

        /* Apply the style to immediate children, i.e. the caption, not to the container
         * itself. This way we don't get ugly artifacts when there is no caption. */
        .container > * {
          margin-top: 4px;
          border: 1px solid #aac;
          border-left: 2px solid #88a;
          border-top: 2px solid #88a;
          text-align: center;
          background: white;
        }
      </ui:style>

      <gwt:HTMLPanel styleName='{style.top}'>
          <gwt:Image ui:field='image'/>

          <!-- Child nodes (i.e. the caption) will go inside this container -->
          <div ui:field='container' class='{style.container}'></div>
      </gwt:HTMLPanel>
    </ui:UiBinder>

And it's widget class, CaptionedImageWidget.java:

.. code-block:: java

    public class CaptionedImageWidget extends Composite {

        public interface Listener {
            void onClickImage();
        }

        /** UiBinder */
        interface Binder extends UiBinder<HTMLPanel, CaptionedImageWidget> {}
        private static final Binder BINDER = GWT.create(Binder.class);

        @UiField Element container;
        @UiField Image image;

        private Listener listener;

        public CaptionedImageWidget() {
            initWidget(BINDER.createAndBindUi(this));
        }

        public void setListener(Listener listener) {
            this.listener = listener;
        }

        public Element getContainer() {
            return container;
        }

        public void setImageSrc(String src) {
            image.setUrl(src);
        }

        @UiHandler("image")
        void handleClick(ClickEvent e) {
            if (listener != null) {
                listener.onClickImage();
            }
        }
    }

Note that there is nothing special about these two files, this is a stock-standard ui-binder widget.

Write the renderer and handler for the new widget
-------------------------------------------------
The code is basically the same as before, the only thing to note is: |br|
For GWT widgets, we subclass GwtRenderingMutationHandler, which takes care of all the GWT widget logical attach/detach
behavior for us. Event handling will then be hooked up correctly when the widget is placed in the editor
(or other interactive context), and will not work when it's in read-only render mode. |br|
We also haven't added support for captions yet, we'll do that in a minute.

Add this class inside MyDoodad:

.. code-block:: java

    static class CaptionedRenderer extends GwtRenderingMutationHandler {

        public CaptionedRenderer() {
            super(Flow.INLINE);
        }

        /** Gwt renderer equivalent of {@link #createDomImpl(Renderable)} */
        @Override
        protected CaptionedImageWidget createGwtWidget(Renderable element) {
            return new CaptionedImageWidget();
        }

        @Override
        public void onActivatedSubtree(ContentElement element) {
            super.onActivatedSubtree(element);
            fanoutAttrs(element);
        }

        @Override
        public void onAttributeModified(
            ContentElement element, String name, String oldValue, String newValue) {
            super.onAttributeModified(element, name, oldValue, newValue);

                if (MyDoodad.REF_ATTR.equals(name)) {
                    getWidget(element).setImageSrc(newValue);
                }
        }

        /** Convenience getter */
        CaptionedImageWidget getWidget(ContentElement e) {
            return ((CaptionedImageWidget) getGwtWidget(e));
        }
    }

    static class GwtEventHandler extends ChunkyElementHandler {
        private final CaptionedRenderer renderer;

        GwtEventHandler(CaptionedRenderer renderer) {
            this.renderer = renderer;
        }

        @Override
        public void onActivated(final ContentElement element) {
            renderer.getWidget(element).setListener(new CaptionedImageWidget.Listener() {
                @Override public void onClickImage() {
                    MyDoodad.promptNewRef(element);
                }
            });
        }
    }

And update MyDoodad's register method:

.. code-block:: java

    public static void register(ElementHandlerRegistry registry) {
        CaptionedRenderer renderer = new CaptionedRenderer();
        registry.register(Renderer.class, TAGNAME, renderer);
        registry.register(NodeEventHandler.class, TAGNAME, new GwtEventHandler(renderer));
    }

Now reload and try it!

Supporting captions
-------------------
First, in MyDoodad, create a constant:

.. code-block:: java

    public static String CAPTION_TAGNAME = "mycaption";

And add the following to the end our schema definition (in TestModule):

.. code-block:: java

    // Permit our caption element to appear inside our doodad's main element
           // <mydoodad>
           //   <mycaption>text permitted here</mycaption>
           // </mydoodad>
           addChildren(MyDoodad.TAGNAME, MyDoodad.CAPTION_TAGNAME);
           containsBlipText(MyDoodad.CAPTION_TAGNAME);

This will allow us to add captions with editable text in them. If we try this now however, the caption won't show up.
There are two reasons: |br|
We haven't defined a renderer for our <mycaption> tag |br|
Even if we had, the rendering core wouldn't know where to put it. |br|

To address #1, we will use a paragraph renderer, using a div element for its HTML, to handle all the edit-ability
behaviours we need. Simply add this line to our register() method:

.. code-block:: java

    registry.register(Renderer.class, CAPTION_TAGNAME, ParagraphRenderer.create("div"));

We want our caption to be editable when we're in edit mode, and not editable when we're out of edit mode. Here's how
we do it:

.. code-block:: java

    /**
     * Event handler for our caption. Demonstrates two things:
     * 1. Subclassing LinoTextEventHandler, which provides sane behavior for,
     *    well, a line-of-text. (See its code for details)
     * 2. Use of utility to synchronise editability of caption region with main
     *    editor region.
     */
    static class CaptionEventHandler extends LinoTextEventHandler {
      @Override
      public void onActivated(ContentElement element) {
        super.onActivated(element);

        // Add a listener to edit mode changes.
        // We use an existing one that does exactly what we want: updates the editability
        // of our element's container as a result.
        DisplayEditModeHandler.setEditModeListener(element, UpdateContentEditable.get());
      }
    }

And don't forget:

.. code-block:: java

    registry.register(NodeEventHandler.class, CAPTION_TAGNAME, new CaptionEventHandler());

Now, address #2. Options:

* We can override methods like onChildAdded/onChildRemoved (not shown in this tutorial, but similar to onAttributeModified), and handle things explicitly by putting the caption child's HTML inside our caption container whenever the caption child shows up.
* For our use case, which is by far the most common, where we simply want the html rendering of our children to magically go into a container html nodelet, in the correct order, we can define a "container nodelet", like so: (add this method to CaptionedRenderer)

.. code-block:: java

    /**
     * Specify where the HTML DOM of child XML elements goes. Our widget's
     * getContainer() method returns the inner 'div' where we would like to put
     * the caption. We use this as the "container nodelet" so that when the
     * 'mycaption' element gets added to 'mydoodad' (in the model XML), the
     * caption's main 'div' nodelet automatically gets added to our doodad's
     * inner container nodelet (in the render HTML).
     *
     * So our DOM will end up looking like this:
     *
     * <pre>{@literal
     *
     * <div class='top'>           <!-- this is <mydoodad>'s top level "impl nodelet" -->
     *   <img src='...'/>          <!-- the image inside the tag -->
     *   <div class='container>    <!-- this is the container nodelet -->
     *
     *     <div>                   <!-- this is <mycaption>'s top level impl nodelet -->
     *       caption text
     *       <br/>                 <!-- This br gets inserted by the paragraph renderer
     *     </div>                       and is needed on some browsers. we don't have to
     *                                  worry about it, it's taken care of for us -->
     *   </div>
     * </div>
     *
     * }</pre>
     */
    @Override
    protected Element getContainerNodelet(Widget w) {
      return ((CaptionedImageWidget) w).getContainer();
    }

This takes care of all the hard work for us. It tells the rendering core to put the rendering of children into that
html node. (It's also possible to define a container nodelet for non-gwt renderers, too).

Ready to go. Refresh, and use the canned content with a caption in it. You should be able to type in the caption when
in edit mode, and not when the editor's toggle edit is off.

Finishing Touches
-----------------
We want to add some nice behavior where if the user hits a left-arrow key right after our doodad, it will place the
cursor in the caption if one exists, and skip over it if there is no caption. Similarly with a right arrow key coming
from the left, and being able to exit from the caption into the surrounding text. The default behavior doesn't do
this - it's not clear it would be desirable in the general case.

To do this, we add handlers for special editor events to move the selection the way we like:

.. code-block:: java

    static class CaptionedEventHandler extends GwtEventHandler {
      CaptionedEventHandler(CaptionedRenderer renderer) {
        super(renderer);
      }

      /**
       * Handles a left arrow that occurred with the caret immediately
       * after this node, by moving caret to end of caption
       */
      @Override
      public boolean handleLeftAfterNode(ContentElement element, EditorEvent event) {
        ContentElement caption = getCaption(element);

        if (caption != null) {
          // If we have a caption, move the selection into the caption
          element.getSelectionHelper().setCaret(
              Point.<ContentNode> end(getCaption(element)));
          return true;
        } else {
          // If we don't have a caption, use the default behavior
          return super.handleLeftAfterNode(element, event);
        }
      }

      /**
       * Similar to {@link #handleLeftAfterNode(ContentElement, EditorEvent)}
       */
      @Override
      public boolean handleRightBeforeNode(ContentElement element, EditorEvent event) {
        ContentElement caption = getCaption(element);

        if (caption != null) {
          // If we have a caption, move the selection into the caption
          element.getSelectionHelper().setCaret(
              Point.start(element.getRenderedContentView(), caption));
          return true;
        } else {
          // If we don't have a caption, use the default behavior
          return super.handleRightBeforeNode(element, event);
        }
      }

      /**
       * Handles a left arrow at the beginning of the caption, moving the
       * selection out of the whole doodad. We receive this event because the
       * caption doesn't handle it and it bubbles outwards to our handler here.
       */
      @Override
      public boolean handleLeftAtBeginning(ContentElement element, EditorEvent event) {
        // NOTE: The use of location mapper will normalise into text nodes.
        element.getSelectionHelper().setCaret(element.getLocationMapper().getLocation(
            Point.before(element.getRenderedContentView(), element)));
        return true;
      }

      /**
       * Similar to {@link #handleLeftAtBeginning(ContentElement, EditorEvent)}
       */
      @Override
      public boolean handleRightAtEnd(ContentElement element, EditorEvent event) {
        // NOTE: The use of location mapper will normalise into text nodes.
        element.getSelectionHelper().setCaret(element.getLocationMapper().getLocation(
            Point.after(element.getRenderedContentView(), element)));
        return true;
      }

      private ContentElement getCaption(ContentElement element) {
        return (ContentElement) element.getFirstChild();
      }
    }

Don't forget to update the register method, it should now look like this in its entirety:

.. code-block:: java

    public static void register(ElementHandlerRegistry registry) {
        CaptionedRenderer renderer = new CaptionedRenderer();

        registry.register(Renderer.class, TAGNAME, renderer);
        registry.register(NodeEventHandler.class, TAGNAME,
            new CaptionedEventHandler(renderer));

        registry.register(Renderer.class, CAPTION_TAGNAME,ParagraphRenderer.create("div"));
        registry.register(NodeEventHandler.class, CAPTION_TAGNAME,
            new CaptionEventHandler());
    }





.. |br| raw:: html

   <br />