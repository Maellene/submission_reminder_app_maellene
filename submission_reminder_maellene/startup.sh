#!/bin/bash
cd "$(dirname "$0")"

source ./config/config.env
source ./modules/functions.sh

submissions_file="./assets/submissions.txt"

echo "WARNING: DEADLINE PROTOCOL INITIATED. LATE WORK WILL BE EXPOSED...................."
check_submissions $submissions_file
