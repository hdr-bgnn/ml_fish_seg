#!/usr/bin/env Rscript

library( ANTsR )
library( ANTsRNet )
library(optparse)

option_list = list(
  make_option(c("-f", "--file"), type="character", 
              help="file name", metavar="character"),
  make_option(c("-o", "--output"), type="character",
              help="output file name", metavar="character"),
  make_option(c("-i", "--interp"), type="character", default = 'linear',
              help="interpolation type", metavar="character"),
  make_option(c("-s", "--size"), type="integer",
              help="image size", metavar="integer")
)

opt_parser = OptionParser(option_list=option_list);
opt = parse_args(opt_parser);

orig<-antsImageRead(opt$file)
reduced<-resampleImage(orig, c(opt$size, opt$size), useVoxels = TRUE, interpType = opt$interp)

antsImageWrite(reduced,filename=opt$output)