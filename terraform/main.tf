# ============================================================
# 1. Resource Group
# ============================================================

data "azurerm_resource_group" "main" {
  name = var.resource_group_name
}


# ============================================================
# 2. Virtual Network
# ============================================================

resource "azurerm_virtual_network" "main" {
  name                = "vnet-hello-world"
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name

  address_space = ["10.0.0.0/16"]

  tags = {
    Environment = "Learning"
    ManagedBy   = "Terraform"
  }
}


# ============================================================
# 3. Subnet
# ============================================================

resource "azurerm_subnet" "main" {
  name                 = "subnet-hello-world"
  resource_group_name  = data.azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name

  address_prefixes = ["10.0.1.0/24"]
}


# ============================================================
# 4. Public IP
# ============================================================

resource "azurerm_public_ip" "main" {
  name                = "pip-hello-world"
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name

  allocation_method = "Static"
  sku               = "Standard"

  tags = {
    Environment = "Learning"
    ManagedBy   = "Terraform"
  }
}


# ============================================================
# 5. Network Security Group
# ============================================================

resource "azurerm_network_security_group" "main" {
  name                = "nsg-hello-world"
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name

  # SSH
  security_rule {
    name                       = "Allow-SSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  # HTTP
  security_rule {
    name                       = "Allow-HTTP"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    Environment = "Learning"
    ManagedBy   = "Terraform"
  }
}


# ============================================================
# 6. Network Interface
# ============================================================

resource "azurerm_network_interface" "main" {
  name                = "nic-hello-world"
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.main.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.main.id
  }

  tags = {
    Environment = "Learning"
    ManagedBy   = "Terraform"
  }
}


# ============================================================
# 7. Network Interface ↔ NSG Association
# ============================================================

resource "azurerm_network_interface_security_group_association" "main" {
  network_interface_id      = azurerm_network_interface.main.id
  network_security_group_id = azurerm_network_security_group.main.id
}


# ============================================================
# 8. Linux Virtual Machine
# ============================================================

resource "azurerm_linux_virtual_machine" "main" {
  name                = "vm-hello-world"
  computer_name       = "hello-world-vm"
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name

  size = "Standard_B1s"

  admin_username = "azureuser"

  disable_password_authentication = true

  network_interface_ids = [
    azurerm_network_interface.main.id
  ]

  admin_ssh_key {
    username   = "azureuser"
    public_key = file(var.ssh_public_key_path)
  }

  os_disk {
    name                 = "osdisk-hello-world"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "ubuntu-22_04-lts"
    sku       = "server"
    version   = "latest"
  }

  tags = {
    Environment = "Learning"
    ManagedBy   = "Terraform"
    Project     = "HelloWorld"
  }
}