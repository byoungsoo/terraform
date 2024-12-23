# Output of VPC, Subnet
output "vpc_id" {
    value = aws_vpc.bys_vpc.id
}
output "subnet_ue1a_dmz_id" {
  value = aws_subnet.bys_sbn_az1_dmz.id
}

output "subnet_ue1b_dmz_id" {
  value = aws_subnet.bys_sbn_az2_dmz.id
}

output "subnet_ue1c_dmz_id" {
  value = aws_subnet.bys_sbn_az3_dmz.id
}

output "subnet_ue1d_dmz_id" {
  value = aws_subnet.bys_sbn_az4_dmz.id
}

output "subnet_ue1e_dmz_id" {
  value = aws_subnet.bys_sbn_az5_dmz.id
}

output "subnet_ue1f_dmz_id" {
  value = aws_subnet.bys_sbn_az6_dmz.id
}

output "subnet_ue1a_extelb_id" {
  value = aws_subnet.bys_sbn_az1_extelb.id
}

output "subnet_ue1b_extelb_id" {
  value = aws_subnet.bys_sbn_az2_extelb.id
}

output "subnet_ue1c_extelb_id" {
  value = aws_subnet.bys_sbn_az3_extelb.id
}

output "subnet_ue1d_extelb_id" {
  value = aws_subnet.bys_sbn_az4_extelb.id
}

output "subnet_ue1e_extelb_id" {
  value = aws_subnet.bys_sbn_az5_extelb.id
}

output "subnet_ue1f_extelb_id" {
  value = aws_subnet.bys_sbn_az6_extelb.id
}

output "subnet_ue1a_app_id" {
  value = aws_subnet.bys_sbn_az1_app.id
}

output "subnet_ue1b_app_id" {
  value = aws_subnet.bys_sbn_az2_app.id
}

output "subnet_ue1c_app_id" {
  value = aws_subnet.bys_sbn_az3_app.id
}

output "subnet_ue1d_app_id" {
  value = aws_subnet.bys_sbn_az4_app.id
}

output "subnet_ue1e_app_id" {
  value = aws_subnet.bys_sbn_az5_app.id
}

output "subnet_ue1f_app_id" {
  value = aws_subnet.bys_sbn_az6_app.id
}

output "subnet_ue1a_intelb_id" {
  value = aws_subnet.bys_sbn_az1_intelb.id
}

output "subnet_ue1b_intelb_id" {
  value = aws_subnet.bys_sbn_az2_intelb.id
}

output "subnet_ue1c_intelb_id" {
  value = aws_subnet.bys_sbn_az3_intelb.id
}

output "subnet_ue1d_intelb_id" {
  value = aws_subnet.bys_sbn_az4_intelb.id
}

output "subnet_ue1e_intelb_id" {
  value = aws_subnet.bys_sbn_az5_intelb.id
}

output "subnet_ue1f_intelb_id" {
  value = aws_subnet.bys_sbn_az6_intelb.id
}

output "subnet_ue1a_db_id" {
  value = aws_subnet.bys_sbn_az1_db.id
}

output "subnet_ue1b_db_id" {
  value = aws_subnet.bys_sbn_az2_db.id
}

output "subnet_ue1c_db_id" {
  value = aws_subnet.bys_sbn_az3_db.id
}

output "subnet_ue1d_db_id" {
  value = aws_subnet.bys_sbn_az4_db.id
}

output "subnet_ue1e_db_id" {
  value = aws_subnet.bys_sbn_az5_db.id
}

output "subnet_ue1f_db_id" {
  value = aws_subnet.bys_sbn_az6_db.id
}
