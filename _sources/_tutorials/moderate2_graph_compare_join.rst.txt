
.. code:: ipython3

    import time
    import logging
    
    from graphit import Graph
    from graphit.graph_combinatorial.graph_setlike_operations import *
    
    logging.basicConfig(level=logging.WARN)

.. code:: ipython3

    # Build tutorial graph
    
    graph1 = Graph(auto_nid=False)
    graph1.add_nodes(range(1, 11), graph='one')
    graph1.add_edges([(1, 2), (2, 3), (3, 4), (3, 5), (5, 6), (4, 7), (6, 8), (7, 8), (8, 9), (9, 10)])
    
    graph2 = Graph(auto_nid=False)
    graph2.add_nodes(range(6, 16), graph='two')
    graph2.add_edges([(6, 8), (7, 8), (8, 9), (9, 10), (10, 11), (10, 12), (12, 13), (11, 14), (13, 15), (14, 15)])
    
    print('Tutorial example graphs 1 and 2:', graph1, graph2)

Tutorial 5: Compairing, mergin and appending graphs
===================================================

In this tutorial you will take a closer look at **graphit** function for
operations on multiple grpahs such as compairing two graphs, joining or
merging them.

5.1 Compairing subgraphs
~~~~~~~~~~~~~~~~~~~~~~~~

**graphit** offers a number of
`set-like <https://docs.python.org/3/library/stdtypes.html#set-types-set-frozenset>`__
comparison methods to compare subgraphs based on topology defined by
node IDs and edges. This means that the graphs at least need to share
nodes with the same ID or derived from a common ancestor (origin graph).

These functions aim to return a view-based result graph whenever
possible. The principles and benefits of ‘views’ are discussed in more
detail in the the moderate1_graph_orm.ipynb tutorial. If returning a
view is not possible a new (deep copy) will be returned.

Note: These functions do not update node and/or edge attributes in the
resulting graph as might be required in for instance a union or
intersection operation.

.. code:: ipython3

    print('intersection: {0}'.format(graph_intersection(graph1, graph2)))
    print('difference: {0}'.format(graph_difference(graph1, graph2)))
    print('symmetric_difference: {0}'.format(graph_symmetric_difference(graph1, graph2)))
    print('union: {0}'.format(graph_union(graph1, graph2)))
    
    print('\nissubset: {0}'.format(graph_issubset(graph1.getnodes([3, 4, 5]), graph1)))
    print('issuperset: {0}'.format(graph_issuperset(graph1, graph_union(graph1, graph2))))

The set-like operations demonstrated above are also used in ``Graph``
magic methods where they are often combined with attribute update
functions to for instance return a true union between two graphs.

.. code:: ipython3

    # Graph addition, attributes of first updated with second
    new = graph1 + graph2
    print(new.items('_id', 'graph'))
    
    # Is graph 1 contained in the previous graph
    print('Graph 1 contained in new:', graph1 in new)
    print('Graph 1 not contained in graph 2:', graph1 in graph2)
    
    # Equality
    print('Graph 1 does not equal graph 2:', graph1 == graph2)
    print('A copy of graph 1 equals graph 1:', graph1.copy() == graph1)
    
    # Logical less-then/greater-then
    print(graph1 <= new)

