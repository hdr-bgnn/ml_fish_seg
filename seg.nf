#!/usr/bin/env nextflow

params.fish_dir = "$baseDir/fish_segmentations"
modelfn = '$baseDir/models/augmented_unet.h5'

imagesCh = Channel
                .fromPath("${params.fish_dir}/*jpg",type:'file')
                .map { file -> tuple(file.baseName, file) }

segCh = Channel
                .fromPath("${params.fish_dir}/*nii.gz",type:'file')
                .map { file -> tuple(file.baseName, file) }                
                
process resize {
    tag "$filebasename"
 
    input:
    set filebasename, file(img) from imagesCh
    file resizeScript from file("resize.R")

    output:
    set filebasename, file("${filebasename}.nii") into re_img_channel

    script:
    """
    Rscript $resizeScript --file $img --size 256 --output ${filebasename}.nii --interp linear
    """
}

process resizeSegs {
    tag "$filebasename"
 
    input:
    set filebasename, file(img) from segCh
    file resizeScript from file("resize.R")

    output:
    set filebasename, file("${filebasename}") into re_seg_channel

    script:
    """
    Rscript $resizeScript --file $img --size 256 --output ${filebasename} --interp nearestNeighbor
    """
}