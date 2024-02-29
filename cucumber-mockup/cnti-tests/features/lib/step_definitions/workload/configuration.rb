Given ("CNF is deployed in dry mode") do
  if !CNFManager.cnf_installed? do
    Log.info("Installing CNF in dry-run from #{Config.cnf_location} file")
    CNFManager.cnf_install(params:['--dry-run'])
    Log.info("CNF installed")
  else do
    Log.info("CNF is already installed")
  end
end

Then ("Helm files do not contain hardcoded ip addresses") do
  cnf_installation_dir = config['cnf_installation_dir']
  chart_path = "#{cnf_installation_dir}/helm_chart.yml"

  File.foreach(chart_path).with_index do |line, line_number|
    next if line =~ /NOTES:/
    match = line.match("/([0-9]{1,3}[\.]){3}[0-9]{1,3}/")
    if match[0] != "0.0.0.0" && match[0] != "127.0.0.1" do
      raise "Runtime Helm configuration at #{chart_path} contains hardcoded ip address on line #{line_number}"
    file_content = File.read(file_path)
    expect(file_content).not_to match(ip_regex), "File #{file_path} contains a fixed IP address."
  end
end