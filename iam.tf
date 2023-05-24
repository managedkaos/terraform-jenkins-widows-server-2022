resource "aws_iam_role" "iam" {
  for_each    = local.host
  name_prefix = "${each.value.name}-"
  tags        = merge(local.tags, { Name = each.value.name })
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : "sts:AssumeRole",
        "Principal" : {
          "Service" : "ec2.amazonaws.com"
        },
        "Effect" : "Allow",
        "Sid" : ""
      }
    ]
  })
}

resource "aws_iam_instance_profile" "iam" {
  for_each    = local.host
  name_prefix = "${each.value.name}-"
  role        = aws_iam_role.iam[each.value.name].name
}

resource "aws_iam_policy" "iam" {
  for_each    = local.host
  name_prefix = "${each.value.name}-"
  tags        = merge(local.tags, { Name = each.value.name })
  path        = "/"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "ssm:GetParametersByPath",
          "ssm:GetParameters",
          "ssm:PutParameter"
        ],
        "Resource" : [
          "arn:aws:ssm:${data.aws_region.default.name}:${data.aws_caller_identity.id.account_id}:parameter/${each.value.name}/*",
          "arn:aws:ssm:${data.aws_region.default.name}:${data.aws_caller_identity.id.account_id}:parameter/${each.value.name}"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "iam" {
  for_each   = local.host
  role       = aws_iam_role.iam[each.value.name].name
  policy_arn = aws_iam_policy.iam[each.value.name].arn
}

resource "aws_iam_role_policy_attachment" "ssm" {
  for_each   = local.host
  role       = aws_iam_role.iam[each.value.name].name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}
