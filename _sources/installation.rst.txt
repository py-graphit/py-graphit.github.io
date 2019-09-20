.. _installation::

Installation
============

We recommend that you install ``graphit`` using ``pip``. ::

  pip install py-graphit

Parsing the content of YAML files to Graphit graph requires the PyYAML
package not installed by default. You can specify the optional install as ::

  pip install py-graphit[yaml]

or install the package separately.
Graphit supports Python 2.7 or Python 3.4+ (recommended) on Mac and Linux.

Install from source
-------------------

You can clone or download the Graphit source repository from `GitHub <https://github.com/py-graphit/py-graphit>`_,
or better even ``fork`` it! Intall using ::

  git clone https://github.com/py-graphit/py-graphit.git
  cd py-graphit
  pip install -e .

Testing the installation
------------------------

The source repository on Github contains a `test` directory, a great way to verify that
everything is working. You can run the test from the root of the repository using ::

  python tests
