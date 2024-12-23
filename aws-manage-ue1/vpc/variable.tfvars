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
  sbn-dmz-az1 = {
    cidr_block = "10.120.1.0/24",
    az = "us-east-1a",
    public = true
  },
  sbn-dmz-az2 = {
    cidr_block = "10.120.2.0/24",
    az = "us-east-1b",
    public = true
  },
  sbn-dmz-az3 = {
    cidr_block = "10.120.3.0/24",
    az = "us-east-1c",
    public = true
  },
  sbn-dmz-az4 = {
    cidr_block = "10.120.4.0/24",
    az = "us-east-1d",
    public = true
  },
  sbn-dmz-az5 = {
    cidr_block = "10.120.5.0/24",
    az = "us-east-1e",
    public = true
  },
  sbn-dmz-az6 = {
    cidr_block = "10.120.6.0/24",
    az = "us-east-1f",
    public = true
  },

  sbn-extelb-az1 = {
    cidr_block = "10.120.11.0/24",
    az = "us-east-1a",
    public = true
  },
  sbn-extelb-az2 = {
    cidr_block = "10.120.12.0/24",
    az = "us-east-1b",
    public = true
  },
  sbn-extelb-az3 = {
    cidr_block = "10.120.13.0/24",
    az = "us-east-1c",
    public = true
  },
  sbn-extelb-az4 = {
    cidr_block = "10.120.14.0/24",
    az = "us-east-1d",
    public = true
  },
  sbn-extelb-az5 = {
    cidr_block = "10.120.15.0/24",
    az = "us-east-1e",
    public = true
  },
  sbn-extelb-az6 = {
    cidr_block = "10.120.16.0/24",
    az = "us-east-1f",
    public = true
  }
]

prv_subnet_cidr_blocks = [
  sbn-app-az1 = {
    cidr_block = "10.120.20.0/22",
    az = "us-east-1a",
    public = false
  },
  sbn-app-az2 = {
    cidr_block = "10.120.24.0/22",
    az = "us-east-1b",
    public = false
  },
  sbn-app-az3 = {
    cidr_block = "10.120.28.0/22",
    az = "us-east-1c",
    public = false
  },
  sbn-app-az4 = {
    cidr_block = "10.120.32.0/22",
    az = "us-east-1d",
    public = false
  },
  sbn-app-az5 = {
    cidr_block = "10.120.36.0/22",
    az = "us-east-1e",
    public = false
  },
  sbn-app-az6 = {
    cidr_block = "10.120.40.0/22",
    az = "us-east-1f",
    public = false
  },
  
  sbn-intelb-az1 = {
    cidr_block = "10.120.51.0/24",
    az = "us-east-1a",
    public = false
  },
  sbn-intelb-az2 = {
    cidr_block = "10.120.52.0/24",
    az = "us-east-1b",
    public = false
  },
  sbn-intelb-az3 = {
    cidr_block = "10.120.53.0/24",
    az = "us-east-1c",
    public = false
  },
  sbn-intelb-az4 = {
    cidr_block = "10.120.54.0/24",
    az = "us-east-1d",
    public = false
  },
  sbn-intelb-az5 = {
    cidr_block = "10.120.55.0/24",
    az = "us-east-1e",
    public = false
  },
  sbn-intelb-az6 = {
    cidr_block = "10.120.56.0/24",
    az = "us-east-1f",
    public = false
  },

  sbn-db-az1 = {
    cidr_block = "10.120.61.0/24",
    az = "us-east-1a",
    public = false
  },
  sbn-db-az2 = {
    cidr_block = "10.120.62.0/24",
    az = "us-east-1b",
    public = false
  },
  sbn-db-az3 = {
    cidr_block = "10.120.63.0/24",
    az = "us-east-1c",
    public = false
  },
  sbn-db-az4 = {
    cidr_block = "10.120.64.0/24",
    az = "us-east-1d",
    public = false
  },
  sbn-db-az5 = {
    cidr_block = "10.120.65.0/24",
    az = "us-east-1e",
    public = false
  },
  sbn-db-az6 = {
    cidr_block = "10.120.66.0/24",
    az = "us-east-1f",
    public = false
  }
]
  
prv_only_subnet_cidr_blocks = [
  sbn-prvonly-az1 = {
    cidr_block = "10.120.101.0/24",
    az = "us-east-1a",
    public = false
  },
  sbn-prvonly-az2 = {
    cidr_block = "10.120.102.0/24",
    az = "us-east-1b",
    public = false
  },
  sbn-prvonly-az3 = {
    cidr_block = "10.120.103.0/24",
    az = "us-east-1c",
    public = false
  },
  sbn-prvonly-az4 = {
    cidr_block = "10.120.104.0/24",
    az = "us-east-1d",
    public = false
  },
  sbn-prvonly-az5 = {
    cidr_block = "10.120.105.0/24",
    az = "us-east-1e",
    public = false
  },
  sbn-prvonly-az6 = {
    cidr_block = "10.120.106.0/24",
    az = "us-east-1f",
    public = false
  }
]
