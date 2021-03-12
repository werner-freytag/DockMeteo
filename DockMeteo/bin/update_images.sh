#!/bin/bash

for dir in Assets.xcassets/*.imageset; do
  for weather in Clear FewClouds ScatteredClouds BrokenClouds ShowerRain Rain Thunderstorm Snow Mist Placeholder; do
    for daytime in "" "_Night"; do
      for size in "" "@2x"; do
        file=$dir/$weather$daytime$size.png
        target=Assets.xcassets/$weather$daytime.imageset
        if [ -f $file ]; then
          mv $file $target/
        fi
      done
    done
  done
done