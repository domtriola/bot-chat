use Mix.Config
config :ex_aws,
  access_key_id: [{:system, "S3_ACCESS_KEY_ID"}, :instance_role],
  secret_access_key: [{:system, "S3_SECRET_ACCESS_KEY"}, :instance_role]
