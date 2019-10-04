
.. code:: ipython3

    import time
    import logging
    
    from graphit import Graph
    from graphit.graph_helpers import graph_directionality
    
    logging.basicConfig(level=logging.WARN)

Tutorial 1: Building simple graphs
==================================

This is the first tutorial in a series illustrating the basics of using
graphs in **graphit**. We start off by building a simple graph by adding
nodes and edges and later on removing them again.

A Graph is a container with nodes and edges
-------------------------------------------

A graph is a collection of nodes (vertices) connected using edges. In
**graphit**, nodes and edges are contained in a ``Graph`` object and
they can represent any arbitrary piece of data as long as they are
hashable such as: text, numbers, images, files or even Python functions
or other objects.

The functionality for adding nodes and edges to a ``Graph`` is similar
to most other graph packages including the popular Python library
`NetworkX <https://networkx.github.io>`__ as is illustrated below.

1.1 Creating a graph
~~~~~~~~~~~~~~~~~~~~

Create an empty ``Graph`` with no nodes and no edges.

.. code:: ipython3

    g = Graph()
    
    print(g)
    print(g.nodes, g.edges)


.. parsed-literal::

    <GraphBase object 4422259192: 0 nodes, 0 edges>
    [] []


**Technical note 1: Node and edge storage**

**graphit** uses flexible storage drivers to store node and edge
information. The default driver stores information as a Python
dictionary but this may well be a driver that stores information in a
high-performance data store. The storage driver API enforces key/value
storage in which the node identifier (nid) is the primary key and the
node attribute dictionary the value. A graph natively supports the
storage of multiple node attributes and therefor most node related
functions expect a node value to behave in a Python dictionary like
fashion.

1.2 Adding nodes
~~~~~~~~~~~~~~~~

Use the graph ``add_node`` method to add a single node to the graph or
``add_nodes`` for multiple nodes at once. Both methods return the unique
node identifier(s) for the node(s) just added to the graph.
``add_nodes`` accepts any iterable object as a source of nodes.

.. code:: ipython3

    # Add a single node
    nid = g.add_node('node')
    print(nid, g)
    
    # Adding multiple nodes at once
    nids = g.add_nodes([1, 2, 'three'])
    print(nids, g)
    
    # using a string as iterable source of characters
    g.add_nodes('graphit')
    print(g)


.. parsed-literal::

    1 <GraphBase object 4422259192: 1 nodes, 0 edges>
    [2, 3, 4] <GraphBase object 4422259192: 4 nodes, 0 edges>
    <GraphBase object 4422259192: 11 nodes, 0 edges>


**Important note 1: Node identifiers**

Every node added to the graph is stored allong with a node identifier
(nid) that can be used to retrieve the node at a later time. The
``Graph`` class supports two methods to define node ID’s:

1. An automatically incremented integer identifier enabled by default
   using the ``Graph.auto_nid`` attribute (set to True).
