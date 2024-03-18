# Hooks can be used to perform some actions before or after tests
# and before/after test runs.
# This can be used for preparation of environment and robust cleanup

BeforeAll do
  Configuration::config_init
end

Before("@skip") do
  skip_this_scenario
end