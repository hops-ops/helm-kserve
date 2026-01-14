import models.io.upbound.dev.meta.v1alpha1 as metav1alpha1
import models.k8s.apimachinery.pkg.apis.meta.v1 as metav1

# ==============================================================================
# Unit tests for KServe XRD
#
# Philosophy: Test YOUR API, not the provider's API.
# - render/validate already checks provider schema correctness
# - Tests should verify XRD spec fields produce expected behavior
# ==============================================================================

_items = [
    # ==========================================================================
    # Test 1: Minimal input renders Helm release with name defaulting to XR name
    # ==========================================================================
    metav1alpha1.CompositionTest {
        metadata.name = "minimal-renders-helm-release"
        spec = {
            compositionPath = "apis/kserves/composition.yaml"
            xrdPath = "apis/kserves/definition.yaml"
            timeoutSeconds = 60
            validate = False
            xr = {
                apiVersion = "helm.hops.ops.com.ai/v1alpha1"
                kind = "KServe"
                metadata.name = "test-kserve"
                spec = {
                    clusterName = "test-cluster"
                }
            }
            assertResources = [
                {
                    apiVersion = "helm.m.crossplane.io/v1beta1"
                    kind = "Release"
                    metadata.name = "test-kserve"
                }
            ]
        }
    }

    # ==========================================================================
    # Test 2: Custom labels are applied and merged with defaults
    # ==========================================================================
    metav1alpha1.CompositionTest {
        metadata.name = "custom-labels-merged-with-defaults"
        spec = {
            compositionPath = "apis/kserves/composition.yaml"
            xrdPath = "apis/kserves/definition.yaml"
            timeoutSeconds = 60
            validate = False
            xr = {
                apiVersion = "helm.hops.ops.com.ai/v1alpha1"
                kind = "KServe"
                metadata.name = "labeled-kserve"
                spec = {
                    clusterName = "test-cluster"
                    labels = {
                        team = "ml-platform"
                        environment = "staging"
                    }
                }
            }
            assertResources = [
                {
                    apiVersion = "helm.m.crossplane.io/v1beta1"
                    kind = "Release"
                    metadata = {
                        name = "labeled-kserve"
                        labels = {
                            "hops.ops.com.ai/managed" = "true"
                            "hops.ops.com.ai/kserve" = "labeled-kserve"
                            team = "ml-platform"
                            environment = "staging"
                        }
                    }
                }
            ]
        }
    }

    # ==========================================================================
    # Test 3: Deployment mode is configurable
    # ==========================================================================
    metav1alpha1.CompositionTest {
        metadata.name = "deployment-mode-rawdeployment"
        spec = {
            compositionPath = "apis/kserves/composition.yaml"
            xrdPath = "apis/kserves/definition.yaml"
            timeoutSeconds = 60
            validate = False
            xr = {
                apiVersion = "helm.hops.ops.com.ai/v1alpha1"
                kind = "KServe"
                metadata.name = "raw-kserve"
                spec = {
                    clusterName = "test-cluster"
                    deploymentMode = "RawDeployment"
                }
            }
            assertResources = [
                {
                    apiVersion = "helm.m.crossplane.io/v1beta1"
                    kind = "Release"
                    metadata.name = "raw-kserve"
                    spec.forProvider.values = {
                        kserve.controller.deploymentMode = "RawDeployment"
                    }
                }
            ]
        }
    }

    # ==========================================================================
    # Test 4: OCI chart repository is used
    # ==========================================================================
    metav1alpha1.CompositionTest {
        metadata.name = "oci-chart-repository"
        spec = {
            compositionPath = "apis/kserves/composition.yaml"
            xrdPath = "apis/kserves/definition.yaml"
            timeoutSeconds = 60
            validate = False
            xr = {
                apiVersion = "helm.hops.ops.com.ai/v1alpha1"
                kind = "KServe"
                metadata.name = "oci-test"
                spec = {
                    clusterName = "test-cluster"
                }
            }
            assertResources = [
                {
                    apiVersion = "helm.m.crossplane.io/v1beta1"
                    kind = "Release"
                    metadata.name = "oci-test"
                    spec.forProvider.chart = {
                        name = "kserve"
                        repository = "oci://ghcr.io/kserve/charts"
                        version = "v0.16.0"
                    }
                }
            ]
        }
    }
]

items = _items
