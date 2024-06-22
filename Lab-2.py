import boto3
session = boto3.Session(profile_name="demo_user")
# to create ec2 instance-
ec2 = session.client("ec2")
# to describe instances-
# # ec2.describe_instances()
# to create ec2 keypair-
# resp = ec2.create_key_pair(KeyName = "mykey")
# file = open("mykey.pem", "w")
# file.write(resp["KeyMaterial"])
# file.close
# to create ec2 SG-

# ec2.describe_security_groups()
# resp = ec2.create_security_group(
#     GroupName = "mysg1",
#     Description = "mynewsg2",
#     VpcId = "vpc-94ee04ff"
# )
# sg = ec2.describe_security_groups()
# print(sg)
response = ec2.authorize_security_group_ingress(
   GroupId = 'sg-0d17deb0f0ef1a2a5', 
    IpPermissions = [
    {
    'FromPort': 80,
    'ToPort': 80,
     'IpProtocol': 'tcp',
     'IpRanges': [
    {
    'CidrIp': '0.0.0.0/0',
    }]},
     {
    'FromPort': 22,
    'ToPort': 22,
     'IpProtocol': 'tcp',
     'IpRanges': [
    {
    'CidrIp': '0.0.0.0/0',
    },
     ]
    }
    ]
)
