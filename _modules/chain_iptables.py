# -*- coding: utf-8 -*-
'''
Support for iptables
'''
import os
import sys
import shlex

# Import salt libs
import salt.utils
from salt.modules.iptables import _parse_conf
def _iptables_cmd(family='ipv4'):
    '''
    Return correct command based on the family, eg. ipv4 or ipv6
    '''
    if family == 'ipv6':
        return 'ip6tables'
    else:
        return 'iptables'


def check_chain(table='filter', chain=None, family='ipv4'):
    '''
    .. versionadded:: 2014.1.0 (Hydrogen)

    Check for the existance of a chain in the table

    CLI Example:

    .. code-block:: bash

        salt '*' iptables.check_chain filter INPUT

        IPv6:
        salt '*' iptables.check_chain filter INPUT family=ipv6
    '''

    if not chain:
        return 'Error: Chain needs to be specified'

    cmd = '{0}-save -t {1}'.format(_iptables_cmd(family), table)
    out = __salt__['cmd.run'](cmd).find(':{1} '.format(table, chain))

    if out != -1:
        out = True
    else:
        out = False

    return out


def new_chain(table='filter', chain=None, family='ipv4'):
    '''
    .. versionadded:: 2014.1.0 (Hydrogen)

    Create new custom chain to the specified table.

    CLI Example:

    .. code-block:: bash

        salt '*' iptables.new_chain filter CUSTOM_CHAIN

        IPv6:
        salt '*' iptables.new_chain filter CUSTOM_CHAIN family=ipv6
    '''

    if not chain:
        return 'Error: Chain needs to be specified'

    cmd = '{0} -t {1} -N {2}'.format(_iptables_cmd(family), table, chain)
    out = __salt__['cmd.run'](cmd)

    if not out:
        out = True
    return out
def get_policy(table='filter', chain=None, family='ipv4'):
    '''
    Return the current policy for the specified table/chain

    CLI Example:

    .. code-block:: bash

        salt '*' iptables.get_policy filter INPUT

        IPv6:
        salt '*' iptables.get_policy filter INPUT family=ipv6
    '''
    if not chain:
        return 'Error: Chain needs to be specified'

    rules = _parse_conf(in_mem=True, family=family)
    return rules[table][chain]['policy']


def set_policy(table='filter', chain=None, policy=None, family='ipv4'):
    '''
    Set the current policy for the specified table/chain

    CLI Example:

    .. code-block:: bash

        salt '*' iptables.set_policy filter INPUT ACCEPT

        IPv6:
        salt '*' iptables.set_policy filter INPUT ACCEPT family=ipv6
    '''
    if not chain:
        return 'Error: Chain needs to be specified'
    if not policy:
        return 'Error: Policy needs to be specified'

    cmd = '{0} -t {1} -P {2} {3}'.format(_iptables_cmd(family), table, chain, policy)
    out = __salt__['cmd.run'](cmd)
    return out


