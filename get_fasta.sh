#!/bin/bash
get_fasta () {
	curl "https://www.rcsb.org/pdb/download/downloadFastaFiles.do?structureIdList=$1&compressionType=uncompressed" > $(echo $1 | sed "s/\.pdb//g").fasta
}

