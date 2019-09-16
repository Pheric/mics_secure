esxcli network firewall ruleset set --ruleset-id sshServer --allowed-all false
esxcli network firewall ruleset set --ruleset-id vSphereClient --allowed-all false
esxcli network firewall ruleset allowedip add --ruleset-id vSphereClient --ip-address 10.0.150
