Graphit
=======

Graphit is a graph based data modeling library written in Python. It combines three powerful
concepts into one easy to use package:

 - Graph based data representation similar to the well known
   `NetworkX <https://networkx.github.io>`_ library.
 - A Python Object Relation Mapper (ORN).
 - A Python native API. If you know Python you know Graphit.

Why Graphit?
------------

The data that we work in Python can often be represented as a graph-(like) structure.
Different pieces of data (nodes) have a relationship with one another (edges). Frequently, these
relationships have a common origin, the data structure is know to be hierarchical or nested.
Examples are Python dictionaries, JSON files or XML documents. Many native graph formats (GEXF, GML, LGF)
on the other hand do not have a (predefined) common origin but are still a graph.

Graphit imports data structures and represents them as graphs using a Python native API that is packed
with a rich set of graph iteration, query and analysis tools. Graphit supports all Python native data types
and many industry standards out of the box (e.a. JSON, YAML, XML, GEXF, DOT an many more).
The simple graph construction API will quickly enable you to write new data importers/exporters for formats
not yet supported by Graphit.

Now the fun really starts! When you work with data in a Graphit graph, the data is always represented as a
node or edge object or subgraph representing multiple nodes/edges. These objects mimick as much as possible
common Python data types that you are accustomed to work with. Python class magic methods all work, just as
methods such as `keys`, `values` and `items` for instance. The best is yet to come, these objects are **on the
fly customizable** using the Graphit ORN. Using the ORN you can mixin custom classes and functions based on
the active state of the data creating a dynamic data model. That is allot of power with only a few lines of
code!

Sounds great, show me something
-------------------------------

The `examples` section contains a few notebooks with a quick start on using the graph API and more advanced
usage of data importers/exporters and the ORN. You can get your hands dirty right away using the live Jupyter
Notebook service offered by the *Binder service* on the py-graphit GitHub page.


.. toctree::
   :maxdepth: 1

   installation
   graphit API reference <graphit>
   tutorials

License
-------

Graphit is licensed under the Apache License v2.0.


* :ref:`genindex`
* :ref:`modindex`
