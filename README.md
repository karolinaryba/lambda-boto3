# lambda-boto3
# Lambda

## Exercise 1 - Deploy a lambda function with Terraform

**Step 1**

- Create Role for lambda function with an assume Role

```tf
resource "aws_iam_role" "lambda_role" {
      name = "lambda_role"
      assume_role_policy = <<EOF
{
      "Version" : "2012-10-17",
      "Statement" : [
          {
            "Action" : [
                "sts:AssumeRole"
            ],
            "Principal" : {
                "Service" : "lambda.amazonaws.com"
            },
            "Effect" : "Allow",
            "Sid" : "LambdaRole"
          }
      ]
}
EOF
}
```
- Create a new policy to allow permission on cloudwatch logs:

```json
resource "aws_iam_policy" "my_policy" {
  name = "my-role"
   description = "My policy"

  policy = <<-EOF
  {
        "Version" : "2012-10-17",
        "Statement" : [
          {
            "Action" : [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": "arn:aws:logs:*:*:*",
            "Effect" : "Allow",
            "Sid" : "cloudwatchLambda"
          },
          {
            "Action" : [
                "s3:GetObject",
                "s3:List*",
                "s3:PutObject"
            ],
            "Effect" : "Allow",
            "Sid" : "S3ObjectActions",
            "Resource" : ["arn:aws:s3:::talent-academy-439272626435-tfstate-ashley"]
            }
      ]
  }
EOF
}
```
- Add permission to read and write to S3. You might need to create a new bucket first or use an existing.

**Step 2**

- Download the [sample json file](./sample_data.json) and upload it (using any method) into your S3 Bucket.




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
    source_file = "${path.cwd}/boto3.py"
    output_path = "${path.cwd}/lambda.zip"
}

resource "aws_lambda_function" "my_lambda_function" {
  filename = data.archive_file.lambda_file.output_path
  function_name = "lambda_pets"
  role = aws_iam_role.lambda_role.arn
  handler = "boto3.lambda_handler"
  runtime = "python3.9"
}
```
- Create Lambda resource in terraform
    - Run time environment - Python 3.8

**Testing**

- Check if the above output you have printed appears in cloudwatch logs, if not assign IAM role correct permisions and execute the same set of instructions.
- Explore the attribute available to context for this lambda function and discuss possible cases when context attributes can be used.
