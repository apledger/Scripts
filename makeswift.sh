#!/bin/bash

# Default directory is the current working directory
directory="$PWD"

# Function to display usage information
usage() {
    echo "Usage: $0 -n <name> [-d <directory>]"
    echo "  -n <name>: Required. Specifies the name."
    echo "  -d <directory>: Optional. Specifies the directory (default: current working directory)."
    exit 1
}

# Parse command line options
while getopts ":n:d:" opt; do
    case $opt in
        n)
            name="$OPTARG"
            ;;
        d)
            directory="$OPTARG"
            ;;
        \?)
            echo "Invalid option: -$OPTARG" >&2
            usage
            ;;
        :)
            echo "Option -$OPTARG requires an argument." >&2
            usage
            ;;
    esac
done

# Check if the name is provided
if [ -z "$name" ]; then
    echo "Error: The name is required."
    usage
fi


while getopts ":d:" opt; do
  case $opt in
    d)
      dir=$OPTARG
      ;;
  esac
done

mkdir $directory/components/$name

echo "import { Ref, forwardRef } from 'react'

export interface Props {
  className?: string
}

export const $name = forwardRef(function $name(
  { className }: Props,
  ref: Ref<HTMLDivElement>,
) {
  return (
    <div ref={ref} className={className}>
      $name
    </div>
  )
})" > $directory/components/$name/$name.tsx

echo "Created $directory/components/$name/$name.tsx"

echo "import dynamic from 'next/dynamic'

import { Style } from '@makeswift/runtime/controls'
import { forwardNextDynamicRef } from '@makeswift/runtime/next'

import { runtime } from '@/lib/makeswift/runtime'

export const props = {
  className: Style(),
}

runtime.registerComponent(
  forwardNextDynamicRef(patch =>
    dynamic(() => patch(import('./$name').then(({ $name }) => $name))),
  ),
  { type: '$name', label: '$name', props },
)" > $directory/components/$name/$name.makeswift.ts

echo "Created $directory/components/$name/$name.makeswift.ts"

echo "export * from './$name'" > $directory/components/$name/index.ts

echo "Created $directory/components/$name/index.ts"

# Add import path
file="$directory/lib/makeswift/components.ts"
echo "import '@/components/$name/$name.makeswift'" > .tmp
cat "$file" >> .tmp
sort -o .tmp .tmp
mv .tmp "$file"

echo "Registered component in $directory/lib/makeswift/components.ts"
