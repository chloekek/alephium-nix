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
            "testnet-bootstrap.alephium.org:9973"
        ];
        mining.miner-addresses = [
            "1cLiepA3tKr5d47cMZVb2zdtcWwwSqFibmSvcaoUHLg8"
            "1DJ4nnfaVWHQTz3n8BTTeByWkKGYf3baPCPDknenRGtYJ"
            "1AhwiVEdzWD3abZpRHyMSrPEDwoAwySrYZAgMZz4bhDCi"
            "1BkWG82inFPdvmB2HFbFQvosnxddF78Jvi9DbLqZbHwVw"
        ];
        network.network-id = 1;
    };

    # Example configuration for Prometheus.
    # If you do not use Prometheus then you can ignore this example.
    services.prometheus.scrapeConfigs = [
        {
            job_name = "alephium";
            scrape_interval = "10s";
            static_configs = [ { targets = [ "localhost:12973" ]; } ];
        }
    ];
}
```

The Nix code in this repository is licensed CC0.
See LICENSE.CC0 for more information.
