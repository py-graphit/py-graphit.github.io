.. _tutorials:

Tutorials
=========

This page provides a series of examples, tutorials and recipes as Jupyter
notebooks to help you get started using Graphit.

Reading them online is helpful but it does not replace getting your hands
dirty with live code. You can work with the *live* version of the Jupyter
Notebook using the *Binder service* with the link below.

.. image:: https://mybinder.org/badge_logo.svg
  :target: https://mybinder.org/v2/gh/py-graphit/py-graphit.github.io/master?filepath=examples

The source code of the notebooks is available on Graphit GitHub repository
in the `examples <https://github.com/py-graphit/py-graphit.github.io/tree/master/examples>`_
folder. In the directory with the notebook files, start an IPython notebook server:

.. code:: bash

   $ jupyter notebook


Tutorial notebooks
------------------

.. toctree::
   :maxdepth: 1

   Building a graph <_tutorials/basics1_building_graphs>
   Working with nodes and edges <_tutorials/basics2_nodes_and_edges>
   Graph query <_tutorials/basics3_graph_selections>
   Using the graph ORM <_tutorials/moderate1_graph_orm>
   Comparing and combining graphs <_tutorials/moderate2_graph_compare_join>
