#!/bin/bash
# make_slides.sh
#  On Linux build the beamer slides for Linear Algebra by Jim Hefferon
# See http://joshua.smcvt.edu/linearalgebra .
#
# Run with 
#  cd linear-algebra/slides
#  ./make_slides.sh 2>&1 | tee make_slides.log
# (you may need to put in "chmod u+x ./make_slides.sh" the first time).
# Warning: running this script takes minutes, not seconds.  Perhaps 10 mins.
# In particular, "asy -f png four_ii_orientation_neg" takes a long time.
#
# 2012-Jun-15 Jim Hefferon
# 2017-Nov-10 Small adjustments so version three will compile from the .git

usage()
{
cat << EOF
usage: $0 options

Generate slides associated with Linear Algebra for inclass use.

OPTIONS:
   -h      Show this message
   -r      Regenerating; don't run asy, etc. (used for development)
   -v      Verbose
EOF
}

REGENERATING=
ONE=
TWO=
THREE=
FOUR=
FIVE=
VERBOSE=
while getopts “hrv12345” OPTION
do
     case $OPTION in
         h)
             usage
             exit 1
             ;;
         r)
             REGENERATING=1
             ;;
         1)
             ONE=1
             # exit 1
             ;;
         2)
             TWO=1
             ;;
         3)
             THREE=1
             ;;
         4)
             FOUR=1
             ;;
         5)
             FIVE=1
             ;;
         v)
             VERBOSE=1
             ;;
         ?)
             usage
             exit
             ;;
     esac
done

# Generate the figures
if [[ -z $REGENERATING ]] 
then
  echo " Regenerating ..  "
  echo "   This regenerates all the graphics and then runs LaTeX a number of"
  echo "   times.  On my laptop it takes two minutes.  Also, a lot of stuff"
  echo "   flies by on the screen."
  echo " "
  echo " "
  # Make the graphics
  cd asy

  # Create all the graphics that will be .pdf files
  echo "================="
  echo " creating pdf graphics with Asymptote; some of these take a while"
  echo "================="
  declare -a pdf_out_files=("three_ii_kernel" "three_ii_rotate" "three_ii_proj1" "three_ii_proj2" "three_ii_proj3" "three_ii_proj5" "three_vi_2dmutuallyortho" "three_iii_cosets" "four_ii_2dtransedsize0" "four_ii_2dtransedsize1")
  cmd="asy -f pdf filename"  # will substitute for "filename"

  for i in ${pdf_out_files[@]}
  do
     result=${cmd//filename/$i}
     # echo $i
     echo $result
     eval $result
  done

  # pdf's without 3d manipulatable
  declare -a pdf_out_files=("two_i_plane" "two_i_line_slope_two" "r3_subspaces" "r3_subspaces_spans" "p2_subspaces" "p2_subspaces_spans" "two_i_a_line" "two_i_a_plane" "three_i_line" "three_i_plane" "three_ii_kernel" "three_ii_proj_2d" "three_ii_rotate_basis" "three_ii_rotate_sum_before" "three_ii_rotate_sum_after" "three_ii_rotate_prod_before" "three_ii_rotate_prod_after" "three_ii_3dproj1" "three_ii_3dproj2" "three_ii_3dproj3" "three_ii_dims" "three_ii_inv_img" "three_ii_proj_2d" "three_vi_3dprojtoline" "three_vi_3dgramschmidt0" "three_vi_3dgramschmidt1" "four_ii_orientation"  "four_ii_orientation_pos" "four_ii_orientation_neg four_ii_negvolbox")
  cmd="asy -f pdf filename"  # will substitute for "filename"

  for i in ${pdf_out_files[@]}
  do
     result=${cmd//filename/$i}
     # echo $i
     echo $result
     eval $result
  done
  cd ..

  # Create the graphics for the optional slides.
  echo ".. create graphics for optional slides (can take minutes)"
  sage ./three_ii_a.sage 
  sage ./five_ii_a.sage
  cd graphics
  ./fix_pdf_error.sh
  cd ..
 
  # # Create all the graphics that will be .png files
  # echo "================="
  # echo " creating png graphics with Asymptote"
  # echo "   (some of these take minutes for a single file to compile)"
  # echo "================="
  # declare -a png_out_files=("three_ii_3dproj1" "three_ii_3dproj2" "three_ii_3dproj3" "three_ii_dims" "three_vi_3dprojtoline" "three_vi_3dgramschmidt0" "three_vi_3dgramschmidt1" "four_ii_orientation" "four_ii_orientation_pos" "four_ii_orientation_neg")
  # cmd="asy -f png filename"  # will substitute for "filename"

  # for i in ${png_out_files[@]}
  # do
  #    result=${cmd//filename/$i}
  #    # echo $i
  #    echo $result
  #    eval $result
  # done

  # Done making the graphics
fi


# Make the slides
echo "================="
echo " creating beamer slides with pdflatex"
echo "================="
one_files=(one_*.tex)
two_files=(two_*.tex)
three_files=(three_*.tex)
four_files=(four_*.tex)
five_files=(five_*.tex)

if [[ $ONE ]] 
then
  beamer_files="${one_files[@]}"
elif [[ $TWO ]] 
then
  beamer_files="${two_files[@]}"
elif [[ $THREE ]] 
then
  beamer_files="${three_files[@]}"
elif [[ $FOUR ]] 
then
  beamer_files="${four_files[@]}"
elif [[ $FIVE ]] 
then
  beamer_files="${five_files[@]}"
else
  beamer_files=("${one_files[@]}" "${two_files[@]}" "${three_files[@]}" "${four_files[@]}" "${five_files[@]}" )
fi

# ----  create .pdf files that may skip some proofs in favor of more examples
cmd="pdflatex filename"  # will substitute for "filename"

for i in ${beamer_files[@]}
do
   result=${cmd//filename/$i}
   echo $i
   echo $result
   eval $result
done

# ------- create .pdf files that include all proofs
# to see the expansions: set -xv
cmd="pdflatex -jobname filename_allproofs \"\def\includeallproofs{1} \input{filename}\""  # will substitute for "filename"

for i in ${beamer_files[@]}
do
   jn=${i%.tex}
   result=${cmd//filename/$jn}
   echo $jn
   echo $result
   eval $result
done


# ------- create handout versions of the slides, without \pause's
cmd="pdflatex filename"  # will substitute for "filename"

for i in ${beamer_files[@]}
do
   fn_without_ext=${i:0:(-4)}
   handout_fn=${fn_without_ext}_handout.tex
   awk -f handout.awk $i > ${handout_fn}
   result=${cmd//filename/${handout_fn}}
   echo $i
   echo $result
   eval $result
# clear out so *.tex wont find on next run
   rm ${handout_fn}  
done

# create .zip files
# Make .zip fo slides without all proofs
rm slides.zip
find . -iregex "./[^a].*_.*[^[_allproofs]\.pdf" -print | zip slides -@
# Make .zip of slides with all proofs
rm slides_allproofs.zip
find . -iregex "./[^a].*_.*_allproofs\.pdf" -print | zip slides_allproofs -@
# Make .zip of slides for handout, without any \pause's
rm slides_handout.zip
find . -iregex "./[^a].*_.*_handout\.pdf" -print | zip slides_handout -@

echo " -- Done --"
exit
