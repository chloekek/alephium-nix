{ config, lib, pkgs, ... }:

let

    # Convenient way to reference the Alephium config.
    cfg = config.services.alephium;

in

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
            default = pkgs.alephium;
            description = ''
                Package that provides the `alephium` executable.
                The `alephium` executable is typically a JVM
                that is wrapped to execute the Alephium JAR.
            '';
        };

        discovery.bootstrap = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            description = ''
                Addresses of other Alephium nodes to connect to initially.
                This is different for each network, so there is no default.
            '';
        };

        mining.miner-addresses = lib.mkOption {
            type = lib.types.nullOr (lib.types.listOf lib.types.str);
            default = null;
            description = ''
                List of addresses to which mining rewards are to be deposited.
                You can leave this null if you do not participate in mining.
                If not null, must contain exactly four elements.
            '';
        };

        network.network-id = lib.mkOption {
            type = lib.types.int;
            description = ''
                Alephium network identifier.
                Set to 1 for testnet.
            '';
        };

    };

    config = {

        nixpkgs.overlays = [ (import ./overlay.nix) ];

        users.users.alephium = lib.mkIf cfg.enable {
            group = "alephium";
            description = "Alephium node user";
            isSystemUser = true;
        };

        users.groups.alephium = lib.mkIf cfg.enable {
        };

        environment.etc."alephium/user.conf" = lib.mkIf cfg.enable {
            text = ''
                ${
                    if cfg.mining.miner-addresses == null then
                        ""
                    else
                        ''alephium.mining.miner-addresses = ${
                            builtins.toJSON cfg.mining.miner-addresses
                        }''
                }
                alephium.network.network-id = ${
                    toString cfg.network.network-id
                }
                alephium.discovery.bootstrap = ${
                    builtins.toJSON cfg.discovery.bootstrap
                }
                alephium.wallet.secret-dir = /var/lib/alephium/wallet

                # TODO: Make the remaining options configurable.
                # alephium.network.external-address = "x.x.x.x:9973"
            '';
        };

        systemd.services.alephium = lib.mkIf cfg.enable {
            description = "Alephium node";

            # TODO: Configure service to restart when config file has changed?

            after = [ "network.target" ];
            wantedBy = [ "multi-user.target" ];

            environment = {
                # This is where Alephium node stores config and blockchain.
                ALEPHIUM_HOME = "/var/lib/alephium/home";
            };

            serviceConfig = {
                User = "alephium";
                Group = "alephium";
                ExecStart = "${cfg.package}/bin/alephium";

                # systemd prepends /var/lib to this.
                StateDirectory = "alephium";

                Restart = "always";
                TimeoutSec = 5;
            };

            preStart = ''
                home=/var/lib/alephium/home
                user_conf=$home/user.conf

                # Create the Alephium home directory.
                # systemd will have created its parent already.
                if ! [[ -e $home ]]; then
                    mkdir "$home"
                fi

                # Alephium configuration file is in ALEPHIUM_HOME,
                # but we want to store it in /etc/alephium.
                # Using a symbolic link for this works.
                if ! [[ -e $user_conf ]]; then
                    ln --symbolic /etc/alephium/user.conf "$user_conf"
                fi
            '';
        };

    };
}
