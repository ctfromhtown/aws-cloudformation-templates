#!/bin/bash

# Script Breakdown
# Step 1: Get the new AMI ID from SSM Parameter Store (SpringbootAMI).
# Step 2: Retrieve all ASGs tagged with EnhancedASGImageUpgradeAutomation/AmiIdParameter=SpringbootAMI, along with their Launch Template IDs.
# Step 3: Create a new version of each Launch Template, using the new AMI.
# Step 4: Update each ASG to use the new Launch Template version.
# Step 5: Start an instance refresh to apply the AMI update.

# How to Use the Script
# Make the script executable: chmod +x asg_ami_update.sh
# Run the script: ./asg_ami_update.sh

# Set log file
LOG_FILE="asg_ami_update_log_$(date +'%Y%m%d_%H%M%S').log"

# Prompt user for DRY RUN mode
read -p "Do you want to run in DRY RUN mode? (y/N): " user_input
if [[ "$user_input" =~ ^[Yy]$ ]]; then
  DRY_RUN=true
else
  DRY_RUN=false
fi
echo "DRY_RUN is set to: $DRY_RUN" | tee -a "$LOG_FILE"

# Get the latest AMI ID from AWS Parameter Store
NEW_AMI_ID=$(aws ssm get-parameter --name "SpringbootAMI" --query "Parameter.Value" --output text)

if [ -z "$NEW_AMI_ID" ]; then
    echo "Error: Could not retrieve AMI ID from Parameter Store." | tee -a "$LOG_FILE"
    exit 1
fi

echo "Using AMI ID: $NEW_AMI_ID" | tee -a "$LOG_FILE"

# Get all ASGs with the tag Environment=Production
ASG_LIST=$(aws autoscaling describe-auto-scaling-groups \
  --query "AutoScalingGroups[?Tags[?Key=='EnhancedASGImageUpgradeAutomation/AmiIdParameter' && Value=='SpringbootAMI']].{ASG:AutoScalingGroupName, LaunchTemplate:LaunchTemplate.LaunchTemplateId}" \
  --output json)

if [ "$ASG_LIST" == "[]" ]; then
    echo "No ASGs found with the tag EnhancedASGImageUpgradeAutomation/AmiIdParameter=SpringbootAMI." | tee -a "$LOG_FILE"
    exit 1
fi

echo "Found ASGs:" | tee -a "$LOG_FILE"
echo "$ASG_LIST" | jq -r '.[].ASG' | tee -a "$LOG_FILE"

# Loop through each ASG and update the Launch Template
for row in $(echo "$ASG_LIST" | jq -c '.[]'); do
    ASG_NAME=$(echo "$row" | jq -r '.ASG')
    LT_ID=$(echo "$row" | jq -r '.LaunchTemplate')

    if [ "$LT_ID" == "null" ]; then
        echo "Skipping ASG $ASG_NAME (No Launch Template found)." | tee -a "$LOG_FILE"
        continue
    fi

    echo "Processing ASG: $ASG_NAME with Launch Template: $LT_ID" | tee -a "$LOG_FILE"

    # Get the current AMI used in the latest Launch Template version
    CURRENT_AMI_ID=$(aws ec2 describe-launch-template-versions \
        --launch-template-id "$LT_ID" --versions '$Latest' \
        --query "LaunchTemplateVersions[0].LaunchTemplateData.ImageId" --output text)

    echo "Current AMI ID for ASG $ASG_NAME: $CURRENT_AMI_ID" | tee -a "$LOG_FILE"

    # Check if the ASG is already using the latest AMI
    if [ "$CURRENT_AMI_ID" == "$NEW_AMI_ID" ]; then
        echo "Skipping ASG $ASG_NAME (Already using AMI: $NEW_AMI_ID)" | tee -a "$LOG_FILE"
        continue
    fi

    # Dry-run mode: Skip execution if enabled
    if [ "$DRY_RUN" = true ]; then
        echo "[DRY-RUN] Would create new Launch Template version for ASG: $ASG_NAME" | tee -a "$LOG_FILE"
        continue
    fi

    # Create a new version of the launch template with the new AMI ID
    NEW_VERSION=$(aws ec2 create-launch-template-version \
      --launch-template-id "$LT_ID" \
      --source-version '$Latest' \
      --launch-template-data "{\"ImageId\":\"$NEW_AMI_ID\"}" \
      --query "LaunchTemplateVersion.VersionNumber" --output text)

    if [ -z "$NEW_VERSION" ]; then
        echo "Error: Failed to create a new version for Launch Template $LT_ID." | tee -a "$LOG_FILE"
        continue
    fi

    echo "Created new Launch Template version: $NEW_VERSION for ASG: $ASG_NAME" | tee -a "$LOG_FILE"

    # Update the ASG to use the new Launch Template version
    aws autoscaling update-auto-scaling-group \
      --auto-scaling-group-name "$ASG_NAME" \
      --launch-template "LaunchTemplateId=$LT_ID,Version=$NEW_VERSION"

    echo "Updated ASG $ASG_NAME to use Launch Template version $NEW_VERSION" | tee -a "$LOG_FILE"

    # Start an instance refresh to apply the new AMI
    aws autoscaling start-instance-refresh --auto-scaling-group-name "$ASG_NAME"

    echo "Instance refresh started for ASG: $ASG_NAME" | tee -a "$LOG_FILE"
done

echo "Script completed! Logs saved to $LOG_FILE"