# Makefile
# For Linear Algebra by Jim Hefferon joshua.smcvt.edu/linearalgebra
# 2019-Oct-10 JH GPL 2

# SRC_DIR  Full path for src/
#  From http://timmurphy.org/2015/09/27/how-to-get-a-makefile-directory-path/
SRC_DIR := $(dir $(realpath $(firstword $(MAKEFILE_LIST))))

# TEXINPUTS
#  String giving location of .sty files, etc.
#  Note that because SRC_DIR ends with a slash, the slash here makes there
# be two slashes, which causes TeX to search all subdirs of SRC_DIR.  Note
# also that here the "$(TEXINPUTS)" refers to the environment variable.
TEXINPUTS := TEXINPUTS=$(SRC_DIR)/:$(TEXINPUTS)

# ASYMPTOTE_DIR
#  Asymptote uses this to look for config and imported files.
#  Note that because SRC_DIR ends with a slash, the slash here makes there
# be two slashes, which causes a search of all subdirs of SRC_DIR.   Note
# also that here the "$(ASYMPTOTE_DIR)" refers to the environment variable.
ASYMPTOTE_DIR := ASYMPTOTE_DIR=$(SRC_DIR)/asy//:$(SRC_DIR)/asy/asy-graphtheory-master/modules//:$(ASYMPTOTE_DIR)

# LaTeX compiler
LATEX := pdflatex

# LaTeX command line
#  The command line used to invoke LaTeX.  Set the environment, then call
# the program.
LATEX_CMD := $(TEXINPUTS) $(LATEX) 

# MetaPost environment variable
# (SRC_DIR has an ending /)
MPINPUTS := MPINPUTS=$(SRC_DIR)mp//:

# Metapost command line.
#   Metapost makes graphics. I used to use it exclusively but lately
# use Asymptote.  Still, there is a lot of MetaPost in here.
METAPOST_CMD := $(TEXINPUTS) $(MPINPUTS) mpost

# Asymptote command line.
# Asymptote to make graphics (newer and especially 3D graphics)
# Set the environment and then call the program.
# Options:
#   -nosafe gets around GhostScript error when using opacity:
#      https://github.com/vectorgraphics/asymptote/issues/77
#  -vv makes it talk more
ASYMPTOTE_CMD := $(TEXINPUTS) $(ASYMPTOTE_DIR) asy -nosafe -vv

# vpath %.tex src cover pref gr vs map det jc appen bib


.PHONY : all
all : book.pdf slides lab

# .PHONY : book
# book : book.pdf

book.pdf : book.tex cover pref gr vs map det jc appen bib
	$(LATEX_CMD) book.tex

# Cover and Preface
.PHONY : cover
cover : cover/covernew.tex cover/symlist.tex cover/titlepage.tex cover_asy

.PHONY : cover_asy
cover_asy : cover/asy/axes.pdf cover/asy/shadow.pdf

cover/asy/axes.pdf cover/asy/shadow.pdf : cover/asy/axes.asy 
	$(TEXINPUTS) $(ASYMPTOTE_DIR) \
        cd $(dir $@);\
        $(ASYMPTOTE_CMD) $(notdir $(basename $@)) 

.PHONY : pref
pref : pref/pref.tex

pref/pref.tex :

