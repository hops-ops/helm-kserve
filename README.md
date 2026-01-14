# helm-kserve

A Crossplane configuration that deploys KServe via Helm.

KServe is a standardized serverless ML inference platform on Kubernetes, built for highly scalable predictive and generative AI use cases. It provides a simple, pluggable, and complete solution for production ML serving.

## Prerequisites

KServe requires either:
- **Knative Serving** (for Serverless mode)
- **Istio** or another service mesh (for Standard/RawDeployment modes)

Install KServe CRDs first:
```bash
helm install kserve-crd oci://ghcr.io/kserve/charts/kserve-crd --version v0.16.0
```

## Quick Start

```yaml
apiVersion: helm.hops.ops.com.ai/v1alpha1
kind: KServe
metadata:
  name: kserve
  namespace: my-namespace
spec:
  clusterName: my-cluster
```

## Configuration

| Field | Description | Default |
|-------|-------------|---------|
| `clusterName` | Name of the Kubernetes cluster | Required |
| `namespace` | Namespace to deploy KServe | `kserve` |
| `releaseName` | Helm release name | XR name |
| `deploymentMode` | KServe deployment mode | `Serverless` |
| `labels` | Labels to apply to resources | See below |
| `values` | Helm values (merged with defaults) | `{}` |
| `overrideAllValues` | Replace all default values | `{}` |
| `providerConfigRef` | Provider config reference | `{name: clusterName, kind: ProviderConfig}` |
| `managementPolicies` | Crossplane management policies | `["*"]` |

### Deployment Modes

| Mode | Description |
|------|-------------|
| `Serverless` | Uses Knative for scale-to-zero and autoscaling (default) |
| `RawDeployment` | Direct Kubernetes deployments without Knative |
| `Standard` | Kubernetes deployments with Istio gateway |

### Default Labels

```yaml
hops.ops.com.ai/managed: "true"
hops.ops.com.ai/kserve: "<name>"
```

## Examples

### Minimal (Serverless mode)

```yaml
apiVersion: helm.hops.ops.com.ai/v1alpha1
kind: KServe
metadata:
  name: kserve
  namespace: example-env
spec:
  clusterName: example-cluster
```

### RawDeployment Mode

```yaml
apiVersion: helm.hops.ops.com.ai/v1alpha1
kind: KServe
metadata:
  name: kserve
  namespace: example-env
spec:
  clusterName: example-cluster
  deploymentMode: RawDeployment
  labels:
    team: ml-platform
    environment: production
```

### Standard Mode with Istio

```yaml
apiVersion: helm.hops.ops.com.ai/v1alpha1
kind: KServe
metadata:
  name: kserve
  namespace: example-env
spec:
  clusterName: example-cluster
  deploymentMode: Standard
  values:
    kserve:
      controller:
        gateway:
          ingressGateway:
            className: istio
```

## Development

```bash
# Build the package
make build

# Render examples
make render

# Validate examples
make validate

# Run unit tests
make test

# Run E2E tests
make e2e
```

## Chart Information

- **Chart**: kserve
- **Repository**: oci://ghcr.io/kserve/charts
- **Version**: v0.16.0
