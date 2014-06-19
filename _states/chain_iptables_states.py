# -*- coding: utf-8 -*-
from salt.state import STATE_INTERNAL_KEYWORDS as _STATE_INTERNAL_KEYWORDS

def chain_present(name,chain_name='', table='filter', family='ipv4'):
    '''
    .. versionadded:: 2014.1.0 (Hydrogen)

    Verify the chain is exist.

    name
        A user-defined chain name.

    table
        The table to own the chain.

    family
        Networking family, either ipv4 or ipv6
    '''

    ret = {'name': name,
           'changes': {},
           'result': None,
           'comment': ''}

    chain_check = __salt__['chain_iptables.check_chain'](table, chain_name, family)
    if chain_check is True:
        ret['result'] = True
        ret['comment'] = ('chain_iptables {0} chain is already exist in {1} table for {2}'
                          .format(name, table, family))
        return ret

    command = __salt__['chain_iptables.new_chain'](table, chain_name, family)
    if command is True:
        ret['changes'] = {'locale': name}
        ret['result'] = True
        ret['comment'] = ('chain_iptables {0} chain in {1} table create success for {2}'
                          .format(name, table, family))
        return ret
    else:
        ret['result'] = False
        ret['comment'] = 'Failed to create {0} chain in {1} table: {2} for {3}'.format(
            name,
            table,
            command.strip(),
            family
        )
        return ret

def set_policy(name, family='ipv4', **kwargs):
    '''
    .. versionadded:: 2014.1.0 (Hydrogen)

    Sets the default policy for iptables firewall tables

    family
        Networking family, either ipv4 or ipv6

    '''
    ret = {'name': name,
        'changes': {},
        'result': None,
        'comment': ''}

    for ignore in _STATE_INTERNAL_KEYWORDS:
        if ignore in kwargs:
            del kwargs[ignore]

    if __salt__['iptables.get_policy'](
            kwargs['table'],
            kwargs['chain'],
            ) == kwargs['policy']:
        ret['result'] = True
        ret['comment'] = ('iptables default policy for {0} for {1} already set to {2}'
                          .format(kwargs['table'], family, kwargs['policy']))
        return ret

    if not __salt__['iptables.set_policy'](
            kwargs['table'],
            kwargs['chain'],
            kwargs['policy'],
            ):
        ret['changes'] = {'locale': name}
        ret['result'] = True
        ret['comment'] = 'Set default policy for {0} to {1} family {2}'.format(
            kwargs['chain'],
            kwargs['policy'],
	    family
        )
        return ret
    else:
        ret['result'] = False
        ret['comment'] = 'Failed to set iptables default policy'
        return ret
