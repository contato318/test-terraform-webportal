## Tests:
$ checkov -d live

## Apply
$ terragrunt run-all apply

## Enviroments variables:
  * TF_VAR_access_key=<AWS access key>
  * TF_VAR_secret_key=<AWS secret key>
  * TF_VAR_region=<AWS REGION>
  * TF_VAR_app_passwd=<Wordpress password>
  * TF_VAR_mariadb_root_passwd=<mariadb root password>
  * TF_VAR_mariadb_passwd=<mariadb user password>
  * TF_VAR_aws_dns_zone_id=<Route53 DNS Zone ID>
  * TF_VAR_fqdn=<FQDN to wordpress>
  * TF_VAR_wildcard=<Domain wildcard>