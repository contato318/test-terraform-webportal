resource "kubernetes_namespace" "portal" {
  metadata {
    name = var.namespace

    labels = {
      "app.kubernetes.io/name"       = var.namespace
      "app.kubernetes.io/part-of"    = var.namespace
      "app.kubernetes.io/managed-by" = "terraform"
    }
  }

}
resource "helm_release" "wordpress" {
  name       = "bitnami"
  namespace  = var.namespace
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "wordpress"

  set {
    name  = "ingress.enabled"
    value = "true"
  }
  set {
    name  = "ingress.hostname"
    value = var.fqdn
  }
  set {
      name  = "service.type"
      value = "ClusterIP"
  }
  set {
      name = "ingress.annotations"
      value = "kubernetes.io/ingress.class: nginx"
  }

  set {
      name = "wordpressPassword"
      value = var.app_passwd
  }
  set {
      name = "mariadb.auth.rootPassword"
      value = var.mariadb_root_passwd
  }
  set {
      name = "mariadb.auth.password"
      value = var.mariadb_passwd
  }
  
  
}