This directory contains p11kit configuration instructions for macos.

First you need to install `p11kit`:

    brew install libp11 openssl p11kit

Next install p11kit configuration files into user config directory:

    mkdir -p ~/.config/pkcs11/modules
    cp config-modules/*.module ~/.config/pkcs11/modules/ 

Check:

    p11tool --list-tokens
