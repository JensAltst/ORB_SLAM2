#!/bin/bash

#This script will download a sample dataset if no Dataset directory was found
#For use with your own datasets you can remove this if clause
if [ ! -d ./Datasets/ ];then
    echo "Dataset directory not found, creating directory and downloading sample dataset this may take a few minutes"
    echo "-----------------------------------"
    mkdir Datasets
    cd Datasets
    wget https://vision.in.tum.de/rgbd/dataset/freiburg1/rgbd_dataset_freiburg1_xyz.tgz
    echo "-----------------------------------"
    echo "Unpacking..."
    tar zxvf rgbd_dataset_freiburg1_xyz.tgz
    cd ..
    echo "Done"
fi

#if you can't run this skript please do chmod +x testOrbslam.sh to make it executable
#"Usage: ./mono_tum path_to_vocabulary path_to_settings path_to_sequence "
#"Usage for Videos: ./mono_video path_to_vocabulary path_to_settings path_to_video"
#Please try diffrent yaml files if you dont get the desired results there are some more in the Examples/Max folder use the ASUS.yaml as baseline
#Please download a dataset from http://vision.in.tum.de/data/datasets/rgbd-dataset/download or provide your own dataset/video

orblsamfolder="../../../ORB_SLAM2/"

mono="Examples/Monocular/mono_tum"
vocabulary="Vocabulary/ORBvoc.txt"
yaml="Examples/Monocular/TUM1.yaml"

pathDataset="Personal_scripts/Test/Datasets/"
dataset="rgbd_dataset_freiburg1_xyz"

cd $orblsamfolder

$mono $vocabulary $yaml $pathDataset$dataset


#for videos use the provided mono_video and use a mp4 as dataset
