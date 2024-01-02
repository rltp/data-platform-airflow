resource "azurerm_kubernetes_cluster" "this" {
  name                = var.cluster_name
  location            = azurerm_resource_group.cluster.location
  resource_group_name = azurerm_resource_group.cluster.name
  node_resource_group = azurerm_resource_group.cluster_nodes.name
  dns_prefix          = var.cluster_name
  kubernetes_version  = var.cluster_version

  identity {
    type = "SystemAssigned"
  }

  sku_tier = local.aks_sku_tier[var.environment]

  network_profile {
    network_plugin     = "azure"
    ebpf_data_plane    = "cilium"
  }

  default_node_pool {
    name    = "system"
    vm_size = "Standard_DS2_v2"

    enable_auto_scaling = true
    type                = "VirtualMachineScaleSets"
    node_count          = 2
    min_count           = 2
    max_count           = 2

    os_disk_size_gb     = 30
    vnet_subnet_id      = azurerm_subnet.control_plane.id
    max_pods            = 30
    
    upgrade_settings {
      max_surge = "33%"
    }
  }

  maintenance_window {
    allowed {
      day   = "Sunday"
      hours = [18, 20]
    }
  }

  lifecycle {
    ignore_changes = [
      kubernetes_version,
      tags,
      default_node_pool[0].node_count
    ]
  }
}


resource "azurerm_kubernetes_cluster_node_pool" "general" {
  kubernetes_cluster_id = azurerm_kubernetes_cluster.this.id
  vnet_subnet_id        = azurerm_subnet.data_plane.id
  name                  = "general-pool"
  orchestrator_version  = var.cluster_version
  vm_size               = "Standard_DS2_v2"
  os_disk_size_gb       = 128
  os_type               = "Linux"
  max_pods              = 60

  enable_auto_scaling = true
  node_count          = 3
  min_count           = 2
  max_count           = 10

  upgrade_settings {
    max_surge = "33%"
  }

  priority = "Regular"

  node_labels = {
    usage = "general"
  }
}

resource "azurerm_role_assignment" "aks_vnet" {
  principal_id         = azurerm_kubernetes_cluster.this.identity[0].principal_id
  scope                = azurerm_virtual_network.cluster_network.id
  role_definition_name = "Network Contributor"
}