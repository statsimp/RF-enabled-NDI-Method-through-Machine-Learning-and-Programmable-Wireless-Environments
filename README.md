# RF-enabled-NDI-Method-through-Machine-Learning-and-Programmable-Wireless-Environments
This repository corresponds to the needed codes for realizing the results displayed in our paper, titled: "A novel RF-enabled Non-Destructive Inspection Method through Machine Learning and Programmable Wireless Environments". 

## Blender Scripts
This directory contains the scripts that correspond to the morphing of thwe work. Here, the script that enables the shaping of one object to another is stored, while neccesitating the BLENDER software. 

## Matlab_Code
Here lie the core corpus of the proposed work. In particular, the scripts that realize the RF-enabled NDI pipeline are stored here. This contains functionalities that relate to:

i) the similarity aspect of the RF-signals and industrial assets, ii) the generation of the PWE graph, iii) the ray-tracing and routing steps, and iv) the post-processing of the RF-wavefronts.

## ML_NDI
In this directory lie the scripts that realize the machine learning aspect of the work. Specifically, we use the pix2pix GAN model which allows for the transformation of an input image to an output image.

The goal of the NDI work is to realize the creation of a digital twin visualization (output image), based on an input image. To achieve that we use an intermediate modality transformation which translates the RF wavefront info to an equivalent "RF-pixel" representation (input image).
