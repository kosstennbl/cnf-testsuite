require 'cucumber'
require 'cucumber/cli/main'

Given("the following test on CNF is setup:") do |table|
    table.hashes.each do |row|
        @cnf_definition  = row['cnf_definition']
        @tested_scenario = row['tested_scenario']
     end
    system("./cnf-testsuite cnf_setup cnf-config=#{@cnf_definition}")
end

When("the cnti-testsuite is executed") do
    args = ["--require", "features", "../cnti-tests/features/" ,"--name", "#{@tested_scenario}", "--publish-quiet"]
    @exit_status = 0
    begin
        # Run Cucumber with the specified arguments
        Cucumber::Cli::Main.execute(args)
    rescue SystemExit => e
        @exit_status = e.status
    end
end

# Check if test passed
Then("the test passes") do
    expect(@exit_status).to eq(0)
end

Then("the test fails") do
    expect(@exit_status).not_to eq(0)
end
