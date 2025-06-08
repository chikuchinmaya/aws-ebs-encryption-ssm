#!/bin/bash

set -e

ROLE_NAME="SSM-EBS-Encryption-Role"
TRUST_POLICY_FILE="templates/trust-policy.json"
AUTOMATION_POLICY_ARN="arn:aws:iam::aws:policy/service-role/AmazonSSMAutomationRole"
AUTOMATION_DOC="automation/encrypt-ebs-automation.yml"

echo "🚀 Creating IAM Role: $ROLE_NAME..."
aws iam create-role \
  --role-name "$ROLE_NAME" \
  --assume-role-policy-document file://$TRUST_POLICY_FILE

echo "🔗 Attaching AmazonSSMAutomationRole policy..."
aws iam attach-role-policy \
  --role-name "$ROLE_NAME" \
  --policy-arn "$AUTOMATION_POLICY_ARN"

echo "🔐 Creating new KMS key for EBS encryption..."
KEY_METADATA=$(aws kms create-key --description "EBS Encryption Key")
KMS_KEY_ID=$(echo "$KEY_METADATA" | jq -r '.KeyMetadata.KeyId')

echo "✅ KMS Key created: $KMS_KEY_ID"

# Optional: Replace placeholder in automation document
if grep -q "<KMS_KEY_PLACEHOLDER>" "$AUTOMATION_DOC"; then
  echo "✏️ Replacing <KMS_KEY_PLACEHOLDER> in automation document..."
  sed -i "s|<KMS_KEY_PLACEHOLDER>|$KMS_KEY_ID|g" "$AUTOMATION_DOC"
  echo "🔁 Placeholder replaced in $AUTOMATION_DOC"
fi

echo "✅ Setup completed successfully!"
