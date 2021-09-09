Work in progress but if you feel adventurous you can try it out.

After changing Alephium version you may have to remove `/var/lib/alephium`.
This is because testnet database format is not stable.

Example NixOS configuration:

```nix
{ ... }:

{
    services.alephium = {
        enable = true;
        discovery.bootstrap = [
            "3.122.234.1:9973"
            "3.15.45.47:9973"
            "13.239.2.91:9973"
        ];
        mining.miner-addresses = [
            "1cLiepA3tKr5d47cMZVb2zdtcWwwSqFibmSvcaoUHLg8"
            "1DJ4nnfaVWHQTz3n8BTTeByWkKGYf3baPCPDknenRGtYJ"
            "1AhwiVEdzWD3abZpRHyMSrPEDwoAwySrYZAgMZz4bhDCi"
            "1BkWG82inFPdvmB2HFbFQvosnxddF78Jvi9DbLqZbHwVw"
        ];
        network.network-id = 1;
    };
}
```
