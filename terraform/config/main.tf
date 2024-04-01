# Configure the Google Cloud provider
provider "google" {
  credentials = var.my_var_from_github
  project     = "forward-entity-402409"
  region      = "europe-west1"
}

# Define the Google kubernates engine cluster
# resource "google_container_cluster" "my_cluster" {
#   name               = "my-gke-cluster"
#   location           = "europe-west1"
#   initial_node_count = 1

#   # Optional: Add-ons configuration
#   addons_config {
#     http_load_balancing {
#       disabled = false
#     }
#     horizontal_pod_autoscaling {
#       disabled = false
#     }
#   }

#   maintenance_policy {
#     daily_maintenance_window {
#       start_time = "03:00"
#     }
#   }

#   remove_default_node_pool = true
# }
resource "google_container_cluster" "my-gke-cluster-new" {
    name = "my-gke-cluster-new"
    location = "europe-west1"
    initial_node_count = 1

    addons_config {
        http_load_balancing {
            disabled = false
        }
        horizontal_pod_autoscaling {
            disabled = false
        }
    }

    maintenance_policy {
        daily_maintenance_window {
            start_time = "03:00"
        }
    }

    remove_default_node_pool = true
}

# Fetch information about the GKE cluster
data "google_client_config" "provider" {}

data "google_container_cluster" "my-gke-cluster-new" {
  name     = "my-gke-cluster-new"
  location = "europe-west1"
}

provider "kubernetes" {
  host  = "https://${data.google_container_cluster.my-gke-cluster-new.endpoint}"
  token = data.google_client_config.provider.access_token
  cluster_ca_certificate = base64decode(
    data.google_container_cluster.my-gke-cluster-new.master_auth[0].cluster_ca_certificate,
  )
}

# Define the Kubernetes provider
# provider "kubernetes" {
#   host  = "https://${data.google_container_cluster.google-cloud-cluster-2.endpoint}"
#   token = data.google_client_config.provider.access_token
#   cluster_ca_certificate = base64decode(
#     data.google_container_cluster.google-cloud-cluster-2.master_auth[0].cluster_ca_certificate,
#   )
# }


# Define the Kubenetes deployment for the node.js application

resource "kubernetes_deployment" "nodejsapp_k8_deployment" {
  metadata {
    name = "terraform-to-k8-deployment"
    labels = {
      app = "nodejsapp"
    }
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        app = "nodejsapp"
      }
    }

    template {
      metadata {
        labels = {
          app = "nodejsapp"
        }
      }

      spec {
        container {
          image = "eu.gcr.io/forward-entity-402409/nodejsapp:v2"
          name  = "nodejsapp-container"
          port {
              container_port = 3000
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "nodeapp_load_balancer" {
  metadata {
    name = "nodeapp-load-balancer"
    labels = {
      app = "nodeapp"
    }
  }
  
  spec {
    selector = {
      app = "nodejsapp"
    }
    
    port {
      port        = 3000
      target_port = 3000
    }
    
    type = "LoadBalancer"
  }
}
