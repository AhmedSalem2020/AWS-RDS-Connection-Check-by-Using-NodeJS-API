resource "aws_db_instance" "default" {
  identifier            = "bespinglobal-db"
  allocated_storage    = var.allocated_storage
  db_name              = var.db_name
  engine               = var.engine
  engine_version       = var.engine_version
  instance_class       = var.instance_class
  username             = "dbadmin"
  port                 = "3306"
  password             = random_password.db_master_pass.result
  parameter_group_name = var.parameter_group_name
  db_subnet_group_name = aws_db_subnet_group.private.id
  vpc_security_group_ids      = [var.RDSSecurityGroup]
  multi_az             = true 
  skip_final_snapshot  = true
  tags = {
    CreatedBy          = "${var.mail}"
  }
}

resource "aws_db_subnet_group" "private" {
  name       = "private_subnets"
  subnet_ids = [var.Private_Subnet1, var.Private_Subnet2]

  tags = {
    Name = "Private DB subnets"
  }
}

# Create a random generated password to use in secrets.
resource "random_password" "db_master_pass" {
  length           = 16
  special          = true
  override_special = "_%@"
}
 
# Creating a AWS secret for my rds database (mydb_secret)
resource "aws_secretsmanager_secret" "secretmasterDB" {
   name = "mydb_secret"
}

# Creating a AWS secret versions for my rds database (mydb_secret)
resource "aws_secretsmanager_secret_version" "sversion" {
  secret_id = aws_secretsmanager_secret.secretmasterDB.id
  secret_string = jsonencode(
    {
      username   = aws_db_instance.default.username
      password   = aws_db_instance.default.password
      engine     = "mysql"
      port       = "3306"
      identifier = aws_db_instance.default.identifier
      DB_URI     = "${aws_db_instance.default.engine}://${aws_db_instance.default.username}:${aws_db_instance.default.password}@${aws_db_instance.default.endpoint}/${aws_db_instance.default.db_name}"
    }
  )
}