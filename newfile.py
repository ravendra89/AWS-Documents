import boto3
awsmgmt = boto3.Session(profile_name='terraform-user')
iam_con = awsmgmt.resource("iam")
for each_user in iam_con.users.all():
  print(each_user.name)