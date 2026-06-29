{ config, pkgs, ... }:
let
  grafanaPort = 2342;
  prometheusPort = 9095;
  prometheusNodePort = 9096;

  cgroup-exporter = pkgs.callPackage ./cgroup-exporter.nix { };
  cgroupExporterPort = 12332;
in
{
  services.grafana = {
    enable = true;
    settings = {
      security.secret_key = "SW2YcwTIb9zpOOhoPsMm";
      "auth.anonymous" = {
        enabled = true;
        org_role = "Admin";
        org_name = "Main Org.";
      };
      server = {
        domain = "localhost";
        root_url = "http://localhost:${toString grafanaPort}";
        http_addr = "127.0.0.1";
        http_port = grafanaPort;
      };
    };
  };

  services.prometheus = {
    enable = true;
    port = prometheusPort;

    exporters = {
      node = {
        enable = true;
        enabledCollectors = [ "systemd" ];
        port = prometheusNodePort;
      };
    };

    scrapeConfigs = [
      {
        job_name = "node";
        scrape_interval = "30s";
        static_configs = [
          {
            targets = [ "localhost:${toString prometheusNodePort}" ];
          }
        ];
      }
      {
        job_name = "cgroup";
        scrape_interval = "30s";
        static_configs = [
          {
            targets = [ "localhost:${toString cgroupExporterPort}" ];
          }
        ];
      }
    ];
  };

  systemd.services.cgroup-exporter = {
    description = "cgroup-exporter";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${cgroup-exporter}/bin/cgroup-exporter -listen-address localhost:${toString cgroupExporterPort}";
      Restart = "always";
    };
  };
}
