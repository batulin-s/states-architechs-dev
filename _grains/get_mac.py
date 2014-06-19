'''SLS - Setup iptables for load balansers'''

import logging
import salt.modules.network as salt_network
log = logging.getLogger(__name__)

def lb_iptables():
    hw_addrs=[]
    for i in salt_network.interfaces().keys():
        if i.startswith('eth'):
	    hw_addrs.append(salt_network.hw_addr(i))
    return {'hw_addrs':hw_addrs}
    
