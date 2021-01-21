#!/bin/bash

#if you can't run this skript please do chmod +x testOrbslam.sh to make it executable
#"Usage: ./mono_tum path_to_vocabulary path_to_settings path_to_sequence "
#"Usage for Videos: ./mono_video path_to_vocabulary path_to_settings path_to_video"
#Please try diffrent yaml files if you dont get the desired results there are some more in the Examples/Max folder use the ASUS.yaml as baseline

orblsamfolder="../../../ORB_SLAM2/"

mono="Examples/Monocular/mono_tum"
vocabulary="Vocabulary/ORBvoc.txt"
yaml="Examples/Monocular/TUM1.yaml"

pathDataset="Personal_scripts/Test/Datasets/"
dataset="rgbd_dataset_freiburg1_xyz"

cd $orblsamfolder

$mono $vocabulary $yaml $pathDataset$dataset


#for videos use the provided mono_video and use a mp4 as dataset
