#permissions and policies

#Create Role for lambda function with an assume Role


resource "aws_iam_role" "lambda_role" {
    name = "lambda_assume_role"
    description = "assume role policy"
  assume_role_policy = {
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

#Create a new policy to allow permission on cloudwatch logs:

resource "aws_iam_policy" "my_policy" {
    name = "cloudwatch_policy_permission"
    description = "policy to allow permission on cloudwatch logs"

  policy = {
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
            "Action": [
                "s3:GetObject",
                "s3:PutObject",
                "s3:List*"   #separate element for list -what to look for in policy generator? s3:ListALLMyBuckets
            ],
            "Effect": "Allow",
            "Resource": "arn:aws:s3:::$talent-academy-439272626435-tfstates",   
            "Principal": {
            "AWS": [
            "439272626435"
            ]
            } # is Principal required?
        }
    ]}

}
}