{
  # Network discovery, mDNS
  # With this enabled, you can access your machine at <hostname>.local
  # it's more convenient than using the IP address.
  # https://avahi.org/
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    publish = {
      enable = true;
      domain = true;
      userServices = true;
    };
  };

  # Use an NTP server located in the mainland of China to synchronize the system time
  networking.timeServers = [
    "ntp-syd.aussiebroadband.com.au" # Aliyun NTP Server
  ];
}
