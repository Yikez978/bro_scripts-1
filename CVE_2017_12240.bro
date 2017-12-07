# Aaron Eppert

module CVE_2017_12240;

export {
    redef enum Notice::Type += {
		LARGE_DHCP_PACKET
	};
	
	const dhcp_pkt_threshold = 301 &redef;
}

event connection_state_remove(c: connection) 
{
    if ( !c$conn?$service ) {
        return;
    }
    
    if( c$conn$service  == "dhcp" ) {
        if ( c$conn?$resp_bytes && c$conn$resp_bytes > dhcp_pkt_threshold ) {
            NOTICE([$note=CVE_2017_12240::LARGE_DHCP_PACKET,
                    $msg=fmt("DHCP Packet over threshold in resp_bytes %d (Max: %d)", c$conn$resp_bytes, dhcp_pkt_threshold),
                    $conn=c,
                    $identifier=cat(c$id$resp_h,c$id$resp_p)]); 
        }
        if ( c$conn?$orig_bytes && c$conn$orig_bytes > dhcp_pkt_threshold ) {
            NOTICE([$note=CVE_2017_12240::LARGE_DHCP_PACKET,
                    $msg=fmt("DHCP Packet over threshold in orig_bytes %d (Max: %d)", c$conn$orig_bytes, dhcp_pkt_threshold),
                    $conn=c,
                    $identifier=cat(c$id$resp_h,c$id$resp_p)]); 
        }
    }
}
