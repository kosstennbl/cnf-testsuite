Given("Kyverno is installed") do
  if !Kyverno.installed? do
    Log.info("Installing Kyverno to the cluster")
    Kyverno.install()
    Log.info("Kyverno installed")
  else do
    Log.info("Kyverno is already installed")
  end
end

Given('Kyverno policy {string} is present') do |policy_file_name|
  unless Kyverno.policy_present?(policy_file_name) do
    Log.info("Downloading Kyverno policy #{policy_file_name}")
    Kyverno.download_policy(policy_file_name)
  end
  Log.info("Kyverno policy is present")
end

Then("Kyverno policy {string} is ran without failures") do |policy_file_name|
  output = kyverno.run_policy(policy_file_name)
  expect(output).not_to match(/failure/i)
end