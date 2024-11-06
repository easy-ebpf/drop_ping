# eBPF: Drop *ICMP* Packets with XDP
## Description
`ping` is a common method for checking if a network domain is accessible, using the ICMP protocol. A ping packet consists of Ethernet, IP, and ICMP layers. 

This XDP program filters ICMP packets and drops them before they reach the kernel network stack.

## Usage
### Setup
- Run `make` to compile the XDP program.
- Use `./load.sh <ifname>` to attach the XDP program to a specific network interface.

### Test
Testing on the loopback interface (`lo`) is sufficient to confirm the functionality. Before attaching the XDP program, run `ping localhost`, and all packets should receive replies. Then, activate the XDP program; requests will now timeout as ICMP packets are dropped.

### Teardown
- Run `./unload.sh <ifname>` to detach the XDP program from the network interface.