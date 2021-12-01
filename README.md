# lambda-boto3
# Lambda

## Exercise 1 - Deploy a lambda function with Terraform

**Step 1**

- Create Role for lambda function with an assume Role


- Create a new policy to allow permission on cloudwatch logs:
- Add permission to read and write to S3. 
https://awspolicygen.s3.amazonaws.com/policygen.html



**Step 2**

- Download the [sample json file](./sample_data.json) and upload it (using any method) into your S3 Bucket.

'''
aws s3 cp sampledata.json s3://<path>
'''


**Step 3**

- Create python Script
- Write small boto3 script to:
    - List all existing s3 buckets
    - read data from S3 based on the source event and print the output.
    - You can use the [AWS Sample python script](https://github.com/aws-samples/aws-python-sample/blob/master/s3_sample.py) as an example
    - Another example from here: [S3 Boto example](https://github.com/boto/boto3/blob/develop/boto3/examples/s3.rst)
- Using the Event input parameter below, find out and print the selected Pet favourite food:
```json
    {
        "S3Bucket" : <your bucket name>,
        "S3Prefix" : <Path to json file>,
        "PetName"  : <pet name as per json(choose any)>
    }
```

Examples:
```json
    {
        "S3Bucket" : "talent-academy-example-storage",
        "S3Prefix" : "sample_data.json",
        "PetName"  : "Meowsalot"
    }
```

**Step 4**

- Using terraform data source create a `.zip` file of the python script
```tf
  data "archive_file" "lambda_file" {
    type = "zip"
    source_file = "${path.module}/pet_info.py"
    output_path = "${path.module}/files/pet_info.zip"
}

resource "aws_lambda_function" "my_lambda_function" {
  filename = data.archive_file.lambda_file.output_path
  function_name = "pet_info"
  role = aws_iam_role.lambda_role.arn
  handler = "pet_info.pet_info"
  source_code_hash = data.archive_file.lambda_file.output_base64sha256
  runtime = "python3.8"
}
```
- Create Lambda resource in terraform
- Run time environment - Python 3.8

**Testing**

- Check if the above output you have printed appears in cloudwatch logs, if not assign IAM role correct permisions and execute the same set of instructions.
- Explore the attribute available to context for this lambda function and discuss possible cases when context attributes can be used.

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_archive"></a> [archive](#provider\_archive) | n/a |
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_role.lambda_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_lambda_function.my_lambda_function](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [archive_file.lambda_file](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |

## Inputs

No inputs.

## Outputs

No outputs.
<!-- END_TF_DOCS -->
