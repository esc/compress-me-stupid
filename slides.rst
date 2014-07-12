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

Blosc is a Metacodec
--------------------

* Blosc does not actually compress anything

  * *Cutting* data into blocks
  * Application of filters
  * Management of threads

* Can use 'real' codecs under the hood.
* Filters and codecs are applied to each block
* Thread-level parallelism on blocks

Shuffle Filter
--------------

* Reorganization of bytes within a block
* Reorder by byte significance

.. image:: shuffle.pdf

Shuffle Filter Example -- Setup
-------------------------------

Imagine we have the following array as ``uint64`` (8 byte, unsigned integer)::

    [0, 1, 2, 3]

Reinterpret this as ``uint8``::

    [0, 0, 0, 0, 0, 0, 0, 0,
     1, 0, 0, 0, 0, 0, 0, 0,
     2, 0, 0, 0, 0, 0, 0, 0,
     3, 0, 0, 0, 0, 0, 0, 0]

Shuffle Filter Example -- Application
-------------------------------------

What the shuffle filter does is::

    [0, 1, 2, 3, 0, 0, 0, 0,
     0, 0, 0, 0, 0, 0, 0, 0,
     0, 0, 0, 0, 0, 0, 0, 0,
     0, 0, 0, 0, 0, 0, 0, 0]

Which, reinterpreted as ``uint64`` is::

    [50462976,        0,        0,        0]

Shuffle Filter Benefits
-----------------------

* Works well for multibyte data with small differences

  * e.g. Timeseries

* Exploit similarity between elements
* Lump together bytes that are alike
* Create longer streams of similar bytes
* Better for compression

* Shuffle filter implemented using SSE2 instructions

Shuffle Fail
------------

It does not work well on all datasets, observe::

    [18446744073709551615, 0, 0, 0]

Or, as ``uint8``::

    [255, 255, 255, 255, 255, 255, 255, 255,
     0,   0,   0,   0,   0,   0,   0,   0,
     0,   0,   0,   0,   0,   0,   0,   0,
     0,   0,   0,   0,   0,   0,   0,   0]

Shuffle Fail in action
----------------------

When shuffled yields::

    [1095216660735, 1095216660735, 
     1095216660735, 1095216660735]

Or, as ``uint8``::

    [255,   0,   0,   0, 255,   0,   0,   0,
     255,   0,   0,   0, 255,   0,   0,   0,
     255,   0,   0,   0, 255,   0,   0,   0,
     255,   0,   0,   0, 255,   0,   0,   0]


OK, so what else is  *under the hood*?
--------------------------------------

* By default it uses **Blosclz** -- derived from **Fastlz**

* Alternative codecs

  * **LZ4 / LZ4HC**
  * **Snappy**
  * **Zlib**

Support for other codecs (LZO, LZF, QuickLZ, LZMA) possible, but needs to be
implemented.

Blosc + X
---------

So... using Blosc + X can yield **higher compression ratios** using the shuffle
filter and **faster compression/decompression** time using multithreading.

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
============

Python API
----------

* It's a codec, so naturally we have a ``compress/decompress`` pair

* Can operate on byte strings or pointers (encoded as integers)

  * ``compress`` vs. ``compress_ptr``

* Tutorials: http://python-blosc.blosc.org/tutorial.html

* API documentation: http://python-blosc.blosc.org/

Example -- Compress
-------------------

.. code-block:: pycon

    >>> import numpy as np
    >>> import blosc
    >>> import zlib

.. code-block:: pycon

    >>> bytes_array = np.linspace(0, 100, 1e7).tostring()

.. code-block:: pycon

    >>> %timeit bpacked = blosc.compress(bytes_array,
    ...                                  typesize=8)
    10 loops, best of 3: 36.2 ms per loop

.. code-block:: pycon

    >>> %timeit zpacked = zlib.compress(bytes_array)
    1 loops, best of 3: 5.72 s per loop

Example -- Ratio
----------------

.. code-block:: pycon

    >>> bpacked = blosc.compress(bytes_array,
    ...                          typesize=8)
    >>> zpacked = zlib.compress(bytes_array)
    >>> len(zpacked) / len(bpacked)
    6.9354286183922955

Example -- Decompress
---------------------

.. code-block:: pycon

   >>> %timeit bupacked = blosc.decompress(bpacked)
   10 loops, best of 3: 31.8 ms per loop

.. code-block:: pycon

   >>> %timeit zupacked = zlib.compress(zpacked)
   1 loops, best of 3: 398 ms per loop

Example -- Demystified
----------------------

* Blosc works really well for the ``linspace`` dataset
* Shuffle filter and multithreading bring benefits

.. code-block:: pycon

    >>> blosc.set_nthreads(1)
    >>> %timeit bpacked = blosc.compress(bytes_array,
    ...                                  typesize=8,
    ...                                  shuffle=False)
    1 loops, best of 3: 315 ms per loop

.. code-block:: pycon

    >>> bpacked = blosc.compress(bytes_array,
    ...                          typesize=8,
    ...                          shuffle=False)
    >>> len(zpacked) / len(bpacked)
    0.713310695878436


Other Projects that use Blosc
-----------------------------

* Bloscpack
* CArray / BLZ / bcolz
