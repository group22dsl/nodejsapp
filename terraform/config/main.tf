# Configure the Google Cloud provider
provider "google" {
  credentials = var.GOOGLE_CRENTIALS
  project     = "forward-entity-402409"
  region      = "europe-west1"
}

# Define the Google kubernates engine cluster
resource "google_container_cluster" "my_cluster" {
    name = "google-cloud-cluster"
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
