#!/bin/bash

# Enable default EBS encryption in all enabled regions
echo "🔐 Enabling default EBS encryption in all AWS regions..."

for region in $(aws ec2 describe-regions --query "Regions[*].RegionName" --output text); do
  echo "➡️  Enabling encryption in region: $region"
  aws ec2 enable-ebs-encryption-by-default --region "$region"
done

echo "✅ Default EBS encryption is now enabled in all regions!"
