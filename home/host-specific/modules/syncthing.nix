{
  services = {
    syncthing = {
      enable = true;
      settings = {
        devices = {
          "pve" = {
            id = "POC3CII-XPQC7D7-WW5RGNZ-Z3TITOS-S257RC3-SWBWMI2-362MJQP-SQBCMQ4";
          };
        };
        folders = {
          "/home/liv/ServerSync" = {
            devices = [ "pve" ];
            label = "ServerSync";
            id = "m3tta-znnlt";
          };
          "/home/liv/PookShare" = {
            devices = [ "pve" ];
            label = "PookShare";
            id = "oipn4-dfjk2";
          };
        };
      };
    };
  };
}
