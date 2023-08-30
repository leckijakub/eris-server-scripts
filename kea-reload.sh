#!/bin/bash
# Run script(it will block terminal) and press ctrl+d to finish.
# Expected output: [ { "result": 0, "text": "Configuration successful." } ] 

kea-shell --host 127.0.0.1 --port 8000 --service dhcp4 config-reload
