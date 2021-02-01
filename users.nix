{ pkgs, ... }:

{
  # Make users immutable, passwords must be set
  users.mutableUsers = false;

  users.users.infinity = {
    isNormalUser = true;
    hashedPassword = "$6$tHKIF.z6$YxikRiScslszerVWhawoFQZW86yFPXjHsurip3hwbldoFQ.y79.onzEd73Dr7zYn0W9mehi6bXfGz6Z3QQlHC0";
    extraGroups = [
      "wheel"
      "libvirtd"
      "networkmanager"
    ];
    packages = with pkgs; [
      neofetch
    ];
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCuqG/d0hyLjaB3vTQbMWTAsQ5hd7FoGtF53iZFAR+Aex2SAOkdlan9kbzheHq3/1APLaVP9xGKwAbzUrv5gtg8oaYzJ4/QH3sD9//5jSMNJdyUbVeUJIhqUuEf0EqCvzb7v49vhOMzsGqWQOsMpgBYQSpGI1zZe29pSDFrgtg7AkQZKm2/exOeoScJKYFQibsyk74nctsniwbylHsim5uMxtsMzTD9dEUllu2m8C5qHoxb6wgyOR4uzDYGRHlDR++UKDN7DvR1OhF7I/jXrBxSYAmNNWIRJ7LLRnuxOe6sxkbND7eHuZJmeJpOvG0ktq1HWsEavUnyBb4OqdB+9RIuBffweR102Yzm3e+tNKGQO0zIDpWuibGWAW+z33n3rWWafz7K20RessvZy7jhrSAkfNjHWzvW+ffyGPKG7YMuYsiIGA5cSQH+35fFUrvTaRyEcpJCfRyXGvlEQxperlWogxWwYqQmCCej73RtsD+Ums3VwakAuK3hiA5lieHdKaH6GAh/9xX7uTuvQTYvsaY23h+qBOzLYkVd65SZNWOcLWnnobajGaiUyjY0l9+zscHdbEFJxkCl7PWxgzJmCDpbc/4DzBC1xD6X1ZCz2Bovs183MKBqYymCZl6j5MhiBQ8H5vt3Tu/SBDvPB1F1viPFsf++UKdYNRZbCYopFfKKLw== JuiceSSH"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDbn1x8eTkbzK7OH8cO6ctamFS7iIlxc0OOr1MLE8FWup2pizJa5wYLno+BETa2SLmqbNasPt+YjEom0AjQl1pOYDSt2t3gsqoHq/odigFzp6B9dS7u2UuVxFifbAPolsho/Z2hKi/mRDZD9E47dCWBK1picqKfM6UyerKPb1YkXtrvBRFEc5k4SXSBSyoGhwLjrldqM/RYXxGVJTpUAD4ZSKxU3QsMIkE6jfP0fICdkPy7GY5p1FDd+IvpGQoiTfOM9cCtW60d1hDAEDyrBR0/voPGCL3Vq0fLPZMFvQLzNfHk6E2jrTMhVp/9q9Hj3xihiVvUThgHNeHFOwlJmSd1uIv6U1ztgXd6NG6FMLrMAHukI5lDTP5a4l5NxKnT9IloW4UK9fFUDxloupumsdwyfzLeSOg0tFO6J42gQX4pFYMfWe+dTJung/Wh848PF5fXPclO+SaKKhiRuE+Jw53//OHyV2NZXV301aj13ZM5d7YurnfoA2PV6azn6bhu0J6pMFsJn+Mb6gHPZzkrJ570cTNo9YB3mdQoHDGD5z2DJ5mQ4pfabhQImBjJ94aDbZnlENrxrCExTECqqmlv/7a30nGcc1+d8TVmRSLRBE4X1FKwMizLKtjDGBJgyWTMWZsN/2v1BuyD33C27nV8HUVHR6QEX7JztzGb5VNGKsnsAQ== infinity@nixos-toshiba"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQChtf1eIfxzuCqDi475xbIYau5McxdIykkHVJx/pC887m6yObmNqGzGaIki9vjtSAoMUaLWCcI6UHfqh4TgcbLo/n81kNZWYkkRDvkpUCNq/fbjFrxZLptZiqFT23JwWruBwCFgwc3btc7pMymltT9ZJ3gymCh4jKZZubmIgZWBmiAGzOZNOLp6eM2uIdlHX/hWu15qHUFANWZzE5VAbUZ2YobG43WILi/9eS3/zKOPdaXYsbBZBtdbIiuMPcyWYen2YytFaKRZ/gk1PdT31vKBV9zKl+gvEQbrNgcOl3LbUXTHT5XQju8ZwNkxc3Ya8p5n+PDkpNtSaZSvydJ0nEDPWUqypdJovFCHxcwu1DtynZSt7rP0/OJwdRRt8kxNwuIWPkun3KPogNIdctWF2DhRtw4L88VntaCwLSnAhjqXzrnF7Esoz3fps0FOLjOT2IxEoTaqt9nvToVNNRkOlvzREEDSxGEx30fCzzN0wVDuyaeQnCf3oaClMvulvhIp4czHPNOLV1Sedr60V7Em75BIGZMlwILW2yjQt0i6bVllVVYYtvHky6S4eWi75+pptQOB9yO1bNdCFjImyCe3Rov412LRkxjGWXcJeWcFB7hKd8RQm8litCH8xaFa5LcaynCS3wMm2dfgSRunz3s794LgqAlrzwU7ZM82utM8PiFiiQ== infinity@hp-nixos"
    ];
  };

  users.users.sky = {
    isNormalUser = true;
    extraGroups = [
      "libvirtd"
    ];
    password = "";
  };
}
