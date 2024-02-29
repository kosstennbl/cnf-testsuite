Feature: CNF configuration is following defined best practices

    This feature shows how different cucumber features can be used for testcatalog tests.
    It isn't a clear representation of proposed final look of the .feature files, for that - check "cucumber-mockup" directory

    @certification @configuration
    Rule: Helm chart does not contain any fixed ip addresses

        This is a functional test

        @regex
        Example: No fixed ip -- by search through chart .yaml files
            Given CNF helm chart folder
            Then Yml files do not contain fixed ip addresses

    @wip 
    Rule: CNF doesn't use container images with the latest tag

        This shows how one test could be implemented in different ways or using different tools.
        Selection of tools and ways could be then done using tags or configuration files (preffered)

        @kyverno
        Example: No latest tag -- using Kyverno policy
            Given CNF is installed
            And Kyverno is installed
            And Kyverno policy "disallow_latest_tag.yaml" is present
            Then Kyverno policy "disallow_latest_tag.yaml" is ran without failures
    
        @othertool
        Example: No latest tag -- using OtherTool test
            Given CNF is installed
            And OtherTool is installed
            And OtherTool test "other_disallow_latest_tag.yaml" is present
            Then OtherTool test "other_disallow_latest_tag.yaml" is ran without failures

    @wip
    Rule: CNF doesn't install its resources in default namespace

        Example of reusing steps for different tests
        
        @kyverno
        Example: No default namespace -- using Kyverno policy
            Given CNF is installed
            And Kyverno is installed
            And Kyverno policy "disallow_default_namespace.yaml" is present
            Then Kyverno policy "disallow_default_namespace.yaml" is ran without failures
