# argocd-test

This is the GitOps repository for ArgoCD.

It contains application definitions, configurations, and environments information that collectively represent the source of truth of the EKS cluster provisioned by this [repo](https://github.com/dbaltor/eks-iac).

ArgoCD automates the deployment of the desired application states in the specified target environments.

### Deploying the applications

To deploy the `my-app-1` and `my-app-2` applications to `dev`, run:  
`./scripts/upgrade-apps.sh <version>` (e.g. `./scripts/upgrade-apps.sh v0.1.4`)  
then verify the new applications version [here](https://github.com/dbaltor/argocd-test/blob/master/environments/dev/my-app-1/deployment.yaml) and [here](https://github.com/dbaltor/argocd-test/blob/master/environments/dev/my-app-2/deployment.yaml).

## Kustomize

We can combine ArgoCD with Kustomize which is a tool that traverses a Kubernetes manifest to add, remove or update configuration options without forking. It is available both as a standalone binary and as a native feature of kubectl.

The principals of kustomize are:
- Purely declarative approach to configuration customisation 
- Manage an arbitrary number of distinctly customised Kubernetes configurations
- Every artifact that kustomize uses is plain YAML and can be validated and processed as such 
- As a "templateless" templating system, it encourages using YAML without forking the repo

It achieves this with a series of `bases` (where the YAML is stored) and `overlays` (directores where deltas are stored). The advantage of this is that you can have different versions of the same YAML without storing or copying the YAML in different places.

Argo CD has native built in support for Kustomize and will automatically detect the use of Kustomize without further configuration.

### Deploying the applications

To deploy any application to to any environment, run: `./scripts/upgrade-kustomize.sh <name> <env> <version>` (e.g. `./scripts/upgrade-kustomize.sh my-app-3 staging v0.1.3`)  
then verify the new version [here](https://github.com/dbaltor/argocd-test/blob/master/environments/staging/my-app-3/kustomization.yaml).
