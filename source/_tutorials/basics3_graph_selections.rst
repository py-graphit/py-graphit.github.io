
.. code:: ipython3

    import time
    import logging
    
    from graphit import Graph
    from graphit.graph_algorithms import node_neighbors
    
    logging.basicConfig(level=logging.WARN)

Tutorial 3: Working with graph selections
=========================================

Tutorial 2 demonstrated how to retrieve/query specific nodes and edges
from a graph. In **graphit** these node and edge selections are regarded
subgraphs of the parent graph they are selected from. In this tutorial
you will take a closer look at these subgraphs and the special
properties they have.

Subgraphs are ‘views’ on the main graph
---------------------------------------

The various node and edge query and selection tools that **graphit**
offers are powerfull in selecting subgraphs based on a wide range of
criteria. The subgraphs returned are not a copy but a ‘view’ on the data
in the main graph similar to dictionary views in Python. **graphit**
aims in using views as often as possible for graph operations.

Views are convenient because they are fast compared to making a full
copies and do not fragment the data. The latter means that data
modifications made in a ‘view’ effect the data stored in the *source*
graph only and are synchronized automatically in all other views on the
same data. The source or *origin* ``Graph`` representing the full node
and edge data set can always be obtained from any selection using the
``origin`` attribute.

1.1 Creating subgraphs
~~~~~~~~~~~~~~~~~~~~~~

Create a subgraph using ``getnodes`` or ``getedges`` by default returns
a ``Graph`` object with a view on the respective selection only. In both
cases this means a view on the nodes, the edges connecting them and
adjacency reflecting the neighbours of the nodes. Adjacency itself is
not a view as both keys (source nodes) and the values (list of
neighbouring nodes) will need to be adjusted to reflect the node and
edge selection.

.. code:: ipython3

    g = Graph()
    g.add_edges([(1, 2), (2, 4), (4, 5), (4, 6), (5, 7), (6, 8), (7, 9)], node_from_edge=True)
    
    # Making a node selection using getnodes
    nsub1 = g.getnodes([4,5,6])
    print(nsub1.nodes.keys())
    print(nsub1.edges.keys())
    print(nsub1.adjacency())
    
    # Nodes, edges and adjacency are 'views'
    print(nsub1.nodes.is_view, nsub1.edges.is_view)
    
    # Selecting nodes from another selection
    nsub2 = nsub1.getnodes([5,8])
    print(nsub2.nodes.keys())
    print(nsub2.edges.keys())
    print(nsub2.adjacency())
    
    # Selecting nodes that do not exist will not work
    nsub3 = nsub1.getnodes(8)

.. code:: ipython3

    # The source graph for the selections remains available
    print(nsub1.origin == g, nsub2.origin == g)
    
    # Data modifications in views are made on the parent data object and synchronized
    print(g.nodes[5])
    nsub1.nodes[5]['key'] = 15
    print(g.nodes[5], nsub2.nodes[5])

.. code:: ipython3

    # Making an edge selection using getedges works in the same way as getnodes
    esub1 = g.getedges([(2, 4), (4, 2), (4, 5), (5, 4), (4, 6)])
    print(esub1.nodes.keys())
    print(esub1.edges.keys())
    print(esub1.adjacency())

1.2 Subgraph connectivity
~~~~~~~~~~~~~~~~~~~~~~~~~

Subgraphs created using ``getnodes``, ``getedges`` or other selection
and query methods return ``Graph`` objects with a view on the given
selection. Although they seem to be isolated subgraphs they maintain
connectivity with the origin graph by default.

Connectivity behaviour is controlled using the ``Graph.masked``
attribute. False by default maintains connectivity with the origin graph
while set to False treats the selection as an isolated subgraph.

This is an important functionality as it for instance allows selection
of a node while still maintaining information on the environment it is
embedded in (like neighbours), ``masked`` set to true on the other hand
treats the subgraph as an isolated graph even if it is connected to or
embedded in a larger graph.

.. code:: ipython3

    # Get neighbours outside subgraph by default
    print(node_neighbors(g, 6))
    print(node_neighbors(nsub1, 6))
    
    # Set masked only considers the subgraph nodes as neighbours
    nsub1.masked = True
    print(node_neighbors(nsub1, 6))

1.3 Everything is a view
~~~~~~~~~~~~~~~~~~~~~~~~

**graphit** aims to use views as often as possible when operating on
graph selections originating from the same origin graph. Only when
operations will or are likely to return a graph with a distinct topology
not found in the input graphs will it return a new independant graph.


1.3 Copying graphs
~~~~~~~~~~~~~~~~~~

Moving from a graph with a ‘view’ on the origin graph to an independent
graph is handled by the ``Graph.copy`` method that returns a (deep)copy.

.. code:: ipython3

    cp = nsub1.copy()
    
    print(cp)
    print(cp.origin != nsub1.origin)
    print(cp.nodes.is_view, cp.edges.is_view, cp.adjacency.is_view)
    print(cp.nodes.keys())
