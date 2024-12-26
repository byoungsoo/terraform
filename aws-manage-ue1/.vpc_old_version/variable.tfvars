
## Default
aws_region="us-east-1"
aws_region_code="ue1"
project_code = "bys"
account = "manage"

## vpc/subnet
vpc_cidr_blocks = {
  primary_cidr_block = "10.120.0.0/16"
}

### Subnet variable should have [NAME, CIDR, AZ]
pub_subnet_cidr_blocks = [
    ["sbn-dmz-az1", "10.120.1.0/24", "us-east-1a"],
    ["sbn-dmz-az2", "10.120.2.0/24", "us-east-1b"],
    ["sbn-dmz-az3", "10.120.3.0/24", "us-east-1c"],
    ["sbn-dmz-az4", "10.120.4.0/24", "us-east-1d"],
    ["sbn-dmz-az5", "10.120.5.0/24", "us-east-1e"],
    ["sbn-dmz-az6", "10.120.6.0/24", "us-east-1f"],
    ["sbn-extelb-az1", "10.120.11.0/24", "us-east-1a"],
    ["sbn-extelb-az2", "10.120.12.0/24", "us-east-1b"],
    ["sbn-extelb-az3", "10.120.13.0/24", "us-east-1c"],
    ["sbn-extelb-az4", "10.120.14.0/24", "us-east-1d"],
    ["sbn-extelb-az5", "10.120.15.0/24", "us-east-1e"],
    ["sbn-extelb-az6", "10.120.16.0/24", "us-east-1f"],
]

prv_subnet_cidr_blocks = [
    ["sbn-app-az1", "10.120.20.0/22", "us-east-1a"],
    ["sbn-app-az2", "10.120.24.0/22", "us-east-1b"],
    ["sbn-app-az3", "10.120.28.0/22", "us-east-1c"],
    ["sbn-app-az4", "10.120.32.0/22", "us-east-1d"],
    ["sbn-app-az5", "10.120.36.0/22", "us-east-1e"],
    ["sbn-app-az6", "10.120.40.0/22", "us-east-1f"],

    ["sbn-intelb-az1", "10.120.51.0/24", "us-east-1a"],
    ["sbn-intelb-az2", "10.120.52.0/24", "us-east-1b"],
    ["sbn-intelb-az3", "10.120.53.0/24", "us-east-1c"],
    ["sbn-intelb-az4", "10.120.54.0/24", "us-east-1d"],
    ["sbn-intelb-az5", "10.120.55.0/24", "us-east-1e"],
    ["sbn-intelb-az6", "10.120.56.0/24", "us-east-1f"],

    ["sbn-db-az1", "10.120.61.0/24", "us-east-1a"],
    ["sbn-db-az2", "10.120.62.0/24", "us-east-1b"],
    ["sbn-db-az3", "10.120.63.0/24", "us-east-1c"],
    ["sbn-db-az4", "10.120.64.0/24", "us-east-1d"],
    ["sbn-db-az5", "10.120.65.0/24", "us-east-1e"],
    ["sbn-db-az6", "10.120.66.0/24", "us-east-1f"]
]

prv_only_subnet_cidr_blocks = [
    ["sbn-prvonly-az1", "10.120.101.0/24", "us-east-1a"],
    ["sbn-prvonly-az2", "10.120.102.0/24", "us-east-1b"],
    ["sbn-prvonly-az3", "10.120.103.0/24", "us-east-1c"],
    ["sbn-prvonly-az4", "10.120.104.0/24", "us-east-1d"],
    ["sbn-prvonly-az5", "10.120.105.0/24", "us-east-1e"],
    ["sbn-prvonly-az6", "10.120.106.0/24", "us-east-1f"]
]