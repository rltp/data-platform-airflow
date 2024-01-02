resource "azurerm_virtual_network" "cluster_network" {
  name                = "cluster-network"
  address_space       = ["10.0.0.0/23"]
  location            = azurerm_resource_group.cluster_network.location
  resource_group_name = azurerm_resource_group.cluster_network.name
}

resource "azurerm_subnet" "control_plane" {
  name                 = "control-plane"
  resource_group_name  = azurerm_resource_group.cluster_network.name
  virtual_network_name = azurerm_virtual_network.cluster_network.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "data_plane" {
  name                 = "data-plane"
  resource_group_name  = azurerm_resource_group.cluster_network.name
  virtual_network_name = azurerm_virtual_network.cluster_network.name
  address_prefixes     = ["10.0.2.0/24"]
}