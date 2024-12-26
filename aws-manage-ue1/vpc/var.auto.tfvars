## vpc/subnet
vpc_cidr_blocks = {
  primary_cidr_block = "10.120.0.0/16"
}

### Subnet variable should have [NAME, CIDR, AZ. TYPE]
subnet_cidr_blocks = [
    {name="sbn-dmz-az1", cidr_block="10.120.1.0/24", az="us-east-1a", type="public"},
    {name="sbn-dmz-az2", cidr_block="10.120.2.0/24", az="us-east-1b", type="public"},
    {name="sbn-dmz-az3", cidr_block="10.120.3.0/24", az="us-east-1c", type="public"},
    {name="sbn-dmz-az4", cidr_block="10.120.4.0/24", az="us-east-1d", type="public"},
    {name="sbn-dmz-az5", cidr_block="10.120.5.0/24", az="us-east-1e", type="public"},
    {name="sbn-dmz-az6", cidr_block="10.120.6.0/24", az="us-east-1f", type="public"},
    
    {name="sbn-extelb-az1", cidr_block="10.120.11.0/24", az="us-east-1a", type="public"},
    {name="sbn-extelb-az2", cidr_block="10.120.12.0/24", az="us-east-1b", type="public"},
    {name="sbn-extelb-az3", cidr_block="10.120.13.0/24", az="us-east-1c", type="public"},
    {name="sbn-extelb-az4", cidr_block="10.120.14.0/24", az="us-east-1d", type="public"},
    {name="sbn-extelb-az5", cidr_block="10.120.15.0/24", az="us-east-1e", type="public"},
    {name="sbn-extelb-az6", cidr_block="10.120.16.0/24", az="us-east-1f", type="public"},

    {name="sbn-app-az1", cidr_block="10.120.20.0/22", az="us-east-1a", type="private"},
    {name="sbn-app-az2", cidr_block="10.120.24.0/22", az="us-east-1b", type="private"},
    {name="sbn-app-az3", cidr_block="10.120.28.0/22", az="us-east-1c", type="private"},
    {name="sbn-app-az4", cidr_block="10.120.32.0/22", az="us-east-1d", type="private"},
    {name="sbn-app-az5", cidr_block="10.120.36.0/22", az="us-east-1e", type="private"},
    {name="sbn-app-az6", cidr_block="10.120.40.0/22", az="us-east-1f", type="private"},
    
    {name="sbn-intelb-az1", cidr_block="10.120.51.0/24", az="us-east-1a", type="private"},
    {name="sbn-intelb-az2", cidr_block="10.120.52.0/24", az="us-east-1b", type="private"},
    {name="sbn-intelb-az3", cidr_block="10.120.53.0/24", az="us-east-1c", type="private"},
    {name="sbn-intelb-az4", cidr_block="10.120.54.0/24", az="us-east-1d", type="private"},
    {name="sbn-intelb-az5", cidr_block="10.120.55.0/24", az="us-east-1e", type="private"},
    {name="sbn-intelb-az6", cidr_block="10.120.56.0/24", az="us-east-1f", type="private"},
    
    {name="sbn-db-az1", cidr_block="10.120.61.0/24", az="us-east-1a", type="private"},
    {name="sbn-db-az2", cidr_block="10.120.62.0/24", az="us-east-1b", type="private"},
    {name="sbn-db-az3", cidr_block="10.120.63.0/24", az="us-east-1c", type="private"},
    {name="sbn-db-az4", cidr_block="10.120.64.0/24", az="us-east-1d", type="private"},
    {name="sbn-db-az5", cidr_block="10.120.65.0/24", az="us-east-1e", type="private"},
    {name="sbn-db-az6", cidr_block="10.120.66.0/24", az="us-east-1f", type="private"},
    
    {name="sbn-prvonly-az1", cidr_block="10.120.101.0/24", az="us-east-1a", type="private"},
    {name="sbn-prvonly-az2", cidr_block="10.120.102.0/24", az="us-east-1b", type="private"},
    {name="sbn-prvonly-az3", cidr_block="10.120.103.0/24", az="us-east-1c", type="private"},
    {name="sbn-prvonly-az4", cidr_block="10.120.104.0/24", az="us-east-1d", type="private"},
    {name="sbn-prvonly-az5", cidr_block="10.120.105.0/24", az="us-east-1e", type="private"},
    {name="sbn-prvonly-az6", cidr_block="10.120.106.0/24", az="us-east-1f", type="private"}
]