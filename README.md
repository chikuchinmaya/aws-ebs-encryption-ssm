# 🔐 AWS EBS Volume Encryption Automation with SSM

This project automates the encryption of **existing unencrypted EBS volumes** on AWS using:

- ✅ AWS Systems Manager (SSM) Automation
- 🔐 AWS Key Management Service (KMS)
- 🛡️ IAM role with automation privileges
- 🐍 Python script to detect unencrypted volumes
- 🧰 Enforced default encryption for new EBS volumes

---

## 📁 Repository Structure

| **Path**                                   | **Description**                                              |
|--------------------------------------------|--------------------------------------------------------------|
| `aws-ebs-encryption-ssm/`                  | Root directory of the project                                |
| `encrypt-ebs-automation.yml`               | Main AWS SSM Automation document                             |
| `list-unencrypted-volumes.py`              | Python script to find unencrypted volumes                    |
| `create_iam_kms.sh`                        | Shell script to create IAM role & KMS key                    |
| `enable-default-ebs-encryption.sh`         | Shell script to enable default encryption in all regions     |
| `trust-policy.json`                        | IAM Trust Policy document                                    |
| `output/`                                  | Directory for generated outputs                              |
| `README.md`                                | Project documentation and setup guide                        |

---

## ⚙️ 1️⃣ Clone the Repository

```bash
git clone https://github.com/chikuchinmaya/aws-ebs-encryption-ssm.git
cd aws-ebs-encryption-ssm
```

## 🔐 2️⃣ Enforce Default Encryption for New Volumes
To ensure all new EBS volumes are automatically encrypted in every AWS region:

```base
bash enable-default-ebs-encryption.sh
```

This script:

Enables EBS encryption by default

Applies the setting to all AWS regions

Uses the default KMS key from your account

⚠️ Note: This does not encrypt existing volumes — that’s handled by the automation steps below.

## 🔑 3️⃣ Create IAM Role and KMS Key
Create the necessary IAM role and KMS key using the provided setup script:

```bash
bash create_iam_kms.sh
```
This will:

Create IAM role: SSM-EBS-Encryption-Role

Attach the policy: AmazonSSMAutomationRole

Create a customer-managed KMS key

Replace <KMS_KEY_PLACEHOLDER> inside your SSM document automatically

## 📊 4️⃣ Identify Unencrypted EBS Volumes
Run the Python script to find all unencrypted volumes in your AWS account:

```bash
python list-unencrypted-volumes.py
```
This generates:

output/unencrypted_volumes.csv
Containing:

Volume ID

Instance ID

Availability Zone

Root Path (e.g., /dev/xvda)

## 📄 5️⃣ Upload and Execute SSM Automation
📤 Upload SSM Document
```bash
aws ssm create-document \
  --name "EncryptUnencryptedEBSVolume" \
  --document-type Automation \
  --document-format YAML \
  --content file://encrypt-ebs-automation.yml
```
## ▶️ Run Automation Execution (via Console)
Go to AWS Systems Manager > Automation

Click Execute Automation

Select the document: EncryptUnencryptedEBSVolume

Provide the required inputs:

InstanceId

VolumeId

DeviceName (e.g., /dev/xvda)

AvailabilityZone

AutomationAssumeRole:
arn:aws:iam::<YOUR_ACCOUNT_ID>:role/SSM-EBS-Encryption-Role

Click Execute and monitor the status

Use the values from unencrypted_volumes.csv generated in Step 4.

## ✅ Summary of What Happens
Create an unencrypted snapshot of the target volume

Use the snapshot to create a new encrypted volume

Stop the instance, detach the old volume, and attach the new encrypted one

Restart the instance and delete the unencrypted volume

## 📦 Requirements
AWS CLI configured (aws configure)

Python 3.x

boto3 library (pip install boto3)

IAM permissions for EC2, KMS, IAM, SSM

## 🧑‍💻 Author & Contributions
Created by chikuchinmaya
Open to contributions — feel free to fork and submit pull requests!
