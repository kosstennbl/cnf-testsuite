Feature: Sample feature for demonstration purposes

    Demonstration of point system and different Cucumber features
    Background: Common background
        This step will be executed before each scenario in this feature
        Given common step

    @points-1
    Rule: Test rule 1
        Example: FAIL
            Given failing step

    @points-4
    Rule: Test rule 2
        Text below rules is not shown in output and can be used for documentation

        Example: SUCCESS
            This is written inside example and will be shown in the output
            Also, EMOJIS! 🏷️ ✔️ (do we really need them?)
            # Comments like this - are not
            Given success step

    @points-2
    Rule: Test rule 3
        Example: PENDING
            Cucumber allows two ways of skipping tests:
            One is done before running test, in "Before" hook
            Second is done at the runtime, it gives scenario result "pending"
            Current demo implementation of ponits system ignores skipped tests.

            Given skip step

    @points-3
    Rule: Test rule 4
        @skip
        Example: SKIPPED
            This test will be skipped even with success step
            Because of the hook, that is connected to "@skip" tag (check hooks.rb)
            Given success step