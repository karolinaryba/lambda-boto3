       
import boto3
import json

def pet_info(event, context):
    # Connected to the S3 service through API calls
    s3 = boto3.client('s3')

    # Collect the bucket name from Event
    target_bucket_name = event["S3Bucket"]
    target_key = event['S3Prefix']
    petName = event['PetName']
    # RETRIEVE all existing buckets in my account
    my_buckets_raw = s3.list_buckets()

    # List the name of each bucket
    for bucket in my_buckets_raw["Buckets"]:
        print("Name of bucket : " + bucket["Name"])

    # Check if the target bucket exists
    for bucket in my_buckets_raw["Buckets"]:
        if bucket["Name"] == target_bucket_name:
            print("The bucket " + target_bucket_name + " exists!")
            obj = s3.get_object(Bucket=target_bucket_name, Key=target_key)
            jsonSample = json.loads(obj['Body'].read())
            
            
            for pet in jsonSample['pets']:
                if petName == pet['name']:
                    return {
                        'body' : json.dumps(pet['favFoods'])
                    }
            else:
                return {
                    'body' : "Bucket doesn't exist"
                }
            
