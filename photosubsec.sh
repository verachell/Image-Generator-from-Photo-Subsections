#!/bin/bash
# Creates a series of non-overlapping horizontal rectangular subsections from local JPG images
# beginning with IMG in the working directory. Also creates a series of circular png images suitable 
# for profile image placeholders. The resultant 2 new sets of images are placed into new directories.
# This script uses imagemagick. If you do not have imagemagick (check via 'man convert') then install
# it via your linux package manager.
# 
# USAGE: place this script in the same Linux working directory as your source image files. Ensure it
# has executable permissions. At the command line, type './photosubsec.sh' (without the quotes).
# No arguments are needed; the script will act on all images in the working directory which start
# with IMG and end with .jpg or .JPG.
#
# first create square and rectangular pics as needed
# This creates directories 'SUBSEC-horizontal' and 'SUBSEC-profile'; be aware that if these 
# already exist they may be overwritten

# start with horizontal rectangular images
somefiles=false
echo -n "Creating horizontal images from each pic"
mkdir -p SUBSEC-horizontal

# test if glob exists first
if compgen -G "IMG*.JPG" > /dev/null; then
somefiles=true
for f in $(ls IMG*.JPG)
do
echo -n "."
convert $f -strip -resize 2400x1600 -resize 2400x1600^ -crop 2400x1600+0+0 +repage -crop 600x400 +repage +adjoin SUBSEC-horizontal/$(basename -s .JPG $f).jpg
done
fi

# repeat for lowercase jpg extensions
if compgen -G "IMG*.jpg" > /dev/null; then
somefiles=true
for f in $(ls IMG*.jpg)
do
echo -n "."
convert $f -strip -resize 2400x1600 -resize 2400x1600^ -crop 2400x1600+0+0 +repage -crop 600x400 +repage +adjoin SUBSEC-horizontal/$(basename -s .jpg $f).jpg
done
fi

if $somefiles; then
# next do circular pngs
mkdir -p SUBSEC-profile

# First make a circular mask, then crop to circle, as described in 
# https://stackoverflow.com/questions/41959355/how-can-i-combine-these-commands-to-achieve-circular-crop-in-imagemagick

# first generate mask:
convert -size 100x100 xc:Black -fill White -draw 'circle 50 50 50 1' -alpha Copy SUBSECprof_mask.png

# next generate square tiles in png format without the mask
echo " "
echo -n "Getting images ready for profile sections - this takes longer"

if compgen -G "IMG*.JPG" > /dev/null; then
for f in $(ls IMG*.JPG)
do
echo -n "."
convert $f -strip -resize 2400x1600 -resize 2400x1600^  -crop 2400x1600+0+0 +repage -crop 400x400 +repage +adjoin SUBSEC-profile/sqsubsec$(basename -s .JPG $f).png
done
fi

# repeat for lowercase jpg extensions
if compgen -G "IMG*.jpg" > /dev/null; then
for f in $(ls IMG*.jpg)
do
echo -n "."
convert $f -strip -resize 2400x1600 -resize 2400x1600^  -crop 2400x1600+0+0 +repage -crop 400x400 +repage +adjoin SUBSEC-profile/sqsubsec$(basename -s .jpg $f).png
done
fi

echo ""
echo -n "Making circular profile images"
# apply circular mask to square tiles
for f in $(ls SUBSEC-profile/sqsubsec*.png)
do
echo -n "."
convert $f -resize 100x100 SUBSECprof_mask.png -compose CopyOpacity -composite SUBSEC-profile/prof-$(basename -s .png $f).png
done

echo ""
echo "Cleaning up"
rm SUBSEC-profile/sqsubsec*
rm SUBSECprof_mask.png

# this next bit is not essential - it simply replaces the underscore character '_' with the minus sign
# character '-'  in the generated photo filenames. This feature is provided to ensure the resultant 
# photo filenames are compatible for use in YeetWords. If you are not subsequently using these files in
# YeetWords, it won't matter whether or not you execute the final statements.
rename 'y/_/-/' SUBSEC-horizontal/*.jpg
rename 'y/_/-/' SUBSEC-profile/*.png
echo "Done"
else
echo ""
echo "Unable to proceed. Did not find any jpg files starting with IMG"
fi


