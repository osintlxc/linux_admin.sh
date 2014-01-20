#!/bin/bash
## Author vignesh_ragupathy@yahoo.com
echo "##--Allows user nadmin to run all commands w/o password ------###" | sudo tee -a /etc/sudoers
echo "nadmin  ALL=(ALL)     NOPASSWD:ALL"   | sudo tee -a /etc/sudoers
