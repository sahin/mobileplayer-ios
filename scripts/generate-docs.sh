#!/bin/sh

bundle exec jazzy \
  --clean \
  --author MobilePlayer \
  --author_url https://mobileplayer.io \
  --github_url https://github.com/mobileplayer/mobileplayer-ios \
  --module-version 1.2.0 \
  --xcodebuild-arguments -scheme,MobilePlayer \
  --module MobilePlayer \
  --output Documentation
