import boto3
awsmgmt = boto3.Session(profile_name='user-1')
# create resource method-
#iam_con = awsmgmt.resource("iam")
# to check iam user list
# for each_user in iam_con.users.all():
#     print(each_user.name)
# now check how many function/method are available with iam management console-
#print(dir(awsmgmt))
# to check how many service can be access through resources method-
#print(awsmgmt.get_available_resources())
# create client method-
# iam_con = awsmgmt.client("iam")
# to check list of iam users-
#print(iam_con.list_users())
# note- client always returns dictionary
# to check only list of iam users-
# for each_user in iam_con.list_users()["Users"]:
#     print(each_user["UserName"])
