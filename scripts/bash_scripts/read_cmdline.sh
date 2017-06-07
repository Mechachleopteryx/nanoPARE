#!/bin/bash

######################
# HELP DOCUMENTATION #
######################

function usage() {
cat <<HELP

############
# ENDGRAPH #
############
Usage: bash endGraph.sh [options] -5 <bedgraph_plus> <bedgraph_minus> -B <bedgraph> [<bedgraph_minus>]

This program interprets RNA-seq data from  transcript start site (TSS)
or transcript end site (TES) data by modeling it against a background of gene body RNA-seq reads.

Arguments:
-5 | --tss | --5p    Paths to two BEDGRAPH files of 5' end reads on both strands of the reference genome
-3 | --tes | --3p    Paths to two BEDGRAPH files of 3' end reads on both strands of the reference genome
-B | --body | --neg  Path(s) to BEDGRAPH file(s) of locations of gene body reads (on both strands) of the reference genome
-G | --genome        FASTA file of the reference genome
-A | --annotation    GFF file of gene annotations
-I | --iter          Number of iterations of optimization (default = 5)
-K | --kernel        Kernel function (default = laplace; options: laplace, normal, flat, triangle)
-S | --setup         If true, performs full environment setup (default = true)
--lmod               Load required modules with Lmod

Each of the above files is required to run Bookend. By default, each option points to an item in the resources directory:
    -5 resources/TSS_plus.bedgraph resources/TSS_minus.bedgraph
    -3 resources/TSS_plus.bedgraph resources/TSS_minus.bedgraph
    -B resources/BODY_plus.bedgraph resources/BODY_minus.bedgraph
    -G resources/genome.fasta
    -A resources/annotation.gff
Either replace the items in this directory with the appropriate files or point to another location.

HELP
}


############################
# READING THE COMMAND LINE #
############################

while [ "$1" != "" ]; do
    case $1 in
    -h | --help )               usage; exit 1
                                ;;
    -5 | --tss | --5p )         shift; TSS_PLUS=$1; shift; TSS_MINUS=$1 
                                ;;
    -3 | --tes | --3p )         shift; TES_PLUS=$1; shift; TES_MINUS=$1 
                                ;;
    -B | --body | --neg )       shift; BODY_PLUS=$1; if [ "${$2:0:1}" == "-" ]; then shift; BODY_MINUS=$1; fi 
                                ;;
    -G | --genome )             shift; genome_fasta=$1
                                ;;
    -A | --annotation )         shift; annotation_gff=$1
                                ;;
    --lmod )                    LMOD=1
                                ;;
    -I | --iter )               shift; ITERATIONS=$1
                                ;;
    -K | --kernel )             shift; KERNEL=$1
                                ;;
    * )                         echo "Argument not recognized."; usage; exit 1
                                ;;
    esac
    shift
done
