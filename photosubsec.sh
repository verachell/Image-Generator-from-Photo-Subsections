#!/bin/bash
# Creates a series of non-overlapping horizontal rectangular subsections from local JPG images in 
# the working directory. Also creates a series of circular png images suitable for profile image 
# placeholders. The resultant 2 new sets of images are placed into new directories.
# This script uses imagemagick, which is bundled by default into most linux installations.
# 
# USAGE: place this script in the same Linux working directory as your source image files. Ensure it
# has executable permissions. At the command line, type './photosubsec.sh' (without the quotes).
# No arguments are needed; the script will act on all images in the working directory which start
# with IMG and end with .jpg or .JPG.
#
# first create square and rectangular pics as needed
# This creates directories 'SUBSEC_horizontal' and 'SUBSEC_profile'; be aware that if these 
# already exist they may be overwritten

# start with horizontal rectangular images
mkdir -p SUBSEC_horizontal

# test if glob exists first
if compgen -G "IMG*.JPG" > /dev/null; then
for f in $(ls IMG*.JPG)
do
convert $f -strip -resize 2400x1600 -resize 2400x1600^ -crop 2400x1600+0+0 +repage -crop 600x400 +repage +adjoin SUBSEC_horizontal/$(basename -s .JPG $f).jpg
done
fi

# repeat for lowercase jpg extensions
if compgen -G "IMG*.jpg" > /dev/null; then
for f in $(ls IMG*.jpg)
do
convert $f -strip -resize 2400x1600 -resize 2400x1600^ -crop 2400x1600+0+0 +repage -crop 600x400 +repage +adjoin SUBSEC_horizontal/$(basename -s .jpg $f).jpg
done
fi


# next do circular pngs
mkdir -p SUBSEC_profile

# First make a circular mask, then crop to circle, as described in 
# https://stackoverflow.com/questions/41959355/how-can-i-combine-these-commands-to-achieve-circular-crop-in-imagemagick

# first generate mask:
convert -size 100x100 xc:Black -fill White -draw 'circle 50 50 50 1' -alpha Copy SUBSECprof_mask.png

# next generate square tiles in png format without the mask

if compgen -G "IMG*.JPG" > /dev/null; then
for f in $(ls IMG*.JPG)
do
convert $f -strip -resize 2400x1600 -resize 2400x1600^  -crop 2400x1600+0+0 +repage -crop 400x400 +repage +adjoin SUBSEC_profile/temp$(basename -s .JPG $f).png
done
fi

# repeat for lowercaes jpg extensions
if compgen -G "IMG*.jpg" > /dev/null; then
for f in $(ls IMG*.jpg)
do
convert $f -strip -resize 2400x1600 -resize 2400x1600^  -crop 2400x1600+0+0 +repage -crop 400x400 +repage +adjoin SUBSEC_profile/temp$(basename -s .jpg $f).png
done
fi

# apply mask to square tiles
for f in $(ls SUBSEC_profile/temp*.png)
do
convert $f -resize 100x100 SUBSECprof_mask.png -compose CopyOpacity -composite SUBSEC_profile/prof_$(basename -s .png $f).png
done

rm SUBSEC_profile/temp*
rm SUBSECprof_mask.png


