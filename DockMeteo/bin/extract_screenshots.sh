#!/bin/bash

for f in fastlane/screenshots/en-US/*.png; do
  magick -extract 800x800+240+0 "$f" -resize 50% $(basename "$f")
done