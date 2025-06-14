#!/bin/bash
#command to ask me to enter my name
read -p "Your name please: " username

# Defining the root directory
dir="submission_reminder_${username}"

# Creating the tree for the program
mkdir -p "$dir/config"
mkdir -p "$dir/modules"
mkdir -p "$dir/app"
mkdir -p "$dir/assets"

# Populating the config file
cat <<EOF > "$dir/config/config.env"
# This is the config file
ASSIGNMENT="Shell Navigation"
DAYS_REMAINING=2
EOF

# Populating the functions
cat <<'EOF' > "$dir/modules/functions.sh"
#!/bin/bash
# Function to read submissions file and output students who have not submitted
function check_submissions {
    local submissions_file=$1
    echo "Checking submissions in $submissions_file"

    # Skip the header and iterate through the lines
    while IFS=, read -r student assignment status; do
        # Remove leading and trailing whitespace
        student=$(echo "$student" | xargs)
        assignment=$(echo "$assignment" | xargs)
        status=$(echo "$status" | xargs)

        # Check if assignment matches and status is 'not submitted'
        if [[ "$assignment" == "$ASSIGNMENT" && "$status" == "not submitted" ]]; then
            echo "Reminder: $student has not submitted the $ASSIGNMENT assignment!"
            found_missing=1
        fi
   done < <(tail -n +2 "$submissions_file") # Skip the header

   # If no missing submissions found
   if [[ "$found_missing" -eq 0 ]]; then
        echo "Mission complete: All students have uploaded their $ASSIGNMENT. Great job!"
   fi
}
EOF

# Populating the reminder.sh
cat <<'EOF' > "$dir/app/reminder.sh"
#!/bin/bash

# Source environment variables and helper functions
source ./config/config.env
source ./modules/functions.sh

# Path to the submissions file
submissions_file="./assets/submissions.txt"

# Print remaining time and run the reminder function
echo "Assignment: $ASSIGNMENT"
echo "Days remaining to submit: $DAYS_REMAINING days"
echo "--------------------------------------------"

check_submissions $submissions_file
EOF

# Creatin the startup.sh
cat <<'EOF' > "$dir/startup.sh"
#!/bin/bash
cd "$(dirname "$0")"

source ./config/config.env
source ./modules/functions.sh

submissions_file="./assets/submissions.txt"

echo "WARNING: DEADLINE PROTOCOL INITIATED. LATE WORK WILL BE EXPOSED...................."
check_submissions $submissions_file
EOF

# Populate submissions.txt and adding 5 more students
cat <<EOF > "$dir/assets/submissions.txt"
student, assignment, submission status
Chinemerem, Shell Navigation, not submitted
Chiagoziem, Git, submitted
Divine, Shell Navigation, not submitted
Anissa, Shell Basics, submitted
Francis, Shell Navigation, not submitted
Meghan, Shell Basics, not submitted
Alia, Shell Navigation, not submitted
Kami, Shell Navigation, not submitted
Uncleb, Shell Basics, submitted
EOF

# chmod for all .sh files to make them executable
find "$dir" -type f -name "*.sh" -exec chmod +x {} \;

# Issued statement for successful running
echo "The program has been successfully created by Mae the engineer."
