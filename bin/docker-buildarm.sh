#!/usr/bin/env bash

# https://github.com/rust-lang/cargo/issues/8719
#--buildkitd-flags '--allow-insecure-entitlement security.insecure' 
docker buildx build --load --platform "linux/arm/v7" -t $1 .
