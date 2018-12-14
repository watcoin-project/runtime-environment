#!/usr/bin/env bash
target=$1
image=$2

docker image inspect $image &>/dev/null
if [ "$?" != "0" ]
then
    (>&2 echo "Image $image not found")
    exit 1
fi

directory=$(mktemp -d)
file="$directory/$(echo $image | awk -F ':' '{print $1}')"

touch $file

echo "Creating image copy"
docker image save --output $file $image

echo "Copying image"
ssh $target "mkdir -p $directory"
scp -C $file $target:$file

echo "Extracting image"
ssh $target "docker image load --input $file"

echo "Removing remote copy"
ssh $target "rm $file && rmdir $directory"

echo "Removing local copy"
rm $file
rmdir $directory
