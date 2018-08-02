#!/bin/bash

# https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/private-content-linux-openssl.html
# cat version_policy | tr -d "\n" | openssl sha1 -sign private_key.pem | openssl base64 |  tr -- '+=/' '-_~'
# updated to
# cat version_policy | tr -d "\n" | openssl sha1 -sign private_key.pem | openssl base64 | tr -d "\n" |  tr -- '+=/' '-_~'
# to remove the newlines added from `openssl base64`
function sign_policy { cat "$@" | tr -d "\n" | openssl sha1 -sign private_key.pem | openssl base64 | tr -d "\n" |  tr -- '+=/' '-_~'; }

# cat version_policy | tr -d "\n" | openssl sha1 -sign private_key.pem | openssl base64 | tr -d "\n" |  tr -- '+=/' '-_~'
# EkrpXhl-REzPFOGZWW5fH1e63cHGUguai7i8zisNb-D2K5IWusUZOHwtjGTQyyTzIDGYu7eJYL9-Jctq3IzEFEhw-mLYsX-r8aj~4OSZb5MKCgrpdOm-o0wzmX6H1Lc4xX4DlSYepcTU60zAiilpQZH4EbA~JPLFWwZDXTo1wfZhwQHR5TWqI83tzIyv972l8tJfiIyKvJ2CfL6aVfpGOwmwm5sxmzTg-KBiicGmY9qCeXTbSdEAp3X8epp4Q1jbmsu9EzedkuVeBTBagvXMboR2Oo2jO6B07lN1-3RJUnDYhTSkijNfaRA~IZ0z0Id6E4H3ERvv7LAocX-0EBKkJb5ET7VdBJsLfINlZ5oWawiYqNwSAy5po2w7ipIUUAKrqtE5iUeFCxzaQGEiac21NaR11gG4l7jpyB8~x5qfifvU7uoppOo-gEGn6FPVVzsMzpUuFKTRxATv5eAqZcQXyP-eWq04UrAt2QTnEZM854VEa2-gw6WK0WNi~GeQGZ7kK3VVL6GSoGqWDDTsqCpXprFnDFXtmmnGEjtb54CFzz74BMC-9ntTFhGJNefgTPnUZG8URcu85DZoFLPOQ7tQ6Jg8l~1okea5FPc7XddHwfisCRzgUCLqQgKMCPnhbCESNnMMaioeqjlSWOPgflvTZbtLQK394vF2ZymUxAGv5Jo_
echo "version_policy signature:"
echo "$(sign_policy version_policy)"

# cat changelog_policy | tr -d "\n" | openssl sha1 -sign private_key.pem | openssl base64
# gqz-U13KvqrK3JBRqdNEgJzAibxbL2rOomwofWtcTKKQX4AY7tetVMclcC8HP9jahgz-y~ZDunPP10a-3YH2GpbjijSEYrAWDerTRBt~uAGQihhYCvuG8fNR3ZZINYwbRWEk6b7aEtfREgm6Wgs37filycXVNHrP~HTlHDJIwJiYAinp0AMhJXfP7eGQO2OSztR9GNUgo8GlYymRCnFJJPZflCUlBKRV719eqSFrPqDWek4EowNCXHwPzglV4R4YcpZtVr7ZWJCOOle3atua5tDqY66fwxF1JUVuHp23F1~quyO5jHjVIZgoS28yLvvzagLaa3O5qOrX2l36efiMZE7zdXu-qDSpPApJsN3ShMH05TdkryKYc2OxQNaydGbQuh3BVAbjjMHbeeOrhaGm1xGk-QW68IOCWQAJ~ovy3E5Ob61KlMP5GhT3l2jxb0my4Q0KMLCQutxYyYEPkI4rYTU9DCHn5FH77KcpHnjDXiRk6L0b8oxhMGWOj7ylUHCRlOa66prlT1mGaDSQaxXwyBbrMQT8XhnkTO9olpQPdJtxHhwPcux4nZy2C8F~j9BScowO5sDD2fmaLQOXs1PxK1o6mKra25QjEeQRbJL0H~1HLgSQGjf2l03ggCtVJediyjWR3r97ojRikwMT-PpQZU3Z1XDBcUUchoeqyeoW9eE_
echo "changelog_policy signature:"
echo "$(sign_policy changelog_policy)"
