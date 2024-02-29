require 'net/http'
require 'uri'
require 'fileutils'
require 'rspec'


KYVERNO_POLICIES_DIR = 'kyverno/policies'

Given("CNF helm chart folder") do
  helm_chart_path = config['helm_chart_path']

  unless Dir.exist?(helm_chart_path)
    raise "Helm chart directory does not exist at #{helm_chart_path}"
  end

  chart_file_path = File.join(helm_chart_path, 'Chart.yaml')
  unless File.exist?(chart_file_path)
    raise "Chart.yml file does not exist in the helm chart directory at #{helm_chart_path}"
  end
end

Then("Yml files do not contain fixed ip addresses") do
  helm_chart_path = config['helm_chart_path']
  ip_regex = /^(?!.+0\.0\.0\.0)(?![[:space:]]*0\.0\.0\.0)(?!#)(?![[:space:]]*#)(?!\/\/)(?![[:space:]]*\/\/)(?!\/\\*)(?![[:space:]]*\/\\*)(.+([0-9]{1,3}[\.]){3}[0-9]{1,3})/

  Dir.glob("#{helm_chart_path}/**/*").each do |file_path|
    next if File.directory?(file_path) || File.extname(file_path) == '.txt'

    file_content = File.read(file_path)
    expect(file_content).not_to match(ip_regex), "File #{file_path} contains a fixed IP address."
  end
end

Given("Kyverno is installed") do
  kyverno.install
 end
 
Given('Kyverno policy {string} is present') do |file_name|
  base_url = 'https://raw.githubusercontent.com/kyverno/policies/main/best-practices/'

  FileUtils.mkdir_p(KYVERNO_POLICIES_DIR)
  policy_file_path = File.join(KYVERNO_POLICIES_DIR, file_name)
  unless File.exist?(policy_file_path)
    file_name_without_yaml = file_name.sub(/\.yaml$/, '')
    download_url = URI.parse(base_url + file_name_without_yaml + "/" + file_name)

    Net::HTTP.start(download_url.host, download_url.port, use_ssl: true) do |http|
      resp = http.get(download_url.path)
      open(policy_file_path, 'wb') do |file|
        file.write(resp.body)
      end
    end
  end
end

Then("Kyverno policy {string} is ran without failures") do |file_name|
  policy_file_path = KYVERNO_POLICIES_DIR + file_name
  output = kyverno.run_policy(policy_file_path)
  expect(output).not_to match(/failure/i)
end
