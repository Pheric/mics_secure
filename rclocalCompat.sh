#!/usr/bin/env bash

# TODO: check for systemd
if [ ! -f /etc/rc.local ]; then
    cat > /etc/systemd/system/rc-local.service << EOL
    [Unit]
      Description=/etc/rc.local compat

    [Service]
      Type=forking
      ExecStart=/etc/rc.local
      TimeoutSec=0

    [Install]
      WantedBy=multi-user.target
    EOL

    echo "#!/usr/bin/env bash" > /etc/rc.local
    chmod 755 /etc/rc.local
    chattr +i /etc/rc.local

    service rc-local start
fi