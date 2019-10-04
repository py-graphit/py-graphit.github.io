
.. code:: ipython3

    from graphit import GraphAxis
    from graphit.graph_axis.graph_axis_mixin import NodeAxisTools
    from graphit.graph_io.io_jgf_format import read_jgf
    
    from orm_classes import Segid, Resid, Atom

Importing a graph
~~~~~~~~~~~~~~~~~

.. code:: ipython3

    g = read_jgf('files/axis_graph.jgf')
    g.node_tools = NodeAxisTools
    
    for n in g.iternodes():
        print(n)


.. parsed-literal::

    <GraphAxis "system" node object 4511256048, id 1: 1 nodes, 0 edges>
    <GraphAxis "residue" node object 4511256200, id 10: 1 nodes, 0 edges>
    <GraphAxis "atom" node object 4511256048, id 11: 1 nodes, 0 edges>
    <GraphAxis "atom" node object 4511256200, id 12: 1 nodes, 0 edges>
    <GraphAxis "atom" node object 4511256048, id 13: 1 nodes, 0 edges>
    <GraphAxis "atom" node object 4511256200, id 14: 1 nodes, 0 edges>
    <GraphAxis "atom" node object 4511256048, id 15: 1 nodes, 0 edges>
    <GraphAxis "atom" node object 4511256200, id 16: 1 nodes, 0 edges>
    <GraphAxis "atom" node object 4511256048, id 17: 1 nodes, 0 edges>
    <GraphAxis "atom" node object 4511256200, id 18: 1 nodes, 0 edges>
    <GraphAxis "atom" node object 4511256048, id 19: 1 nodes, 0 edges>
    <GraphAxis "segid" node object 4511256200, id 2: 1 nodes, 0 edges>
    <GraphAxis "segid" node object 4511256048, id 20: 1 nodes, 0 edges>
    <GraphAxis "residue" node object 4511256200, id 21: 1 nodes, 0 edges>
    <GraphAxis "atom" node object 4511256048, id 22: 1 nodes, 0 edges>
    <GraphAxis "atom" node object 4511256200, id 23: 1 nodes, 0 edges>
    <GraphAxis "atom" node object 4511256048, id 24: 1 nodes, 0 edges>
    <GraphAxis "atom" node object 4511256200, id 25: 1 nodes, 0 edges>
    <GraphAxis "atom" node object 4511256048, id 26: 1 nodes, 0 edges>
    <GraphAxis "atom" node object 4511256200, id 27: 1 nodes, 0 edges>
    <GraphAxis "residue" node object 4511256048, id 28: 1 nodes, 0 edges>
    <GraphAxis "atom" node object 4511256200, id 29: 1 nodes, 0 edges>
    <GraphAxis "residue" node object 4511256048, id 3: 1 nodes, 0 edges>
    <GraphAxis "atom" node object 4511256200, id 30: 1 nodes, 0 edges>
    <GraphAxis "atom" node object 4511256048, id 31: 1 nodes, 0 edges>
    <GraphAxis "atom" node object 4511256200, id 32: 1 nodes, 0 edges>
    <GraphAxis "atom" node object 4511256048, id 33: 1 nodes, 0 edges>
    <GraphAxis "atom" node object 4511256200, id 34: 1 nodes, 0 edges>
    <GraphAxis "atom" node object 4511256048, id 35: 1 nodes, 0 edges>
    <GraphAxis "atom" node object 4511256200, id 36: 1 nodes, 0 edges>
    <GraphAxis "atom" node object 4511256048, id 37: 1 nodes, 0 edges>
    <GraphAxis "atom" node object 4511256200, id 4: 1 nodes, 0 edges>
    <GraphAxis "atom" node object 4511256048, id 5: 1 nodes, 0 edges>
    <GraphAxis "atom" node object 4511256200, id 6: 1 nodes, 0 edges>
    <GraphAxis "atom" node object 4511256048, id 7: 1 nodes, 0 edges>
    <GraphAxis "atom" node object 4511256200, id 8: 1 nodes, 0 edges>
    <GraphAxis "atom" node object 4511256048, id 9: 1 nodes, 0 edges>


Working with axis
~~~~~~~~~~~~~~~~~

.. code:: ipython3

    # GraphAxis objects have a root
    print(g.root)
    
    root = g.get_root()

.. code:: ipython3

    # Traverse along axis with respect to root
    segid = g.getnodes(2)
    
    print(segid)
    print(segid.parent())
    print(segid.children().keys())
    print(segid.ancestors().keys())
    print(segid.descendants().keys())

.. code:: ipython3

    # Class magic methods
    
    for residue in segid:
        print(residue.name)
    
    for atom in segid.residue:
        print(atom.name, atom.elem, atom.value)
    
    print(atom.path())
    print(segid.residue.atom.name)

.. code:: ipython3

    # Basic XPath query support
    
    print(g.xpath('/system/segid/residue').keys())
    print(g.xpath('//atom').values())
    print(g.xpath('//residue[3]').keys('value'))
    print(g.xpath('//segid[@value="A"]/residue[@value=1]').keys('value'))
    print(g.xpath('//atom[@value>620]').values())

Working with the graph ORM
~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code:: ipython3

    g.orm.node_mapping.add(Segid, lambda x: x.get('key') == 'segid')
    g.orm.node_mapping.add(Resid, lambda x: x.get('key') == 'residue')
    g.orm.node_mapping.add(Atom, lambda x: x.get('key') == 'atom')
    
    for segid in root:
        print(segid.custom_print())
        for resid in segid:
            print(resid.custom_print())
            for atom in resid:
                print(atom.custom_print())

