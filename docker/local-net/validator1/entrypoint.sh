#!/bin/bash

VALIDATOR=$(sui validator display-metadata 2>&1)
ACCOUNT="0xdbe3e8dd0739620448d202d18158b9622e65ea797f2571d3574c4e4d33e0fb09"

if echo "$VALIDATOR" | grep -q "is not an active or pending Validator"; then
    SUI_PATH="$HOME/.sui/sui_config"
    cd $SUI_PATH

    # Generate validator info and key files
    sui validator make-validator-info $ACCOUNT "" "https://example.com/image.png" "https://example.com" "validator1" 1000

    # Make that validator join the committee
    sui validator become-candidate $SUI_PATH/validator.info

    # Stake SUI to the validator pool (the command uses the last gas coin owned by the address, make sure it has at least 30M SUI)
    sui client call --package 0x3 --module sui_system --function request_add_stake --args 0x5 $(sui client gas | grep 0x | awk '{print $2}' | tail -1) $ACCOUNT

    # Join the committee
    sui validator join-committee
else
    echo "$ACCOUNT is already an active or pending validator, no need to join committee again"
fi

exec "$@"
