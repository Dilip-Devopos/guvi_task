#!/bin/bash

#############################
# Given a file, replace all occurrences of the word "give" with "learning" from the 5th line onward in only those lines that contain the word "welcome"
#############################

awk 'NR<5 || !/welcome/ {print; next} {gsub(/give/, "learning"); print}' /home/dilip/Guvi_Practice/Task_4/file.txt > /home/dilip/Guvi_Practice/Task_4/output.txt