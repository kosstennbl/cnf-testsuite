Feature: CNF Configuration test verification
    Verification that configuration testing working correctly.

    Scenario: CNF does not have the app.kubernetes.io/name label
        Given the following test on CNF is setup:
            | cnf_definition                                  | tested_scenario                                       |
            | sample-cnfs/sample_nonroot/cnf-testsuite.yml    | Require app.kubernetes.io/name label for all K8s pods |
        When the cnti-testsuite is executed
        Then the test fails

    Scenario: CNF has the app.kubernetes.io/name label
        Given the following test on CNF is setup:
            | cnf_definition                                  | tested_scenario                                       |
            | sample-cnfs/sample_coredns/cnf-testsuite.yml    | Require app.kubernetes.io/name label for all K8s pods |
        When the cnti-testsuite is executed
        Then the test passes
    
    Scenario: CNF has image tags that are not versioned
        Given the following test on CNF is setup:
            | cnf_definition                                                 | tested_scenario                           |
            | sample-cnfs/k8s-sidecar-container-pattern/cnf-testsuite.yml    | Versioned tag should be used for CNF pods |
        When the cnti-testsuite is executed
        Then the test fails

    Scenario: CNF has image tags that are versioned
        Given the following test on CNF is setup:
            | cnf_definition                                    | tested_scenario                           |
            | sample-cnfs/sample_coredns/cnf-testsuite.yml      | Versioned tag should be used for CNF pods |
        When the cnti-testsuite is executed
        Then the test passes 

    Scenario: Hardcoded IP addresses in k8 configuration
        Given the following test on CNF is setup:
            | cnf_definition                                                | tested_scenario                                                   |
            | sample-cnfs/sample_coredns_hardcoded_ips/cnf-testsuite.yml    | Avoid hardcoded IP address in K8s workload resource configuration |
        When the cnti-testsuite is executed
        Then the test fails

    Scenario: No hardcoded IP addresses in k8 configuration
        Given the following test on CNF is setup:
            | cnf_definition                                  | tested_scenario                                                   |
            | sample-cnfs/sample_coredns/cnf-testsuite.yml    | Avoid hardcoded IP address in K8s workload resource configuration |
        When the cnti-testsuite is executed
        Then the test passes
