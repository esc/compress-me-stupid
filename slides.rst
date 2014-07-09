====================
Compress Me, Stupid!
====================

A historical Perpective
=======================


The memory Hierarchy
--------------------

* What is in it?

Blosc
-----

* It's the memory stupid!
* Starving CPUs
* What is it?
* What is 'blocking' in this context

where the rubber meets the road...
----------------------------------

From ``Objects/obmalloc.c``::

    /*
     * "Memory management is where the rubber meets the road --
     * if we do the wrong thing at any level, the results will
     * not be good. And if we don't make the levels work well
     * together, we are in serious trouble." (1)
     *
     * (1) Paul R. Wilson, Mark S. Johnstone, Michael Neely,
     * and David Boles, "Dynamic Storage Allocation:
     * A Survey and Critical Review", in Proc. 1995
     * Int'l. Workshop on Memory Management, September 1995.
     */

Blosc
=====

Shuffle Filter
--------------

* How does it work
* For what kind of datasets does it work well?
* For what kind of datasets does it not work?
* SSE2 instructions

Blosc is a Metacodec
--------------------

* Blosc does not actually compress anything

  * *Cutting* data into blocks
  * Application of filters
  * Management of threads

* Can use 'real' codecs under the hood.

OK, so whats under the hood?
----------------------------

* By default it uses **Blosclz** -- derived from **Fastlz**

* Alternative codecs

  * **LZ4 / LZ4HC**
  * **Snappy**
  * **Zlib**

Support for other codecs (LZO, LZF, QuickLZ, LZMA) possible, but needs to be
implemented.

Blosc + X
---------

So... using Blosc + X can yield higher compression ratios using the shuffle
filter and faster compression/decompression time using multithreading.

That's pretty neat!

Installation and Compilation
============================

Installation via Package -- PyPi/``pip``
----------------------------------------

Using ``pip`` (inside a virtualenv)::

    $ pip install blosc

Provided you have a ``C++`` (not just ``C``) compiler..

Installation via Package -- binstar/``conda``
---------------------------------------------

Using ``conda``::

    $ conda install -c https://conda.binstar.org/esc python-blosc

Experimental, Numpy 1.8 / Python 2.7 only..


Installation via Package -- gentoo/``emerge``
---------------------------------------------

Presumably::

    $ emerge python-blosc

I discovered this randomly while surfing the web.

Compilation / Packaging
-----------------------

Blosc is a metacodec

.. image:: blosc-deps.pdf
   :scale: 20%

Python-Blosc
------------

* How to use / API

* Bytes and Pointers

* How to install / compile

Other Projects that use Blosc
-----------------------------

* Bloscpack
* CArray / BLZ / bcolz
