{ config, lib, pkgs, ... }:

{
    options.services.alephium = {

        enable = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = ''
                When enabled, run the Alephium node as a service.
            '';
        };

        package = lib.mkOption {
            type = lib.types.package;
            default = pkgs.callPackage ./alephium.nix { };
            description = ''
                Package that provides the `alephium` executable.
                The `alephium` executable is typically a JVM
                that is wrapped to execute the Alephium JAR.
            '';
        };

        home = lib.mkOption {
            type = lib.types.path;
            default = "/var/lib/alephium";
            description = ''
                Alephium home directory which stores
                configuration and the blockchain.
            '';
        };

    };

    config = lib.mkIf config.services.alephium.enable {

        users.users.alephium = {
            group = "alephium";
            description = "Alephium node user";
            isSystemUser = true;
        };

        users.groups.alephium = {
        };

        systemd.services.alephium = {

            description = "Alephium node";

            after = [ "network.target" ];
            wantedBy = [ "multi-user.target" ];

            environment = {
                ALEPHIUM_HOME = config.services.alephium.home;
            };

            serviceConfig = {
                User = "alephium";
                Group = "alephium";
                ExecStart = "${config.services.alephium.package}/bin/alephium";
                Restart = "always";
                TimeoutSec = 5;
            };

        };

    };
}
