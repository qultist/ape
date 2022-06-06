#!/bin/sh

# Prerequisite
HOMEBREW_NO_AUTO_UPDATE=1 brew install gpg

# Download and verify codecov uploader
# See: https://docs.codecov.com/docs/codecov-uploader#integrity-checking-the-uploader

curl https://keybase.io/codecovsecurity/pgp_keys.asc | gpg --no-default-keyring --keyring trustedkeys.gpg --import # One-time step

curl -Os https://uploader.codecov.io/latest/macos/codecov

curl -Os https://uploader.codecov.io/latest/macos/codecov.SHA256SUM

curl -Os https://uploader.codecov.io/latest/macos/codecov.SHA256SUM.sig

gpgv codecov.SHA256SUM.sig codecov.SHA256SUM

shasum -a 256 -c codecov.SHA256SUM

chmod +x codecov