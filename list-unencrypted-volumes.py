import boto3
import csv

# Initialize AWS EC2 Client
ec2 = boto3.client('ec2')

# Fetch all volumes
response = ec2.describe_volumes()

# Extract unencrypted volumes
unencrypted_volumes = []
for volume in response['Volumes']:
    if not volume['Encrypted']:
        unencrypted_volumes.append([
            volume['VolumeId'],
            volume['Attachments'][0]['InstanceId'] if volume['Attachments'] else "Not Attached",
            volume['AvailabilityZone'],
            volume['Attachments'][0]['Device'] if volume['Attachments'] else "No Root Path"
        ])

# Save output to CSV
with open('unencrypted_volumes.csv', 'w', newline='') as file:
    writer = csv.writer(file)
    writer.writerow(["Volume ID", "Instance ID", "Availability Zone", "Root Path"])
    writer.writerows(unencrypted_volumes)

print("Unencrypted volumes exported to unencrypted_volumes.csv")
