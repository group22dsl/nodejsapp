# Configure the Google Cloud provider
provider "google" {
  credentials = var.my_var_from_github
  project     = "forward-entity-402409"
  region      = "europe-west1"
}

# Configure the Google Cloud provider (assuming credentials are set elsewhere)
# provider "google" {
#   project = "forward-entity-402409"
#   region  = "europe-west1"
# }

# Define the Kubernetes provider (assuming kubeconfig is accessible)
provider "kubernetes" {
  host = "https:35.233.26.59"  # Replace with your GKE cluster endpoint
}

# Define the Kubernetes deployment
resource "kubernetes_deployment" "nodeapp_deployment" {
  metadata {
    name = "myappdeployment"
    labels = {
      type = "backend"
      app  = "nodeapp"
    }
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        type = "backend"
        app  = "nodeapp"
      }
    }

    template {
      metadata {
        labels = {
          type = "backend"
          app  = "nodeapp"
        }
      }

      spec {
        container {
          image = "eu.gcr.io/forward-entity-402409/nodeapp:v3"
          name  = "nodeappcontainer"
          port {
            container_port = 3000
          }
        }
      }
    }
  }
}

# Define the Kubernetes service (LoadBalancer type)
resource "kubernetes_service" "nodeapp_load_balancer" {
  metadata {
    name = "nodeapp-load-balancer"
    labels = {
      type = "backend"
      app  = "nodeapp"
    }
  }

  spec {
    selector = {
      type = "backend"
      app  = "nodeapp"
    }

    port {
      port        = 3000
      target_port = 3000
    }

    type = "LoadBalancer"
  }
}


# # Define the Kubernetes provider
# provider "kubernetes" {
#   config_path    = "~/.kube/config"  # Path to your kubeconfig file
#   version        = "~> 2.0"          # Version constraint for the provider
# }

# # Define the Google kubernates engine cluster
# resource "google_container_cluster" "my_cluster" {
#     name = "google-cloud-cluster-1"
#     location = "europe-west1"
#     initial_node_count = 1

#     addons_config {
#         http_load_balancing {
#             disabled = false
#         }
#         horizontal_pod_autoscaling {
#             disabled = false
#         }
#     }

#     maintenance_policy {
#         daily_maintenance_window {
#             start_time = "03:00"
#         }
#     }

#     remove_default_node_pool = true
# }

# # Define the Kubenetes deployment for the node.js application

# resource "kubernetes_deployment" "nodejsapp_k8_deployment" {
#   metadata {
#     name = "terraform-to-k8-deployment"
#     labels = {
#       app = "nodejsapp"
#     }
#   }

#   spec {
#     replicas = 2

#     selector {
#       match_labels = {
#         app = "nodejsapp"
#       }
#     }

#     template {
#       metadata {
#         labels = {
#           app = "nodejsapp"
#         }
#       }

#       spec {
#         container {
#           image = "eu.gcr.io/forward-entity-402409/nodejsapp:v2"
#           name  = "nodejsapp-container"
#           port {
#               container_port = 3000
#           }
#         }
#       }
#     }
#   }
# }

# resource "kubernetes_service" "nodeapp_load_balancer" {
#   metadata {
#     name = "nodeapp-load-balancer"
#     labels = {
#       app = "nodeapp"
#     }
#   }
  
#   spec {
#     selector = {
#       app = "nodejsapp"
#     }
    
#     port {
#       port        = 3000
#       target_port = 3000
#     }
    
#     type = "LoadBalancer"
#   }
# }
