## Hyper-V set up

### Install Hyper-V on Windows 10

[Documentation](https://docs.microsoft.com/de-de/virtualization/hyper-v-on-windows/quick-start/enable-hyper-v)

1. Open a PowerShell console as Administrator
2. Run the following command: 
```pwsh
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All
```
3. Reboot
---

## Creating an VM

### With Hyper-V without quick-start [Recommended]
<p>Create a new VM following the [documentation](https://docs.microsoft.com/de-de/virtualization/hyper-v-on-windows/quick-start/create-virtual-machine) make sure it has at least ~25 GB, you can find the Ubuntu .iso download [here](https://ubuntu.com/download/desktop). Tested with Ubuntu 20.04</p>

1. Create a new VM and name it
2. Choose either Gen 1 or 2, I selected 2
3. If you don't have a lot of RAM untick Dynamic RAM and set the RAM to the required minimum of 4 GB
4. Use the 'Default Switch' so you can use the internet while in the VM
5. Allocate at least ~25 GB of Space for your VM so you can install an IDE e.g. QT-Creator(~11 GB), OS(~6 GB)
6. Install the OS via CD/DVD and use the .iso provided by [Ubuntu](https://ubuntu.com/download/desktop)
7. Go into the VM Properties and disable safe start in security, after the OS is installed you can turn safe start back on again
8. Connect and start the VM


### With Hyper-V quick-start helper
<p>Search for Hyper-V quick-start in Windows and follow the steps listed below. [Documentation](https://docs.microsoft.com/de-de/virtualization/hyper-v-on-windows/quick-start/quick-create-virtual-machine)
If you use this method you will need to resize the VM size after creating it! So the Method without the quick-start helper is recommended
</p>

*Don't start the VM directly after setup!*
	
1. Choose 20.04 Ubuntu and let finish downloading the OS 
2. Change the Properties and increase the Hard drive space to at least 30 GB
3. Add an DVD-drive under the SCSI-Controller
4. Open the DVD-drive and 'mount' the [gparted.iso](https://gparted.org/download.php) and apply the changes
5. Put the DVD-drive at the first spot in the boot order under firmware, apply the changes and close the window
6. Connect to the VM
7. Use Gparted to increase the size of the Linux filesystem to use all the allocated space
8. Restart the VM and it will ask you to choose the OS on restart and will start Ubuntu automatically

## Ubuntu set up

- To finish the setup choose your preferred language, keyboard-layout, time zone and login information
- After that the VM will restart and then ask you for some additional information which you can skip/do whatever feel comfortable with

### Change screen resolution

If you want to change the resolution of the VM follow the following steps. Please be careful the vi editor has unintuitive controls if you have trouble using it here are the [controls](https://itler.net/linux-editor-vi-befehle-in-der-bersicht/).

*NUM LOCK might be toggled differently than your HOST system please watch out*

- Open the editor with `sudo vi /etc/default/grub`
- Navigate to the line with `GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"` and press `i` to enter editing mode
- Change the line to `GRUB_CMDLINE_LINUX_DEFAULT="quiet splash video=hyperv_fb:1920x1080"` or any other resolution
- Leave the editing mode with `ESC` and save the changes with writing `:wq`
- Apply the changes with `sudo update-grub`
- Reboot

### Software updater

If you want you can let the software update run and install updates but should work even without the updates.


# Setting up a save point with Hyper-V

*Warning: After creating a save point you can't change the size of the VM anymore*

After setup and customizing the OS to your liking you should create a save point in the Hyper-V Manager so you will be able to revert to a clean state should something go wrong or you need to start fresh and don't want to start the setup from the beginning.

# Preparing for Orbslam2

## Downloading the scripts for automatic set up

```shell
sudo apt-get update
sudo apt-get install build-essential git

git clone https://github.com/JensAltst/ORB_SLAM2
```

The Downloaded git repository already includes some bugfixes I ran into while installing OrbSlam2, it also includes scripts [./ORB_SLAM2/Personal_scripts/] for installing/downloading all required packages and repositories for OrbSlam2. You will be prompted to confirm building repositories as well to input your root password a few times throughout the process.

You might encounter a few decrepancy-warnings while running the scripts but you can safely ignore those.

```shell
chmod +x ./ORB_SLAM2/Personal_scripts/setup.sh
./ORB_SLAM2/Personal_scripts/setup.sh
```

After downloading and installing all required packages the script will ask you if you want to build the OrbSlam2 repository.

```shell
cd ORB_SLAM2
chmod +x build.sh
./build.sh
```


## Installing QT (Optional)

```shell
sudo apt-get install qtcreator
```

## Testing the Library

There is a script inside the Personal_scripts/Test folder named testOrblsam.sh Which can be used to test if  everything was set up correctly. 

Additionally the readme_original from the https://github.com/JensAltst/ORB_SLAM2 repository contains a few examples and how to use them, the testscript uses one of the TUM datasets.

- Download a dataset from [TUM datasets](https://vision.in.tum.de/data/datasets/rgbd-dataset/download#)
- Unpack the dataset and execute the following command
- Replace the PATH_TO_SEQUENCE_FOLDER with the location of your dataset you just downloaded

```shell
cd ./ORB_SLAM2/
./Examples/Monocular/mono_tum Vocabulary/ORBvoc.txt Examples/Monocular/TUM1.yaml PATH_TO_SEQUENCE_FOLDER
```

