# Chapter One
#  Need to compile what is in gr/bin?
.PHONY : gr
gr : gr/*.tex gr_mp

.PHONY : gr_mp
gr_mp : gr/mp/ch1.1

gr/mp/ch1.1 : gr/mp/ch1.mp
	cd $(dir $@);\
	$(METAPOST_CMD) $(notdir $(basename $@)) 


# Chapter Two
.PHONY : vs
vs : vs/*.tex vs_mp

.PHONY : vs_mp
vs_mp : vs/mp/ch2.1 vs/mp/voting.1

vs/mp/ch2.1 : vs/mp/ch2.mp
	cd $(dir $@);\
        $(METAPOST_CMD)  $(notdir $(basename $@))

vs/mp/voting.1 : vs/mp/voting.mp
	cd $(dir $@);\
        $(METAPOST_CMD)  $(notdir $(basename $@))


# Chapter Three
#  Need to compile what is in map/bin?
.PHONY : map
map : map/*.tex map_mp

.PHONY : map_mp
map_mp : map/mp/ch3.1

map/mp/ch3.1 : map/mp/ch3.mp
	cd $(dir $@);\
        $(METAPOST_CMD)  $(notdir $(basename $@))


# Chapter Four
.PHONY : det
det : det/*.tex det_asy det_mp

.PHONY : det_asy
det_asy : det/asy/ppiped.pdf 

det/asy/ppiped.pdf : det/asy/ppiped.asy 
	cd $(dir $@);\
        $(ASYMPTOTE_CMD) $(notdir $(basename $@))

.PHONY : det_mp
det_mp : det/mp/ch4.1

det/mp/ch4.1 : det/mp/ch4.mp
	cd $(dir $@);\
        $(METAPOST_CMD)  $(notdir $(basename $@))


# Chapter Five
.PHONY : jc
jc : jc/*.tex jc_asy jc_mp

.PHONY : jc_asy
jc_asy : jc/asy/wilber.pdf

jc/asy/wilber.pdf : jc/asy/wilber.asy 
	cd $(dir $@);\
        $(ASYMPTOTE_CMD)  $(notdir $(basename $@))

.PHONY : jc_mp
jc_mp : jc/mp/ch5.1

jc/mp/ch5.1 : jc/mp/ch5.mp
	cd $(dir $@);\
        $(METAPOST_CMD)  $(notdir $(basename $@))


# Appendix and Bibliography
.PHONY : appen
appen: appen/appen.tex appen_asy

.PHONY : appen_asy
appen_asy: appen/mp/appen.1

appen/mp/appen.1 : appen/mp/appen.mp
	cd $(dir $@);\
        $(METAPOST_CMD)  $(notdir $(basename $@))

.PHONY : bib
bib : bib/bib.tex

bib/bib.tex :


# =============== Slides =====================

# Slides come in groups of three.  For instance, slides/one_i.pdf is the
# slide deck I use, where in some cases I substitute an example for a proof.
# And, slides/one_i_allproofs.pdf is the deck with the proofs put back in.
# Then, slides/one_i_handout.pdf is the deck with the \pause command
# turned off, for people to print out.
define compile-slides
  cd $(dir $@);\
  $(LATEX_CMD) $(notdir $(basename $@));\
  $(LATEX_CMD) $(notdir $(basename $@))_allproofs;\
  $(LATEX_CMD) $(notdir $(basename $@))_handout
endef

slides : slides_one slides_two slides_three slides_four slides_five zip_slides

# Slides for Chapter One
.PHONY : slides_one
slides_one : slides_one_asy slides/one/one_i.pdf slides/one/one_ii.pdf\
  slides/one/one_iii.pdf

.PHONY : slides_one_asy
slides_one_asy : slides/one/asy/one_ii_plane.pdf

slides/one/asy/one_ii_plane.pdf : slides/one/asy/one_ii_plane.asy
	cd $(dir $@);\
        $(ASYMPTOTE_CMD) $(notdir $(basename $@))

slides/one/one_i.pdf : slides/one/one_i.tex
	$(compile-slides)

slides/one/one_ii.pdf : slides/one/one_i.tex
	$(compile-slides)

slides/one/one_iii.pdf : slides/one/one_i.tex
	$(compile-slides)


# Slides for Chapter Two
.PHONY : slides_two
slides_two : slides_two_asy slides/two/two_i.pdf  \
  slides/two/two_i_a.pdf \
  slides/two/two_ii.pdf \
  slides/two/two_iii.pdf

.PHONY : slides_two_asy
slides_two_asy : slides/two/asy/p2_subspaces.pdf \
  slides/two/asy/two_i_a_plane.pdf \
  slides/two/asy/p2_subspaces_spans.pdf \
  slides/two/asy/two_i_line_slope_two.pdf \
  slides/two/asy/r3_subspaces.pdf \
  slides/two/asy/two_i_plane.pdf \
  slides/two/asy/r3_subspaces_spans.pdf \
  slides/two/asy/two_i_spanplane.pdf \
  slides/two/asy/two_i_a_line.pdf

slides/two/asy/%.pdf : slides/two/asy/%.asy
	cd $(dir $@);\
        $(ASYMPTOTE_CMD) $(notdir $(basename $@))

slides/two/%.pdf : slides/two/%.tex
	$(compile-slides)


# Slides for Chapter Three
.PHONY : slides_three
slides_three : slides_three_asy slides/three/three_i.pdf  \
  slides/three/three_ii.pdf \
  slides/three/three_ii_a.pdf \
  slides/three/three_iii.pdf \
  slides/three/three_iv.pdf \
  slides/three/three_v.pdf \
  slides/three/three_vi.pdf

.PHONY : slides_three_asy
slides_three_asy : slides/three/asy/three_ii_3dproj1.pdf \
  slides/three/asy/three_ii_3dproj2.pdf \
  slides/three/asy/three_ii_3dproj3.pdf \
  slides/three/asy/three_ii_dims.pdf \
  slides/three/asy/three_ii_inv_img00.pdf \
  # slides/three/asy/three_ii_inv_img01.pdf \
  # slides/three/asy/three_ii_inv_img02.pdf \
  # slides/three/asy/three_ii_inv_img03.pdf \
  # slides/three/asy/three_ii_inv_img04.pdf \
  # slides/three/asy/three_ii_inv_img05.pdf \
  # slides/three/asy/three_ii_inv_img06.pdf \
  slides/three/asy/three_ii_kernel.pdf \
  slides/three/asy/three_ii_proj_2d00.pdf \
  # slides/three/asy/three_ii_proj_2d01.pdf \
  # slides/three/asy/three_ii_proj_2d02.pdf \
  # slides/three/asy/three_ii_proj_2d03.pdf \
  # slides/three/asy/three_ii_proj_2d04.pdf \
  # slides/three/asy/three_ii_proj_2d05.pdf \
  # slides/three/asy/three_ii_proj_2d06.pdf \
  slides/three/asy/three_ii_rotate_basis.pdf \
  slides/three/asy/three_ii_rotate_prod_after.pdf \
  slides/three/asy/three_ii_rotate_prod_before.pdf \
  slides/three/asy/three_ii_rotate_sum_after.pdf \
  slides/three/asy/three_ii_rotate_sum_before.pdf \
  slides/three/asy/three_i_line.pdf \
  slides/three/asy/three_i_plane.pdf \
  slides/three/asy/three_vi_2dmutuallyortho.pdf \
  slides/three/asy/three_vi_3dgramschmidt0.pdf \
  slides/three/asy/three_vi_3dgramschmidt1.pdf \
  slides/three/asy/three_vi_3dprojtoline.pdf 

slides/three/asy/three_ii_inv_img00.pdf : slides/three/asy/three_ii_inv_img.asy 
	cd $(dir $<);\
        $(ASYMPTOTE_CMD) $(notdir $(basename $<))

slides/three/asy/three_ii_proj_2d00.pdf : slides/three/asy/three_ii_proj_2d.asy 
	cd $(dir $<);\
        $(ASYMPTOTE_CMD) $(notdir $(basename $<))

slides/three/asy/%.pdf : slides/three/asy/%.asy
	cd $(dir $@);\
        $(ASYMPTOTE_CMD) $(notdir $(basename $@))

slides/three/%.pdf : slides/three/%.tex
	$(compile-slides)


# Slides for Chapter Four
.PHONY : slides_four
slides_four : slides_four_asy \
  slides/four/four_i.pdf \
  slides/four/four_ii.pdf \
  slides/four/four_iii.pdf 

.PHONY : slides_four_asy
slides_four_asy : slides/four/asy/four_ii_2dtransedsizea.pdf \
  slides/four/asy/four_ii_2dtransedsizeb.pdf \
  slides/four/asy/four_ii_negvolbox.pdf \
  slides/four/asy/four_ii_orientation_neg0.pdf \
  # slides/four/asy/four_ii_orientation_neg10.pdf \
  # slides/four/asy/four_ii_orientation_neg1.pdf \
  # slides/four/asy/four_ii_orientation_neg2.pdf \
  # slides/four/asy/four_ii_orientation_neg3.pdf \
  # slides/four/asy/four_ii_orientation_neg4.pdf \
  # slides/four/asy/four_ii_orientation_neg5.pdf \
  # slides/four/asy/four_ii_orientation_neg6.pdf \
  # slides/four/asy/four_ii_orientation_neg7.pdf \
  # slides/four/asy/four_ii_orientation_neg8.pdf \
  # slides/four/asy/four_ii_orientation_neg9.pdf \
  slides/four/asy/four_ii_orientation.pdf \
  slides/four/asy/four_ii_orientation_pos.pdf

slides/four/asy/four_ii_orientation_neg0.pdf : slides/four/asy/four_ii_orientation_neg.asy 
	cd $(dir $<);\
        $(ASYMPTOTE_CMD) $(notdir $(basename $<))

slides/four/asy/%.pdf : slides/four/asy/%.asy
	cd $(dir $@);\
        $(ASYMPTOTE_CMD) $(notdir $(basename $@))

slides/four/%.pdf : slides/four/%.tex
	$(compile-slides)


# Slides for Chapter Five
.PHONY : slides_five
slides_five : slides_five_asy \
  slides/five/five_i.pdf \
  slides/five/five_ii.pdf \
  slides/five/five_ii_a.pdf 

# .PHONY : slides_five_asy
# slides_five_asy :

# slides/five/asy/%.pdf : slides/five/asy/%.asy
# 	cd $(dir $@);\
#         $(ASYMPTOTE_CMD) $(notdir $(basename $@))

slides/five/%.pdf : slides/five/%.tex
	$(compile-slides)



default :
	@echo $(ASYMPTOTE_DIR)
	@echo $(TEXINPUTS)




# book.pdf: cover symlist pref gr vs map det jc appen bib

# gr: gr1.tex gr2.tex gr3.tex cas.tex leontief.tex ppivot.tex network.tex
