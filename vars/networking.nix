{lib}: rec {
  mainGateway = "192.168.1.1"; # main router
  # use suzi as the default gateway
  # it's a subrouter with a transparent proxy
  defaultGateway = "192.168.1.1"; # Changed to use main router as default gateway
  nameservers = [
    "8.8.8.8" # Google DNS
    "1.1.1.1" # Cloudflare DNS
  ];
  prefixLength = 24;

  hostsAddr = {
    # ============================================
    # Homelab's Physical Machines (KubeVirt Nodes)
    # ============================================
    # kubevirt-youko = {
    #   iface = "eno1";
    #   ipv4 = "192.168.5.183";
    # };

    # ============================================
    # Other VMs and Physical Machines
    # ============================================
    ai = {
      # Desktop PC
      iface = "enp39s0"; # Ensure this matches your network interface
      ipv4 = "192.168.1.100"; # Update if necessary
    };
   
    # ============================================
    # Kubernetes Clusters
    # ============================================
    # k3s-prod-1-master-1 = {
    #   iface = "enp2s0";
    #   ipv4 = "192.168.5.108";
    # };
   
  };

  hostsInterface =
    lib.attrsets.mapAttrs
    (
      key: val: {
        interfaces."${val.iface}" = {
          useDHCP = false;
          ipv4.addresses = [
            {
              inherit prefixLength;
              address = val.ipv4;
            }
          ];
        };
      }
    )
    hostsAddr;

  # ssh = {
  #   extraConfig =
  #     lib.attrsets.foldlAttrs
  #     (acc: host: val:
  #       acc
  #       + ''
  #         Host ${host}
  #           HostName ${val.ipv4}
  #           Port 22
  #       '')
  #     ""
  #     hostsAddr;

  #   # define the host key for remote builders so that nix can verify all the remote builders
  #   # this config will be written to /etc/ssh/ssh_known_hosts
  #   knownHosts =
  #     lib.attrsets.mapAttrs
  #     (host: value: {
  #       hostNames = [host hostsAddr.${host}.ipv4];
  #       publicKey = value.publicKey;
  #     })
  #     {
  #       # aquamarine.publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIbIecyrmrBpjD497lA2adJeTpsubZ3dozEraLGCcgVi root@aquamarine";
  #       # ruby.publicKey = "";
  #       # kana.publicKey = "";
  #     };
  # };
}
