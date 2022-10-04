## Root Module 
module "networking_module" {
  source = "./modules/networking_module"
}

module "ec2SecurityGroup" {
  source = "./modules/securityGroup_module"
  vpc_id = module.networking_module.vpc_id
  ALB    = module.ALB_SecurityGroup_module.ALB
}

module "ALB_SecurityGroup_module" {
  source =  "./modules/ALB_SecurityGroup_module"
  vpc_id = module.networking_module.vpc_id
}

module "ALB_module" {
  source         =  "./modules/ALB_module"
  vpc_id         = module.networking_module.vpc_id
  Public_Subnet1 = module.networking_module.Public_Subnet1
  Public_Subnet2 = module.networking_module.Public_Subnet2
  ALB            = [module.ALB_SecurityGroup_module.ALB]
}

module "ASG_module" {
  source                        =  "./modules/ASG_module"
  PrivateWebServerSecurityGroup = [module.ec2SecurityGroup.PrivateWebServerSecurityGroup]
  target_group                  = module.ALB_module.target_group
  private_subnet1               = module.networking_module.private_subnet1
  private_subnet2               = module.networking_module.private_subnet2
  my_secret                     = module.RDS_module.my_secret 
}

module "RDS_module" {
  source = "./modules/RDS_module"
  Private_Subnet1               = module.networking_module.private_subnet1
  Private_Subnet2               = module.networking_module.private_subnet2
  RDSSecurityGroup              = module.RDS_SecurityGroup_module.RDSSecurityGroup
}

module "RDS_SecurityGroup_module" {
  source                        = "./modules/RDS_SecurityGroup_module"
  vpc_id                        = module.networking_module.vpc_id
  PrivateWebServerSecurityGroup = module.ec2SecurityGroup.PrivateWebServerSecurityGroup
}

module "codePipeline_module" {
  source = "./modules/codePipeline_module"
}