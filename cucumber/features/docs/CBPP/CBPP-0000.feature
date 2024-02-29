@CBPP-0000 @wip
# @wip tag is used there so cucumber output wouldn't be littered with these empty scenarios
Feature: Example for structure of .feature files for CBPP
    My proposal is to have separate feature file for each CBPP.
    Each feature file will have all the tests, that are needed to ensure the policy
    This will allow for better connection between best practices and testcatalog

    Rule: Test-1
        Here is the place for short test description

        Example: Test implementation 1-1
            Most of the tests will likely have only one implementation but in cases,
            where several implementations are needed - this way of having rule as definition
            and examples as implementations looks to work well.
            Most of the tags would be common for different implementations of the same test, and 
            the differences - could be expressed in the example tags.
        
        @wip
        Example: Test implementation 1-2
            Some in-progress things, that don't have actual implementation yet,
            could be at least written in Gherkin and marked as "@wip".
            This will allow better communication in community, as it both shows a
            nice way to contribute and provides documentation on what is expected from that implementation.

    @manual
    Rule: Test-2
        Some tests could be manual only, then this Gherkin documentation will serve as a guide
        on preforming this manual test.

        Example: Manual test guide 2-1


