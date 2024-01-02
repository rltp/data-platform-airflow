resource "azurerm_resource_group" "cluster" {
  location = var.location
  name = "${cluster_name}-cluster"
}

resource "azurerm_resource_group" "cluster_nodes" {
  location = var.location
  name = "${cluster_name}-cluster-nodes"
}
resource "azurerm_resource_group" "cluster_network" {
  location = var.location
  name = "${cluster_name}-cluster-network"
}