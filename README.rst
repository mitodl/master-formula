======
master
======

State tree for building a Salt Master

.. note::

    See the full `Salt Formulas installation and usage instructions
    <http://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html>`_.


Available states
================

.. contents::
    :local:

``master``
----------

Sets up a salt master node with a `secretary` minion for configuring it and executing maintenance tasks. Allows for a largely pillar based customization of the master node. Includes gitfs with repos defined by pillar.

``master.api``
---------------

Sets up the salt api with SSL certificate, running on Tornado.

``master.saltpad``
---------------

Installs and configures a SaltPad Web UI. As of 2016-02-25 this requires a development version of SaltStack (refer to SaltPad readme for details).

``master.aws``
---------------

Sets up and configures AWS as a provider for salt-cloud. Registers an SSH key with AWS to be used for communicating with minions when they are launched.


Template
========

This formula was created from a cookiecutter template.

See https://github.com/mitodl/saltstack-formula-cookiecutter
