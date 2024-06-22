import boto3
awsmgmt = boto3.Session(profile_name = "user-1")

ec2 = awsmgmt.client("ec2")
# resp = ec2.describe_instances()
# print(resp)
# resp = ec2.create_key_pair(KeyName = "demokey")
# file = open("demokey.pem", "w")
# file.write(resp["KeyMaterial"])
# file.close
sg = ec2.create_security_group(
    GroupName = "mysg1",
    Description = "creating new sg",
    VpcId = "vpc-94ee04ff"
)
# resp = ec2.describe_security_groups()
gid = sg['GroupId']
print(gid)
     
