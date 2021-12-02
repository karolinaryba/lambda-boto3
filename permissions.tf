
resource "aws_iam_role" "lambda_role" {
    name = "lambda_role"
    description = "assume role policy"
  assume_role_policy = jsonencode({
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
})
}

#Create a new policy to allow permission on cloudwatch logs:

resource "aws_iam_policy" "my_policy" {
    name = "cloudwatch_policy"
    description = "policy to allow permission on cloudwatch logs"

  policy = jsonencode({
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
                "s3:PutObject"
            ],
            "Effect" : "Allow",
            "Sid" : "S3ObjectActions",
            "Resource" : ["arn:aws:s3:::talent-academy-439272626435-tfstates-practice"]
            },
            {
            "Action" : [
                "s3:List*"
            ],
            "Effect" : "Allow",
            "Sid" : "S3listActions",
            "Resource" : ["arn:aws:s3:::*"]
            }
    ]})

}

resource "aws_iam_role_policy_attachment" "test-attach" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.my_policy.arn
}