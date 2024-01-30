require "sam"
require "file_utils"
require "colorize"
require "totem"
require "./utils/utils.cr"
# require "./utils/tar.cr"
require "tar"

CHAOS_MESH_VERSION = "v0.8.0"
CHAOS_MESH_OFFLINE_DIR = "#{TarClient::TAR_REPOSITORY_DIR}/chaos-mesh_chaos-mesh"

desc "Install Chaos Mesh"
task "install_chaosmesh" do |_, args|
  Log.for("verbose").info { "install_chaosmesh" } if check_verbose(args)
  current_dir = FileUtils.pwd 
    helm = Helm::BinarySingleton.helm
    # KubectlClient::Apply.file("https://raw.githubusercontent.com/chaos-mesh/chaos-mesh/#{CHAOS_MESH_VERSION}/manifests/crd.yaml")

    if args.named["offline"]?
      Log.info { "install chaos mesh offline mode" }
      helm_chart = Dir.entries(CHAOS_MESH_OFFLINE_DIR).first
      Helm.install("my-chaos-mesh #{CHAOS_MESH_OFFLINE_DIR}/#{helm_chart} --version 0.5.1")

    else
      # `helm repo add chaos-mesh https://charts.chaos-mesh.org`
      # `helm install my-chaos-mesh chaos-mesh/chaos-mesh --version 0.5.1`
      Helm.helm_repo_add("chaos-mesh","https://charts.chaos-mesh.org")
      Helm.install("my-chaos-mesh chaos-mesh/chaos-mesh --version 0.5.1")
    end

  File.write("chaos_network_loss.yml", CHAOS_NETWORK_LOSS)
  File.write("chaos_cpu_hog.yml", CHAOS_CPU_HOG)
  File.write("chaos_container_kill.yml", CHAOS_CONTAINER_KILL)
  ChaosMeshSetup.wait_for_resource("chaos_network_loss.yml")
  ChaosMeshSetup.wait_for_resource("chaos_cpu_hog.yml")
  ChaosMeshSetup.wait_for_resource("chaos_container_kill.yml")
end

desc "Uninstall Chaos Mesh"
task "uninstall_chaosmesh" do |_, args|
  Log.for("verbose").info { "uninstall_chaosmesh" } if check_verbose(args)
  current_dir = FileUtils.pwd
  helm = Helm::BinarySingleton.helm
  cmd = "#{helm} delete my-chaos-mesh > /dev/null 2>&1"
  status = Process.run(
    cmd,
    shell: true,
    output: output = IO::Memory.new,
    error: stderr = IO::Memory.new
  )
end

module ChaosMeshSetup

  def self.wait_for_test(test_type, test_name)
    second_count = 0
    wait_count = DV_CHAOS_MESH_TEST_TIMEOUT
    status = ""
    until (status.empty? != true && status == "Finished") || second_count > wait_count.to_i
      Log.debug { "second_count = #{second_count}" }
      sleep 1
      cmd = "kubectl get #{test_type} #{test_name} -o json "
      Log.info { cmd }
      status = Process.run(cmd,
                           shell: true,  
                             output: output = IO::Memory.new,  
                             error: stderr = IO::Memory.new) 
      Log.info { "KubectlClient.exec output: #{output.to_s}" }
      Log.info { "KubectlClient.exec stderr: #{stderr.to_s}" }
      get_status = output.to_s 
      if get_status && !get_status.empty? 
        status_data = JSON.parse(get_status) 
      else 
        status_data = JSON.parse(%({})) 
      end 
      Log.info { "Status: #{get_status}" }
      status = status_data.dig?("status", "experiment", "phase").to_s
      second_count = second_count + 1
      Log.info { "#{get_status}" }
      Log.info { "#{second_count}" }
    end
    # Did chaos mesh finish the test successfully
    # (status.empty? !=true && status == "Finished")
    true
  end

  # TODO make generate without delete?
  def self.wait_for_resource(resource_file)
    second_count = 0
    wait_count = DV_CHAOS_MESH_RESOURCE_TIMEOUT
    is_resource_created = nil
    until (is_resource_created.nil? != true && is_resource_created == true) || second_count > wait_count.to_i
      Log.info { "second_count = #{second_count}" }
      sleep 1
      cmd = "kubectl create -f #{resource_file} 2>&1 >/dev/null"
      status = Process.run(
        cmd,
        shell: true,
        output: output = IO::Memory.new,
        error: stderr = IO::Memory.new
      )
      is_resource_created = status.success?
      Log.info { "Waiting for CRD" }
      Log.info { "Status: #{is_resource_created}" }
      Log.debug { "resource file: #{resource_file}" }
      second_count = second_count + 1
    end
    KubectlClient::Delete.file(resource_file)
  end
end
