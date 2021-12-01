
# resource "aws_iam_role_policy_attachment" "test-attach" {
#   role       = "${aws_iam_role.lambda_role.name}"
#   policy_arn = "${aws_iam_policy.my_policy.arn}"
# }


#main.tf
data "archive_file" "lambda_file" {
  type = "zip"
  source_file = "${path.module}/pet_info.py"   #source of file
  output_path = "${path.module}/files/pet_info.zip"  #destination of generated file
}


#lambda function
resource "aws_lambda_function" "my_lambda_function" {
  filename = data.archive_file.lambda_file.output_path
  function_name = "pet_info"
  role = aws_iam_role.lambda_role.arn
  handler = "pet_info.pet_info"
  #push, base 64 utf-8
  source_code_hash = data.archive_file.lambda_file.output_base64sha256
  runtime = "python3.8"
}



#terraform-docs markdown ./  --output-file README.md