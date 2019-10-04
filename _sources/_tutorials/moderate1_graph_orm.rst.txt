
.. code:: ipython3

    import logging
    
    from graphit import Graph
    
    logging.basicConfig(level=logging.WARN)

The graph Object Relation Mapper
--------------------------------

Graph libraries are first and foremost a database with node, edge and
optional adjacency information. The libraries application programming
interface (API) provides the methods to build, edit and query the stored
graph data. For libraries written in an object oriented language (such
as graphit in Python) the API is an object but also the nodes and edges
it returns are often objects. These may be basic data structure such as
dictionaries in the case of the
`networkX <http://www.networkx.github.io>`__ library of more elaborate
custom classes.

In graphit every object representing a full graph, a subgraph or even
single node or edge is itself derived from the Graph class. These
objects always represent a ``view`` on the nodes and edges in the main
storage class (initial Graph object initiated) for efficiency and
concurancy. The abbility to always interact with the same consistent API
regardless of the graph state is an attractive benefit of the library.
But graphit goes one step further by dynamically building the Graph
objects and allowing the user to add or change the objects methods
through the use of an Object Relation Mapper (ORM).

The ORM allows a user to map a custom class together with a matching
function that will be evaluated against node or edge data every time a
node or edge query is performed. All the custom classes associated to
positive matches are used in building a new Graph or GraphAxis class.
This design strategy provides a powerfull means to have fine grained
control over the graph behaviour and the functionality of the returned
Graph object. This turns an already feature rich graph library into a
dynamic data modelling library, a combination unique to graphit.

Using the ORM
~~~~~~~~~~~~~

Every new graph automatically initiates an instance of the GraphORM
class. Graph objects returned by querying the “parent” graph will have a
weak reference to the GraphORM class similar as to the nodes and edges
storage objects.

Let’s have a look at the capabilities of the ORM by building a simple
example graph:

.. code:: ipython3

    graph = Graph()
    graph.add_edges([(1, 2), (2, 3), (2, 4), (3, 5), (3, 6), (4, 6), (6, 7), (7, 8), (7, 9)], node_from_edge=True)
    
    print(graph)
    print(graph.orm)

The ``orm`` object has no registered node or edge mappings yet. Let’s
register a custom class to a node

.. code:: ipython3

    class CustomNodeClass(object):
        
        def magic(self):
            print('Hello from {0}'.format(self.nid))
    
    graph.orm.node_mapping.add(CustomNodeClass, lambda x: x.get('_id') == 3)
    print(graph.orm)

In using ``node_mapping.add``, the ``CustomNodeClass`` class is
registered and will be mapped when the lambda function evaluates to
True. The second argument can be any function as long as it accepts a
dictionary as the only argument. That plain Python dictionary contains
the node attributes or edge attributes in the equivalent
``edge_mapping.add`` function.

Note that it is highly recommended to use the dictionary ``get`` method
to avoid raising a KeyError when the key is not defined which is likely
to happen.

Now, fetching node 3 will return a Graph object with the added ``magic``
method while a call node 5 for instance will not have that method.

.. code:: ipython3

    node3 = graph.getnodes(3)
    
    print(hasattr(node3, 'magic'))
    node3.magic()
    
    print(hasattr(graph.getnodes(5), 'magic'))

**Class inheritance**

In the example above, node 3 has the ``magic`` method as we defined
while node 5 does not. However, if we fetch node 5 from the node 3 graph
object it inherits node3 methods and that includes the ``magic`` method.
This is controlled by the ``inherit`` argument of the GraphORM class
that defaults to True. When disabled, each newly created Graph object
only consists of the Graph base class and the custom classes resolved
for the particular call to the ORM.

.. code:: ipython3

    node3.getnodes(5).magic()
    
    # Disable ORM inheritance
    graph.orm.inherit = False
    print(hasattr(node3.getnodes(5), 'magic'))
