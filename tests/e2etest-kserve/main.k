import models.io.upbound.dev.meta.v1alpha1 as metav1alpha1
import models.k8s.apimachinery.pkg.apis.meta.v1 as metav1

# ==============================================================================
# E2E test for KServe XRD
# ==============================================================================

_items = [
    metav1alpha1.CompositionTest {
        metadata.name = "e2e-kserve"
        spec = {
            compositionPath = "apis/kserves/composition.yaml"
            xrdPath = "apis/kserves/definition.yaml"
            timeoutSeconds = 600
            validate = True
            xr = {
                apiVersion = "helm.hops.ops.com.ai/v1alpha1"
                kind = "KServe"
                metadata.name = "e2e-kserve"
                spec = {
                    clusterName = "e2e-cluster"
                    namespace = "kserve"
                    deploymentMode = "RawDeployment"
                }
            }
        }
    }
]

items = _items
