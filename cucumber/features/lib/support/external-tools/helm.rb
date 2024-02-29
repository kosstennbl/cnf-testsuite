class Helm
  def add_repo(name, url)
    result = system("helm repo add #{name} #{url}")
    raise "Failed to add #{url} Helm repository. Please check your Helm installation and try again." unless result
    result = system("helm repo update")
    raise "Failed to update Helm repositories. Please check your Helm installation and try again." unless result
  end
 
  def install_chart(name, path)
    result = system("helm install #{name} #{path} --namespace #{name} --create-namespace")
    raise "Failed to install #{name} chart. Please check your Kubernetes cluster and try again." unless result
  end
 
  def uninstall_chart(name, path)
    result = system("helm uninstall #{name} #{path} --namespace #{name}")
    raise "Failed to uninstall #{name} chart. Please check your Kubernetes cluster and try again." unless result
  end
 end
 