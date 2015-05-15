Apache Wave Documentation
--------------------------
The Apache Wave project is a stand alone wave server and rich web client
that serves as a Wave reference implementation.
Apache Wave site: http://incubator.apache.org/wave/
This project lets developers and enterprise users run wave servers and
host waves on their own hardware. And then share those waves with other
wave servers.

Here you will find (eventually) all the documentation on building, installing,
running, managing and contributing to Apache Wave.

In the meantime, please continue to use the existing documentation that can be
found on our [website](http://incubator.apache.org/wave), in the [wiki](https://cwiki.apache.org/confluence/display/WAVE/Home),
and at [Wave Protocol (old website)](http://www.waveprotocol.org).

Building the Documentation
--------------------------

You will need Python and Sphinx installed for HTML documentation.
If you would also like the PDF formats, you will need a LaTeX distribution installed as well.

On a Debian-based distribution, you can probably just run:
```
apt-get install texlive-latex-recommended texlive-latex-extra texlive-fonts-recommended
```

To build the actual documentation, you should run `make doc-html` or `make doc-pdf`, depending on which type you want.
To see all commands, please run `make help`.
