#!/bin/bash

# Reqesting for the new assignment name
read -p "ENTER THE ASSIGNMENT NAME PLEASE: " new_assignment

# Finding the base directory (e.g., $basedir)
dir=$(find . -maxdepth 1 -type d -name "submission_reminder_*" | head -n 1)

# Checking if the directory really exists
if [[ ! -d "$dir" ]]; then
    echo " Error **** CANT find the submission_reminder_ directory."
    exit 1
fi

# Updating the ASSIGNMENT in config.env
sed -i "s/^ASSIGNMENT=.*/ASSIGNMENT=\"$new_assignment\"/" "$dir/config/config.env"

echo "Updating NEW ASSIGNMENT  to \"$new_assignment\" in config.env"

# Running the  startup.sh from the $basedir
echo " Running the reminder check with the new assignment*"
bash "$dir/startup.sh"
