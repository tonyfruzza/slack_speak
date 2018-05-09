# slack_speak Cookbook
---

Provides slack_speak resource for sending messages to your Slack Custom Integration Incoming WebHook that you configure through https://YOUR_ORG_NAME.slack.com/services/. The webhook url will look similar to: https://hooks.slack.com/services/XXXXX/XXXXX/XXXXXXXXXXXXXXXXX

This cookbook currently only makes use of AWS parameter store as the source of the webhook URL which is KMS encrypted. In order to read the value an IAM role attached to the EC2 instance is required that includes something like:

```
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ssm:GetParameter"
      ],
      "Resource": "*"
    }
  ]
}
```

The parameter store value will need to be in the sam region as the EC2 instance and is by default named `/slack_speak/web_hook_url`
