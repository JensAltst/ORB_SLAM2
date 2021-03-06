debug="false"
#If debugging is set to true git clone and build commands will be skipped
debugging (){
if [ "$debug" = "false" ];then
	$* >&2
else
	echo >&2 "Skipped a step with Debug-mode!"
	echo >&2 "--> $*"
fi
}
################################################################################
#
#	This script installs all dependencies for OrbSlam2
#	Packages:
#		build-essential git cmake c++11 libgl1-mesa-dev glew-utils 
#		libglew-dev Libpython2.7-dev libgtk2.0-dev pkg-config  
#		libavcodec-dev libavformat-dev libswscale-dev
#		[Cmake V 3.16.3]
#		[C++11 V 9.3.0]
#	Repos:
#		Pangolin [Newest version as of 25.Oktober2020]
#		OpenCV [Newer versions didn't work for me (V 3.4.0)]
#		Eigen3 [Newest version as of 25.Oktober2020 (V 3.90)]
#
#
################################################################################

## Start of functions

#Installs packages but skips packages that are already installed
# var="pkg1 pkg2"
# Package_Installer  $var
Package_Installer (){
	for package in $*
	do
		dpkg -s "$package" >/dev/null 2>&1 && {
			echo "$package is installed"
		} || {
			sudo apt-get -y install $package
		}
	done
}

#Can be used as a boolean in if-statements or directly for single commands
# confirm=$( Confirm_Choice )
# if [ "$confirm" = "true" ]; then ... fi
# Confirm_Choice echo "Hello"
# >$[Y/N]: y
# >$ Hello
Confirm_Choice(){
	retval=""
	while true
	do
		read -r -p "[Y/N]:" input
		
		case $input in
			[yY][eE][sS]|[yY])
		retval="true"
		$* >&2
		break
		;;
			[nN][oO]|[nN])
		retval="false"
		echo >&2 "Skipping following command: $*"
		break
		;;
			*)
		echo >&2 "Invalid input asking again..."
		;;
		esac
	done
	echo "$retval"
}

## End of functions


## "Main" start


echo "Starting Orbslam setup."

echo "Updating and installing essential packages"

sudo apt-get update


#required packages
req_pkg="build-essential git cmake"

#checking if req_pkg are installed if yes skip
Package_Installer $req_pkg


## Might try and install c++11 if there is a newer version installed
## I only check against a string
#checking if gcc/g++ is installed if yes skip
gcc_v=$(dpkg-query --showformat='${Version}\n' --show gcc)
gpp_v=$(dpkg-query --showformat='${Version}\n' --show g++)
compiler="4:9.3.0-1ubuntu2"


if [ "$gcc_v" = "$compiler" ] && [ "$gpp_v" = "$compiler" ];then
	echo "gcc/g++ compiler is installed"
else
	echo "installing c++11 compiler"
	sudo apt-get -y install c++11
fi


echo "Installing Pangolin requirements..."

#Pangolin required packages
p_req_pkg="libgl1-mesa-dev glew-utils libglew-dev Libpython2.7-dev"
Package_Installer $p_req_pkg

echo "Pulling Pangolin repo..."
cd ~
debugging git clone https://github.com/stevenlovegrove/Pangolin.git

echo "Do you want me to build Pangolin for you?"

confirm=$( Confirm_Choice )
if [ "$confirm" = "true" ]
then
	cd ~/Pangolin
	mkdir sh_build
	cd sh_build

	echo "Configureing cmake"
	cmake ..

	echo "Building Pangolin"
	debugging make -j
else
	echo "Skipping building of Pangolin"
fi

echo "Pangolin done!"

echo "Installing OpenCV requirements..."

#OpenCV required packages
p_req_pkg="libgtk2.0-dev pkg-config libavcodec-dev libavformat-dev libswscale-dev"
Package_Installer $p_req_pkg

echo "Pulling OpenCV repo..."
cd ~
debugging git clone -b 3.4 https://github.com/opencv/opencv.git

echo "Do you want me to build OpenCV for you?"

confirm=$( Confirm_Choice )
if [ "$confirm" = "true" ]
then
	cd ~/opencv
	mkdir sh_build
	cd sh_build

	echo "Configureing cmake"
	cmake ..

	echo "Building OpenCV"
	debugging cmake --build .
	debugging sudo make install
else
	echo "Skipping building of OpenCV"
fi

echo "OpenCV done!"

echo "Pulling Eigen3 repo..."
cd ~
debugging git clone https://gitlab.com/libeigen/eigen.git

echo "Do you want me to build eigen for you?"

confirm=$( Confirm_Choice )
if [ "$confirm" = "true" ]
then
	cd ~/eigen
	mkdir sh_build
	cd sh_build

	echo "Configureing cmake"
	cmake ..

	echo "Building Eigen"
	debugging sudo make install
else
	echo "Skipping building of Eigen"
fi


echo "Continue with adjusted Thirdparty libraries and ORBSLAM build?"

confirm=$( Confirm_Choice )
if [ "$confirm" = "true" ]
then
	cd ~/ORB_SLAM2
	
	echo "Configuring and building Thirdparty/DBoW2 ..."

	cd Thirdparty/DBoW2
	mkdir build
	cd build
	cmake .. -DCMAKE_BUILD_TYPE=Release
	make -j

	cd ../../g2o

	echo "Configuring and building Thirdparty/g2o ..."

	mkdir build
	cd build
	cmake .. -DCMAKE_BUILD_TYPE=Release
	make -j

	cd ../../../

	echo "Uncompress vocabulary ..."

	cd Vocabulary
	tar -xf ORBvoc.txt.tar.gz
	cd ..

	echo "Configuring and building ORB_SLAM2 ..."

	mkdir build
	cd build
	cmake .. -DCMAKE_BUILD_TYPE=Release
	make -j
	
	echo "You don't have to run ./build.sh now!"
	
else
	echo "To install/build Orbslam use the provided script"
	echo "cd ORB_SLAM2"
	echo "chmod +x build.sh"
	echo "./build.sh"
fi












