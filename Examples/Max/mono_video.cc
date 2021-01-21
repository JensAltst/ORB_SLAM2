/**
* This file is part of ORB-SLAM2.
*
* Copyright (C) 2014-2016 Raúl Mur-Artal <raulmur at unizar dot es> (University of Zaragoza)
* For more information see <https://github.com/raulmur/ORB_SLAM2>
*
* ORB-SLAM2 is free software: you can redistribute it and/or modify
* it under the terms of the GNU General Public License as published by
* the Free Software Foundation, either version 3 of the License, or
* (at your option) any later version.
*
* ORB-SLAM2 is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
* GNU General Public License for more details.
*
* You should have received a copy of the GNU General Public License
* along with ORB-SLAM2. If not, see <http://www.gnu.org/licenses/>.
*/

#include <iostream>
#include <algorithm>
#include <fstream>
#include <chrono>

#include <opencv2/core/core.hpp>

#include <opencv2/opencv.hpp>

#include "System.h"

// #include<Nav.h>

using namespace std;

string vocabularyPath, settingsPath, sequencePath;
bool saveMap;

ORB_SLAM2::System *System;

// ORB_SLAM2::Nav nav;

enum NavState
{
    IDLE,
    EXPLORE,
    POI,
    LOC
};
NavState state;

int runSLAM();

int main(int argc, char **argv)
{
    if (argc != 5)
    {
        cerr << endl
             << "Usage: ./mono_tum path_to_vocabulary path_to_settings path_to_sequence [1|0](save map?)" << endl;
        return 1;
    }

    vocabularyPath = argv[1];
    settingsPath = argv[2];
    sequencePath = argv[3];
    //sequencePath = "http://192.168.178.69:4747/video";
    saveMap = (bool)atoi(argv[4]);

    bool bUpdateMap = (int)atoi(argv[4]);
    // Create SLAM system. It initializes all system threads and gets ready to process frames.
    ORB_SLAM2::System SLAM(vocabularyPath, settingsPath, ORB_SLAM2::System::MONOCULAR, true);//, bUpdateMap);
                        //SLAM(argv[1],argv[2],ORB_SLAM2::System::MONOCULAR,true);

    System = &SLAM;

    runSLAM();

    //Localisation
    //SLAM.ActivateLocalizationMode();
    //System->ActivateLocalizationMode();

    SLAM.Shutdown();
    SLAM.SaveKeyFrameTrajectoryTUM("KeyFrameTrajectory.txt");

    return 0;
}

int runSLAM()
{

    // Retrieve paths to images
    cv::VideoCapture cap(sequencePath);
    //cv::VideoCapture cap(0);

    if (!cap.isOpened())
    {
        cerr << endl
             << "Could not open camera feed." << endl;
        return -1;
    }

    // Code that could throw an exception

    // Main loop
    int timeStamps = 0;
    for (;; timeStamps++)
    {
        //Create a new Mat
        cv::Mat frame;

        //Send the captured frame to the new Mat
        cap >> frame;

        if (frame.empty())
        {
            // reach to the end of the video file
            break;
        }

        // Pass the image to the SLAM system
        System->TrackMonocular(frame, timeStamps);
    }
    return 0;
}
