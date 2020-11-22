{ config, lib, pkgs, ... }:

with lib;

let
  eachOE = config.services.openethereum;

  oeOpts = { config, lib, name, ...}: {

    options = {

      enable = lib.mkEnableOption "OpenEthereum node";

      address = mkOption {
        type = types.str;
        default = "0.0.0.0";
        description = ''
          Adress OpenEthereum will be listening on, both TCP and UDP.
        '';
      };

      port = mkOption {
        type = types.port;
        default = 30303;
        description = ''
          Port number OpenEthereum will be listening on, both TCP and UDP.
        '';
      };

      http = {
        enable = lib.mkEnableOption "OpenEthereum HTTP API";
        address = mkOption {
          type = types.str;
          default = "127.0.0.1";
          description = ''
            Listen address of OpenEthereum HTTP API.
          '';
        };

        port = mkOption {
          type = types.port;
          default = 8545;
          description = ''
            Port number of OpenEthereum HTTP API.
          '';
        };

        apis = mkOption {
          type = types.nullOr (types.listOf types.str);
          default = null;
          description = ''
            APIs to enable over RPC
          '';
          example = ["net" "eth"];
        };
      };

      websocket = {
        enable = lib.mkEnableOption "OpenEthereum WebSocket API";
        address = mkOption {
          type = types.str;
          default = "127.0.0.1";
          description = ''
            Listen address of OpenEthereum WebSocket API.
          '';
        };

        port = mkOption {
          type = types.port;
          default = 8546;
          description = ''
            Port number of OpenEthereum WebSocket API.
          '';
        };

        apis = mkOption {
          type = types.nullOr (types.listOf types.str);
          default = null;
          description = ''
            APIs to enable over WebSocket
          '';
          example = ["net" "eth"];
        };
      };

      network = mkOption {
        type = types.enum [ "goerli" "foundation" ];
        default = "foundation";
        description = ''
          The network to connect to. Foundation is the default ethereum network.
        '';
      };

      metrics = {
        enable = lib.mkEnableOption "OpenEthereum prometheus metrics";
        address = mkOption {
          type = types.str;
          default = "127.0.0.1";
          description = ''
            Listen address of OpenEthereum metrics service.
          '';
        };

        port = mkOption {
          type = types.port;
          default = 3000;
          description = ''
            Port number of OpenEthereum metrics service.
          '';
        };
      };

      extraArgs = mkOption {
        type = types.str;
        description = ''
          Additional arguments passed to OpenEthereum.
        '';
        default = "";
        example = "--logging debug";
      };

      package = mkOption {
        default = pkgs.openethereum;
        type = types.package;
        description = ''
          Package to use as OpenEthereum node.
        '';
      };
    };
  };
in

{

  ###### interface

  options = {
    services.openethereum = mkOption {
      type = types.attrsOf (types.submodule oeOpts);
      default = {};
      description = "Specification of one or more OpenEthereum instances.";
    };
  };


  ###### implementation

  config = mkIf (eachOE != {}) {

    systemd.services = mapAttrs' (oeName: cfg: (
      nameValuePair "openethereum-${oeName}" (mkIf cfg.enable {
      description = "OpenEthereum node (${oeName})";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      serviceConfig = {
        DynamicUser = true;
        Restart = "always";
        StateDirectory = "openethereum/${oeName}";
        # Give openethereum time to shut down.
        KillSignal = "SIGHUP";

        # Hardening measures
        PrivateTmp = "true";
        ProtectSystem = "full";
        NoNewPrivileges = "true";
        PrivateDevices = "true";
        MemoryDenyWriteExecute = "true";
      };

      script = ''
        ${cfg.package}/bin/openethereum \
          --no-ipc \
          --no-secretstore \
          --chain=${cfg.network} \
          --port ${toString cfg.port} --interface ${cfg.address} \
          ${if cfg.http.enable then ''--jsonrpc-interface ${cfg.http.address} --jsonrpc-port ${toString cfg.http.port}'' else ''--no-jsonrpc''} \
          ${optionalString (cfg.http.apis != null) ''--jsonrpc-apis ${lib.concatStringsSep "," cfg.http.apis}''} \
          ${if cfg.websocket.enable then ''--ws-interface ${cfg.websocket.address} --ws-port ${toString cfg.websocket.port}'' else ''--no-ws''} \
          ${optionalString (cfg.websocket.apis != null) ''--ws-apis ${lib.concatStringsSep "," cfg.websocket.apis}''} \
          ${optionalString cfg.metrics.enable ''--metrics --metrics-interface ${cfg.metrics.address} --metrics-port ${toString cfg.metrics.port}''} \
          ${cfg.extraArgs} \
          --base-path=/var/lib/openethereum/${oeName}
      '';
    }))) eachOE;

  };

}
