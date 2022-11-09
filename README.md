# Image-Generator-from-Photo-Subsections
From one or more of your local photos, obtains subsections from each photo giving a range of circular png images and horizontal rectangular jpg images

This is a shell script specific to bash. It creates a series of non-overlapping horizontal rectangular subsections from local JPG images in the working directory. In addition it creates a series of circular png images suitable for profile image placeholders. The resultant 2 new sets of images are placed into new directories. This script uses imagemagick, which is bundled by default into most linux installations.

## Typical use case
The typical use case is for those who want to generate a series of random images that are intermediate between single color images and regular photos. These are perfect for quick mock-ups or as a source of images for generative fiction.

## Usage
All you need is the shell script from this repository (photosubsec.sh) and your own image file(s) - as many or as few as you want, whose filenames start with IMG and end with .JPG or .jpg. The remainder of this repository are example input and output images.

To use, place this script in the same Linux working directory as your source image files. Ensure the script has executable permissions. At the command line, type './photosubsec.sh' (without the quotes). No arguments are needed; the script will act on all images in the working directory which start with IMG and end with .jpg or .JPG

This creates directories 'SUBSEC_horizontal' and 'SUBSEC_profile'; be aware that if these  already exist inside your working directory they may be overwritten. Your horizontal jpgs will be placed in SUBSEC_horizontal and the circular png's suitable for profile images will be in SUBSEC_profile.

### Ability to use your own images
This script uses whatever images you have in the working directory where you're running this script. (Note: it actually uses images that start with IMG and end with .jpg or .JPG since that's how most camera images are formatted - of course, you can adjust the script to your own needs). The advantage of using your own images is that you then don't need to find how to credit the photographer, and also you have original images that no-one else has.

## Example input and output
This repository shows example input and output. The 3 

## Limitations and caveats 
Source images are best suited when they are in landscape format and approximately 2400x1600 but the script works well on other sizes and aspect ratios. Do not worry about not having the exact size or the aspect ratio; this is all taken care of by the script. It will still work with images other than the recommended size or different aspect ratios, but in those situations be aware some parts of your source photo that will never get used (on the right and on the bottom) and/or there will be some lossiness in the resultant new images (originals remain unmodified). The degree of lossiness you experience is proportional to how far your dimensions and aspect ratios are from 2400x1600.

## Things to know if you plan on modifying this script
This script is particularly well suited to modification for other purposes and other use cases, for example output of other dimensions of image, and/or image processing to allow for artistic effects. 

If modifying this script, be aware that the tiling process (i.e. cropping with adjoin) is best with an exactly divisible number of the desired cropped tile size versus the whole image as resized in the script (here 2400x1600). The script as written ensures an exactly divisible number, but if you are modifying dimensions please pay attention to this issue. This will still work with a non-divisible tile size, but  some tiles (those from the edges of the image) will be smaller in one or both x/y dimensions than your specified size, since those are the leftover slivers that don't add up to a full tile unit. So aim for exact divisibility of tile units. This is only an issue if you plan on modifying the script.
