
.. code:: ipython3

    import time
    import logging
    
    from graphit import Graph
    
    logging.basicConfig(level=logging.WARN)

.. code:: ipython3

    # Build tutorial graph
    g = Graph()
    g.add_nodes('GRAPH', data='word')
    g.add_edges([(1, 2), (2, 3), (2, 4), (4, 5)], label='link')
    
    g.auto_nid = False
    g.add_node('final', label='yellow')
    g.add_edge(4, 'final')
    
    print('Tutorial example graph:', g)

Tutorial 2: Working with nodes and edges
========================================

After the first tutorial you should be familiar with building graphs
**graphit**. In this tutorial you will learn about ``Graph`` class
methods that allow you to retrieve specific nodes and edges from a graph
based on their ID or query for them based on the attributes they
contain. In addition this tutorial discussed how to best work with the
data that is stored as node and edge attributes.

Retrieving or query for specific nodes and edges always returns a new
``Graph`` object with the nodes and edges represented as a subgraph. The
next tutorial (3) will explain subgraphs and their properties in more
detail.

2.1 Getting nodes and edges from a graph using their ID
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The primary method for retrieving nodes and edges based on their ID
(nid, eid) is ``getnodes`` and ``getedges`` respectivly. Nearly all
other class methods including magic methods that query for nodes and
edges based on ID use ``getnodes`` and ``getedges`` internally.

.. code:: ipython3

    # Get single or multiple nodes
    print(g.getnodes(2))
    print(g.getnodes((2, 4, 5)))
    
    # Equivalent for edges
    print(g.getedges((2, 3)))
    print(g.getedges([(2, 3), (2, 4)]))

.. code:: ipython3

    # `getnodes` and `getedges` are also used in Graph magic methods such as dictionary like 'key' access 
    # using the __getitem__ magic method.
    print(g[2])
    print(g['final'])
    print(g[(2, 3)])
    
    # __getitem__ also accepts a 'slice' object for integer based node IDs
    print(g[1:3])

**Iterating over nodes and edges**

Iterate over nodes and edges using the ``iternodes`` and ``iteredges``
methods respectivly. ``iternodes`` is also used in the default ``Graph``
class iterator (*__iter__\* class method).

Both methods sort the node and edge ID’s before iteration using Pythons
build in ``sorted`` function. Sorting behaviour can be modified using
the ``reverse`` and ``sort_key`` arguments to respectivly reverse the
sorting order or use a different key-based sorting function. More
information about this functionality is available as part of the
``sorted``
`documentation <https://docs.python.org/3/howto/sorting.html>`__.

.. code:: ipython3

    for node in g.iternodes():
        print(node)
    
    for node in g:
        print(node)
    
    for edge in g.iteredges():
        print(edge)

**Query a graph for nodes and edges**

Retrieving specific nodes and edges based on their attributes is
possible using the ``query_nodes`` and ``query_edges`` methods.

.. code:: ipython3

    print(g.query_nodes(key='P'))
    print(g.query_nodes(attr='word'))
    
    print(g.query_edges(label='link'))

2.2 Working with node and edge data stores
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Node and edge data (attributes) are stored in a dictionary-like fasion
as explained in tutorial 1. The ``DictStorage`` class handling storage
has an API mimicking that of the familiar Python ``dict`` class. The
node or edge ID is the primary key and the attributes as value stored as
additional dictionary as explained by technical node 1 in the first
tutorial.

Attributes can thus be accessed and updated using a familiar dict-like
API as demonstrated for nodes below. However, there is good reason to
use the dedicated API methods for that are a part of the ``Graph``
class. More on that later on in this tutorial.

**Working with node and edge IDs**

Pythons `dictionary
methods <https://docs.python.org/3/library/stdtypes.html#dict>`__
supported by ``DictStorage`` provide a fast and easy means of inspecting
the nodes and edges in graph or subgraph.

.. code:: ipython3

    node = g['final']
    print('current node ID:', node.nid)
    
    print(node.nodes())
    print(node.nodes.keys())
    print(node.nodes.values())
    print(node.nodes.items())
    print(len(node.nodes))

In additon, the ``DictStorage`` class provides `set-like
comparison <https://docs.python.org/3/library/stdtypes.html#set-types-set-frozenset>`__
methods to directly compare nodes or edges from two subgraphs in a
number of ways.

.. code:: ipython3

    sel1 = g.getnodes([1, 2, 3])
    sel2 = g.getnodes([3, 4, 5])
    
    print('difference: {0}'.format(sel1.nodes.difference(sel2.nodes)))
    print('intersection: {0}'.format(sel1.nodes.intersection(sel2.nodes)))
    print('union: {0}'.format(sel1.nodes.union(sel2.nodes)))
    print('symmetric_difference: {0}'.format(sel1.nodes.symmetric_difference(sel2.nodes)))
    
    print('\nissubset: {0}'.format(sel1.nodes.issubset(g.nodes)))
    print('issuperset: {0}'.format(sel1.nodes.issuperset(g.nodes)))
    print('isdisjoint: {0}'.format(sel1.nodes.isdisjoint(sel2.nodes)))

**Important note 2: Be carefull with editing on ``DictStorage`` objects
directly**

With the familiarity of the dict-like API it may be tempting to edit
node and edge ID’s (primary keys) directly using the respective node and
edge ``DictStorage`` objects, one could even add or remove nodes and
edges this way. It is however strongly advised NOT to do this as it can
leave the graph in a funny state. Use the dedicated method to add or
remove nodes and edges instead.

**Working with node and edge attributes**

Node and edge attribute stores are also dict-like objects and thus share
the same API. Use the node or edge ID to access the attribute store
followed by the familiar dict-like API to edit the data.

.. code:: ipython3

    # Add new data attribute and set its value using __setitem__ method
    node.nodes[node.nid]['extra'] = 4.33
    
    # Retrieve attributes using __getitem__ or get methods
    print(node.nodes[node.nid]['extra'])
    print(node.nodes[node.nid].get('extra', None))
    
    # Update attributes from other dictionary
    node.nodes[node.nid].update({'update': True, 'extra': 3.44})
    
    print(node.nodes[node.nid])

**Using the dedicated node and edge data API**

Although the node and edge data can be directly and conveniently
modified as shown above, there is a dedicated API available for this.
Every single node or edge Graph has additional method added to it (using
the ORM further explained in the moderate1_graph_orm.ipynb tutorial) for
convenient attribute access.

The benefit of this API is that custom ``Graph`` classes (using the ORM)
can overload the methods changing the behaviour of attribute access. An
example application would be the pre- or post-processing of the data.

.. code:: ipython3

    node = g['final']
    
    # Dictionary 'get' and 'set' are the core methods
    print(node.get('label', default=None))
    node.set('set', [1,2,3])
    
    # Direct attribute or item based access
    print(node.label)
    print(node['label'])
    
    # Including attribute or item setters
    node.label = 'green'
    node['extra'] = 'red'
    
    # Magic methods and other methods
    node.update({'first': 1, 'second': 2})
    print('extra' in node, 'void' in node)
    
    print(node.nodes())
