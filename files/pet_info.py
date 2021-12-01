import boto3
import json



def pet_info(event, context):
    #connect to S3
    s3_client = boto3.client('s3')

    bucket_name = event['S3Bucket']
    key = event['S3Prefix']
    petName = event['PetName']
    
    #list all buckets
    list_buckets_raw = s3_client.list_buckets()
    
    for bucket in list_buckets_raw['Buckets']:
        print("Name of bucket:" + bucket_name)
        if bucket['Name'] == bucket_name:
            print('Bucket exists')
            myBucket = s3_client.Bucket(bucket_name)
            obj = myBucket.Object(key)
            body = format(obj.get()['Body'].read())  #print('Object body: {}'.format(obj.get()['Body'].read()))
            #pet favfood here: for pet in pets return pet["favFoods"]
        else:
            print("Bucket doesn't exist.")


#How to upload py file to lambda console for testing? Manually?