2. Using the node key (first argument to ``add_node`` as identifier
   enabled by setting the ``Graph.auto_nid`` to False.

The benefit of the first option is unique identification of every node
added even if the primary node key already exists. It will require the
user to keep track of the unique ID’s assigned to the nodes or querying
for a node using attribute based query methods.

These requirements are not needed with the second option. Here the node
key serves as the identifier (nid) and may be any hashable object except
``None``. A unique auto incremented ID (as with option 1) will still be
added to the node attribute storage but it will not be used for
identfication. The downside of method 2 is that the node key used may
not be unique in case of which the ``add_node(s)`` will complain not
adding the new node.

.. code:: ipython3

    # Using the node key as identifier
    a = Graph(auto_nid=False)
    nids = a.add_nodes(['node', 'node2'], node_attr=100)
    print(nids)
    print(a.nodes['node'])
    print(a.nodes.keys())
    
    # Adding the same node again will not work
    nid = a.add_node('node', node_attr=100)


.. parsed-literal::

    WARNING:graphit:Node with identifier "node" already assigned


.. parsed-literal::

    ['node', 'node2']
    {'key': 'node', 'node_attr': 100, '_id': 1}
    ['node', 'node2']


1.3 Adding data to nodes
~~~~~~~~~~~~~~~~~~~~~~~~

Any additional key/value pair used as input to the ``add_node`` or
``add_nodes`` method will be added to the node storage

.. code:: ipython3

    nid = g.add_node('node', node_attr=100, value=int(time.time()))
    g.nodes[nid]




.. parsed-literal::

    {'key': 'node', 'node_attr': 100, 'value': 1570207050, '_id': 12}



The node/edge storage exposes a dictionary like API (technical note 1).
For node with ID 14, it show the added data as dictionary key/value
pairs. The auto incremented node ID is stored as ’_id’ and the node key
as ‘key’

.. code:: ipython3

    nids = g.add_nodes(['data', 1.22, True, len], node_attr=100, value=int(time.time()))
    for nid in nids:
        print(g.nodes[nid])


.. parsed-literal::

    {'key': 'data', 'node_attr': 100, 'value': 1570207050, '_id': 13}
    {'key': 1.22, 'node_attr': 100, 'value': 1570207050, '_id': 14}
    {'key': True, 'node_attr': 100, 'value': 1570207050, '_id': 15}
    {'key': <built-in function len>, 'node_attr': 100, 'value': 1570207050, '_id': 16}


With ``add_nodes`` additional keyword arguments will be added to all
nodes added from the iterable. If the iterable contains a tuple or list
of length 2 with a dictionary at the second position, the key/value
pairs of that dictionary will be used as attributes in the new node
together with addtional keyword arguments to ``add_nodes`` if defined.
This functionality can be used for adding the nodes of one graph as new
nodes to another as illustrated below.

.. code:: ipython3

    # Build the first graph
    b = Graph()
    b.add_nodes('second', attr=True)
    
    # Add nodes of graph b to g
    nids = g.add_nodes(b.nodes.items())
    for nid in nids:
        print(g.nodes[nid])


.. parsed-literal::

    {'key': 's', 'attr': True, '_id': 17}
    {'key': 'e', 'attr': True, '_id': 18}
    {'key': 'c', 'attr': True, '_id': 19}
    {'key': 'o', 'attr': True, '_id': 20}
    {'key': 'n', 'attr': True, '_id': 21}
    {'key': 'd', 'attr': True, '_id': 22}


Now graph *g* contains the nodes of graph *b* as new nodes.
Alternativly, you could use the full graph *b* as node in *g*:

.. code:: ipython3

    nid = g.add_node(b)
    print(g.nodes[nid])


.. parsed-literal::

    {'key': <GraphBase object 4420139048: 6 nodes, 0 edges>, '_id': 23}


**Technical note 2: unicode support**

**graphit** commits to the use of unicode strings as much as possible
both in python 2.x and 3.x. All data keys and values that are strings
are stored in unicode. When using data collections as value such as
lists, dictionaries or tuples, the user is responsible for ensuring
unicode complience. In python 3.x all strings are unicode by default.

1.4 Adding edges
~~~~~~~~~~~~~~~~

Adding edges is in general anologous to adding nodes by using the
``add_edge`` and ``add_edges`` methods. The difference is that both
methods require as argument two node identifiers that form the edge. The
identifiers are either two automatically generated unique ID’s or custom
ones (see important node 1).

**Graph directionality**

An edge between two nodes can be un-directional (edge points both ways)
or directional (edge only points one way). Global directionality of a
graph is set using ``graph.directed`` attribute which is False by
default yielding an un-directional graph. Global directionality can be
overruled in ``add_edge(s)`` allowing for mixed graphs.

.. code:: ipython3

    # Adding an edge in an un-directed graph
    eid = g.add_edge(1, 2, edge_attr='text')
    
    print(eid)
    print(g, g.directed)
    print(g.edges())
    print(graph_directionality(g))


.. parsed-literal::

    (1, 2)
    <GraphBase object 4422259192: 23 nodes, 2 edges> False
    {(1, 2): {'edge_attr': 'text'}, (2, 1): {'edge_attr': 'text'}}
    undirectional


.. code:: ipython3

    # Add directed edge.
    eid = g.add_edge(2, 3, directed=True)
    
    print(g.edges())
    print(graph_directionality(g))


.. parsed-literal::

    {(1, 2): {'edge_attr': 'text'}, (2, 1): {'edge_attr': 'text'}, (2, 3): {}}
    mixed


.. code:: ipython3

    # Add multiple edges at once
    eids = g.add_edges([(2, 4), (4, 5), (4, 6), (5, 7), (6, 8), (7, 9)], global_attr=True)
    eids += g.add_edges([(8, 9, {'attr': 100}), (9, 10), (10, 11, {'text': False}), (10, 12), (10, 13)], global_attr=True)
    
    print(g)
    for eid in eids:
        print(g.edges[eid])
        
    # Adding the same edge again will not work
    g.add_edge(2, 4)


.. parsed-literal::

    WARNING:graphit:Edge between nodes 2-4 exists. Use edge update to change attributes.
    WARNING:graphit:Edge between nodes 4-2 exists. Use edge update to change attributes.


.. parsed-literal::

    <GraphBase object 4422259192: 23 nodes, 25 edges>
    {'global_attr': True}
    {'global_attr': True}
    {'global_attr': True}
    {'global_attr': True}
    {'global_attr': True}
    {'global_attr': True}
    {'attr': 100, 'global_attr': True}
    {'global_attr': True}
    {'text': False, 'global_attr': True}
    {'global_attr': True}
    {'global_attr': True}




.. parsed-literal::

    (2, 4)



The ``add_edge(s)`` method supports a shortcut for fast graph creation
by adding nodes based on edge identifiers using the ``node_from_edge``
argument

.. code:: ipython3

    c = Graph()
    c.add_edges([(1, 2), (2, 4), (4, 5), (4, 6), (5, 7), (6, 8), (7, 9)], node_from_edge=True)
    
    print(c)


.. parsed-literal::

    <GraphBase object 4422743816: 8 nodes, 14 edges>


1.5 Removing nodes and edges
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

It may not come as a surprise but removing nodes and edges is
accomplished using similar methods as adding them namely:
``remove_node``, ``remove_nodes``, ``remove_edge`` and ``remove_edges``.

Removing nodes will also remove edges depending on it and adjust node
adjacency. Removing edges will not remove associated nodes but will
adjust adjacency. The ``graph.directed`` attribute controlling graph
directionality when adding edges also affects the removal of them. When
``remove_edge(s)`` is called with the ``directed=True`` argument on an
un-directed graph then only one edge of the pair of edges is removed
otherwise both edges will be removed.

.. code:: ipython3

    # Removing a single node
    g.remove_node(4)
    
    # Node 4 no longer in adjacency
    print(4 in g.adjacency)
    
    # Node more edges with node 4
    print([edge for edge in g.edges if 4 in edge])


.. parsed-literal::

    False
    []


.. code:: ipython3

    print(g)
    
    # Removing multiple nodes
    g.remove_nodes([1,2,3,5])
    print(g)


.. parsed-literal::

    <GraphBase object 4422259192: 22 nodes, 19 edges>
    <GraphBase object 4422259192: 18 nodes, 14 edges>


.. code:: ipython3

    # Removing edges works in a similar way
    g.remove_edge(6, 8)
    
    print(g.getnodes([6, 8]))  # Nodes are still there
    print(8 in g.adjacency[6]) # Adjacency is adjusted


.. parsed-literal::

    <GraphBase object 4422640296: 2 nodes, 0 edges>
    False


.. code:: ipython3

    print(g)
    
    # Removing multiple edges
    g.remove_edges([(9, 7), (11, 10), (9, 8)])
    
    print(g)


.. parsed-literal::

    <GraphBase object 4422259192: 18 nodes, 12 edges>
    <GraphBase object 4422259192: 18 nodes, 6 edges>


Removing all nodes and edges from a graph has a shortcut ``clear``
method.

.. code:: ipython3

    g.clear()
    print(g)


.. parsed-literal::

    WARNING:root:(10, 9) defines a reference ($ref) to non-existing (9, 10)
    WARNING:root:(12, 10) defines a reference ($ref) to non-existing (10, 12)
    WARNING:root:(13, 10) defines a reference ($ref) to non-existing (10, 13)


.. parsed-literal::

    <GraphBase object 4422259192: 0 nodes, 0 edges>

