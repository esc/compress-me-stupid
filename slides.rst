Compress Me Stupid
==================

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
     * "Memory management is where the rubber meets the road -- if we do the wrong
     * thing at any level, the results will not be good. And if we don't make the
     * levels work well together, we are in serious trouble." (1)
     *
     * (1) Paul R. Wilson, Mark S. Johnstone, Michael Neely, and David Boles,
     * "Dynamic Storage Allocation: A Survey and Critical Review",
     * in Proc. 1995 Int'l. Workshop on Memory Management, September 1995.
     */

Shuffle Filter
--------------

* How does it work
* For what kind of datasets does it work well?
* For what kind of datasets does it not work?
* SSE2 instructions

Python-Blosc
------------

* How to use / API

* Bytes and Pointers

* How to install / compile

Other Projects that use Blosc
-----------------------------

* Bloscpack
* CArray / BLZ / bcolz
