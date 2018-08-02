#!/bin/bash

function make_policy() { echo "{\"Statement\":[{\"Resource\":\"$1\",\"Condition\":{\"DateLessThan\":{\"AWS:EpochTime\":$2}}}]"}; }

# https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/private-content-linux-openssl.html
# cat version_policy | tr -d "\n" | openssl sha1 -sign aws-signed-url-private-key.pem | openssl base64 |  tr -- '+=/' '-_~'
# updated to
# cat version_policy | tr -d "\n" | openssl sha1 -sign aws-signed-url-private-key.pem | openssl base64 | tr -d "\n" |  tr -- '+=/' '-_~'
# to remove the newlines added from `openssl base64`
function sign_policy { cat "$@" | tr -d "\n" | openssl sha1 -sign aws-signed-url-private-key.pem | openssl base64 | tr -d "\n" |  tr -- '+=/' '-_~'; }

function signed_url { echo "$1?Expires=$2&Signature=$3&Key-Pair-Id=<active_keypair_for_signer>"; }

expiration_time=1595877853
echo "---------------------------------------------------------------------"
echo "VERSION"
version_resource="https://d1pea6wt3ld8hw.cloudfront.net/ruby/VERSION"
version_policy=$(make_policy $version_resource $expiration_time)
version_signature=$(sign_policy version_policy)
echo "url:"
echo "$(signed_url $version_resource $expiration_time $version_signature)"
echo
echo "CHANGELOG.md"
changelog_resource="https://d1pea6wt3ld8hw.cloudfront.net/ruby/CHANGELOG.md"
changelog_policy=$(make_policy $changelog_resource $expiration_time)
changelog_signature=$(sign_policy changelog_policy)
echo "url:"
echo "$(signed_url $changelog_resource $expiration_time $changelog_signature)"
echo "---------------------------------------------------------------------"


