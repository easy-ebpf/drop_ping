#include <vmlinux.h>
#include <bpf/bpf_helpers.h>
#include <bpf/bpf_endian.h>

#include "bpf_tracing_net.h"

SEC("xdp")
int drop_ping(struct xdp_md *ctx) {
	void *data = (void *)(__u64)ctx->data;
	void *data_end = (void *)(__u64)ctx->data_end;

    struct ethhdr *l2 = data;
    if ((void *)&l2[1] > data_end || bpf_htons(l2->h_proto) != ETH_P_IP)
        return XDP_PASS;

    struct iphdr *l3 = (struct iphdr *)&l2[1];
    if ((void *)&l3[1] > data_end || l3->protocol != IPPROTO_ICMP)
        return XDP_PASS;

    struct icmphdr *icmp = (struct icmphdr *)&l3[1];

    if ((void *)&icmp[1] > data_end)
        return XDP_PASS;

    if (icmp->type == ICMP_ECHOREPLY) {
        bpf_printk("drop icmp echo reply packet");
        return XDP_DROP;
    }

    return XDP_PASS; 
}

char LICENSE[] SEC("license") = "Dual BSD/GPL";