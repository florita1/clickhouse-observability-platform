resource "helm_release" "argocd" {
  name       = "argocd"
  namespace  = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = "5.51.6" # Use latest compatible version

  create_namespace = true

  values = [
    file("${path.module}/values.yaml")
  ]
}