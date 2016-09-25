# Install brew and deps
fancy_echo() {
  local fmt="$1"; shift

  # shellcheck disable=SC2059
  printf "\n$fmt\n" "$@"
}
fancy_echo "This script will attempt to install gazebo"
fancy_echo "Part 1: Installing Brew"
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew install wget
brew install homebrew/dupes/unzip
brew install cmake
fancy_echo "Part 2: XQuartz"
wget https://dl.bintray.com/xquartz/downloads/XQuartz-2.7.9.dmg -P ~/Downloads/
open ~/Downloads/XQuartz-2.7.9.dmg
read -p "Install XQuartz, via the .pkg file. When you are finished installing press [Enter] here"
fancy_echo "Part 3: Gazebo"
brew tap osrf/simulation
brew install gazebo6
fancy_echo "Part 4: Gazebo Plugins"
cd ~/Downloads
wget http://first.wpi.edu/FRC/roborio/maven/release/edu/wpi/first/wpilib/simulation/simulation/1.0.0/simulation-1.0.0.zip
mkdir ~/wpilib/simulation
unzip ~/Downloads/simulation-1.0.0.zip -d ~/wpilib/simulation
fancy_echo "Part 5: GZ Msgs"
cd ~/wpilib/simulation/gz_msgs
mkdir build
cd build
cmake ..
make install
fancy_echo "Part 6: Robot Models"
cd ~/wpilib/simulation
wget -O models.zip https://usfirst.collab.net/sf/frs/do/downloadFile/projects.wpilib/frs.simulation.frcsim_gazebo_models/frs1160?dl=1
unzip models.zip
mv  frcsim-gazebo-models-4/models ~/wpilib/simulation/
mv  frcsim-gazebo-models-4/worlds ~/wpilib/simulation/
fancy_echo "Part 7: FRC Plugins"
cd ~/wpilib/simulation
mkdir allwpilib
git clone https://usfirst.collab.net/gerrit/p/allwpilib.git
cd allwpilib
./gradlew -PmakeSim frc_gazebo_plugins
cp ~/wpilib/simulation/allwpilib/build/install/simulation/plugins/* ~/wpilib/simulation/plugins
fancy_echo "Part 8: Joystick"
wget http://ci.newdawnsoftware.com/job/JInput-git/label=OSX/lastBuild/artifact/*zip*/archive.zip -P ~/Downloads/
cp ~/Downloads/archive/dist/ ~/wpilib/simulation/lib
fancy_echo "Part 9: Final Steps"
touch ~/.bash_profile
echo "export PATH=$HOME/wpilib/simulation:$PATH" >> ~/.bash_profile
source ~/.bash_profile
fancy_echo "Testing..."
gazebo
