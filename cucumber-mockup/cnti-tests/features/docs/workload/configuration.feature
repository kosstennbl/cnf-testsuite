Feature: CNF configuration

    @cbpp-0010
    @cert
    Scenario: Require app.kubernetes.io/name label for all K8s pods
        # Reasoning: Defining and using labels help identify semantic attributes of an application or Deployment.
        #            A common set of labels allows tools to work collaboratively, while describing objects in a common manner that all tools can understand.
        #            Recommended labels should be used to describe applications in a way that can be queried.
        # Remediation: Make sure to define app.kubernetes.io/name label under metadata for your CNF.
        Given CNF is deployed
        And Kyverno is installed
        And Kyverno policy "require_labels.yaml" is present
        This policy checks labels for all pods and fails if any of them is missing "name" label
        Then Kyverno policy "require_labels.yaml" is ran without failures

    @cbpp-0009
    Scenario: Versioned tag should be used for CNF pods
        # Reasoning: "latest" tag should be avoided when deploying containers in production as it is harder to track
        #            which version of the image is running and more difficult to roll back properly.
        # Remediation: When specifying container images, always specify a tag and ensure to use an immutable tag that maps to a specific version of an application Pod.
        #              Remove any usage of the latest tag, as it is not guaranteed to be always point to the same version of the image.
        Given CNF is deployed
        And OPA is installed
        Then None of the workload resource pods violate OPA "requiretags/block-latest-tag" policy

    @cbpp-0008
    @cert @essential
    @points_pass(100)
    Scenario: Avoid hardcoded IP address in K8s workload resource configuration
        # Reasoning: Using a hard coded IP in a CNF's configuration designates how (imperative) a CNF should achieve a goal, not what (declarative) goal the CNF should achieve
        # Remediation: Review all Helm Charts & Kubernetes Manifest files of the CNF and look for any hardcoded usage of ip addresses.
        #              If any are found, you will need to use an operator or some other method to abstract the IP management out of your configuration in order to pass this test.
        Given CNF is deployed in dry mode
        Then Helm files do not contain hardcoded ip addresses