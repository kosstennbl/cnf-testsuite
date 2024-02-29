Given("OPA is installed") do
  if !OPA.installed? do
    Log.info("Installing OPA to the cluster")
    OPA.install()
    Log.info("OPA installed")
  else do
    Log.info("OPA is already installed")
  end

Then ("None of the workload resource pods violate OPA {string} policy") do |opa_policy|
  opa_policy_split = opa_policy.split("/")
  opa_kind_name, opa_violation_name = opa_policy_split[0], opa_policy_split[1]
  output = OPA.policy_output(opa_kind_name, opa_violation_name)
  resources = KubectlClient.get_all_workload_resources()
  resources.each do |resource|
    pods = KubectlClient.get_resource_pods(resource)
    pods.each do |pod|
      pod_name = pod.dig("metadata", "name")
      policy_violation_regex = "/.*Pod #{pod_name}, it uses an image tag that is not versioned.*/"
      expect(output).not_to match(policy_violation_regex), "Pod/#{pod_name} in #{resource[:kind]}/#{resource[:name]} in #{resource[:namespace]} namespace does not use a versioned image"
    end
  end
end