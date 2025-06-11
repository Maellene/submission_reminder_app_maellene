#!/bin/bash
read -p "Your name please:" name

dir=submission_reminder_$name
mkdir -p ./$dir
mkdir -p ./$dir/app ./$dir/modules ./$dir/assets ./$dir/config


#functions.sh
cat <<EOT > "$dir/modules/functions.sh"
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
        fi
    done < <(tail -n +2 "$submissions_file") # Skip the header
}
EOT

#config.sh
cat <<EOT > "$dir/config/config.env"
# This is the config file
ASSIGNMENT="Shell Navigation"
DAYS_REMAINING=2
EOT

#reminder.sh
cat <<EOT > "$dir/app/reminder.sh"
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
EOT

#submission.txt
cat <<EOT > "$dir/assets/submissions.txt"
student, assignment, submission status
Chinemerem, Shell Navigation, not submitted
Chiagoziem, Git, submitted
Divine, Shell Navigation, not submitted
Anissa, Shell Basics, submitted
chris, Shell Basics, submitted
Kami, Shell Basics, not submitted 
Alia, Shell Basics, not submitted
Duice, Shell Basics, submitted
Meghan, Shell Basics, submitted
Jospin, Shell Basics, submitted
EOT

# startup.sh
cat <<EOT > "$dir/startup.sh"
#!/bin/bash
source config/config.env
source modules/functions.sh
bash app/reminder.sh
EOT
#Making scripts executable
chmod +x "$dir/startup.sh"
echo "Environment setup complete"
