module Helm
  def run_helm_command(command, params = [], namespace = "")
    helm_binary = Settings.helm_binary
    namespace_param = namespace.empty? "" : "--namespace #{namespace}"
    command = "#{helm_binary} #{command} #{params.join(" ")} #{namespace_param}"
    IO.popen(command) do |io|
      result = io.read
    end
    result

  def add_repo(name, url)
    result = run_helm_command("repo add", [name, url])
    raise "Failed to add #{url} Helm repository. Please check your Helm installation and try again." unless result
    result = run_helm_command("repo update")
    raise "Failed to update Helm repositories. Please check your Helm installation and try again." unless result
  end
 
  def install_chart(name, path, namespace = "")
    result = run_helm_command("install", [name, path, "--create-namespace", "--wait"], namespace: namespace)
    raise "Failed to install #{name} chart. Please check your Kubernetes cluster and try again." unless result
  end
 
  def uninstall_chart(name, path, namespace = "")
    result = run_helm_command("uninstall" [name, path], namespace: namespace)
    raise "Failed to uninstall #{name} chart. Please check your Kubernetes cluster and try again." unless result
  end
end