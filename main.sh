#!/bin/bash

for app in /Applications/*.app; do
    framework_dir="$app/Contents/Frameworks"
    if [ -d "$framework_dir" ]; then
        for item in "$framework_dir"/*; do
            item_name=$(basename "$item")
            # echo $item_name
            if [[ "$item_name" == *"Electron"* ]]; then
                echo "$app"
                break
            fi
        done
    fi
done
