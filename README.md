# ECS Terraform Modules

## Example

### Create instance

1. Write the example below in a .tf file

```
# Choose between it-mil1, de-fra1 and nl-ams1
variable "region" {
  default = "it-mil1"
}

# Your tenant name
variable "tenant_name" {
  default = "test@test.com"
}

# Your user name
variable "username" {
  default = "test@test.com"
}

# Your password
variable "password" {
  default = "test"
}

# You ssh public key path
variable "ssh_pubkey" {
  default = "../id.rsa"
}

# Define provider
provider "openstack" {
  auth_url = "${var.auth_url}"
  tenant_name = "${var.tenant_name}"
  user_name = "${var.user_name}"
  password = "${var.password}"
}

# Create network
module "network" {
  source = "github.com/entercloudsuite/terraform-modules//network"
  region = "${var.region}"
  name = "general_network"
  router_id = ""
}

# Create ssh keypair
module "keypair" {
  source = "github.com/entercloudsuite/terraform-modules//keypair"
  ssh_pubkey = "${var.ssh_pubkey}"
  region = "${var.region}"
}

# Create ssh firewall policy
module "ssh" {
  source = "github.com/entercloudsuite/terraform-modules//security"
  name = "ssh"
  region = "${var.region}"
  protocol = "tcp"
  port_range_min = 22
  port_range_max = 22
  allow_remote = "0.0.0.0/0"
}

# Create instance
module "web" {
  source = "github.com/entercloudsuite/terraform-modules//instance"
  name = "web"
  quantity = 1
  external = 1
  flavor = "e3standard.x3"
  network_name = "${module.network.name}"
  sec_group = ["${module.ssh.sg_name}"]
  keypair = "${module.keypair.name}"
  tags = {
    "web" = ""
    "nginx" = ""
  }
}
```

2. Change the variables with your data:
* region
* tenant_name
* username
* password
* ssh_pubkey <- you can generate it with ssh-keygen command

3. Adjust the `quantity` variable to a desirable value
4. Run `terraform init` to allow terraform to get the requirements
5. Run `terraform get` to allow terraform to obtain the modules
6. Run `terraform plan` and `terraform apply` to provision the infrastructure

### Create Volume

1. Add the snippet below to your .tf file

```
# Create volume for each web instance
module "volume-web" {
  source = "./volume"
  name = "volume-web"
  size = "10"
  instance = "${module.web.instance}"
  quantity = "${module.web.quantity}"
  volume_type = "Top"
}
```

2. Adjust the `size` variable to a desirable value
3. Run `terraform get` to allow terraform to obtain the modules
4. Run `terraform plan` and `terraform apply` to provision the infrastructure

### Remote tf state

1. Add the snippet below to your .tf file
```
terraform {
  backend "swift" {
    auth_url = "https://api.it-mil1.entercloudsuite.com/v2.0"
    password = "test"
    container = "terraform_it-mil1_state"
    region_name = "it-mil1"
    tenant_name = "test@test.com"
    user_name = "test@test.com"
  }
}
```
2. Change the variables with your data:
* auth_url
* region
* tenant_name
* username
* password

## Note
This project is still in development, more documentation and modules will be added in the future. Stay tuned!
