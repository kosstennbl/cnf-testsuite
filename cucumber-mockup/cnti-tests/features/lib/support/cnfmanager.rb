require 'securerandom'
require 'fileutils'
require 'yaml'


module CNFManager
  def cnf_install()
    cnf_install_location = Settings.cnf_install_location
    cnf_config_path = Settings.cnf_config_path
    namespace_folder = File.join(cnf_install_location, namespace)

    Dir.mkdir(namespace_folder) unless File.exists?(namespace_folder)
    FileUtils.cp_r("#{cnf_config_path}/.", namespace_folder)

    cnf_testsuite_path = File.join(namespace_folder, 'cnf-testsuite.yml')
    raise "cnf-testsuite.yml not found" unless File.exists?(cnf_testsuite_path)

    cnf_testsuite = YAML.load_file(cnf_testsuite_path)
    install_mode = cnf_testsuite['install_mode']

    if install_mode == 'repo'
      repository_name = cnf_testsuite['repository']['name']
      release_name = cnf_testsuite['release_name']
      repository_url = cnf_testsuite['repository_url']
      Helm.add_repo(repository, repository_url)
      Helm.install_chart(release_name, "#{repository_name}/#{release_name}", namespace)
    elsif install_mode == 'chart'
      Helm.install_chart(namespace, namespace_folder, namespace)
    end
  end

  def cnf_uninstall()
    cnf_testsuite_path = File.join(namespace_folder, 'cnf-testsuite.yml')
    raise "cnf-testsuite.yml not found" unless File.exists?(cnf_testsuite_path)

    cnf_testsuite = YAML.load_file(cnf_testsuite_path)
    release_name = cnf_testsuite['release_name']
    namespace = cnf_testsuite['namespace']

    Helm.uninstall_chart(release_name, namespace)

    Kubectl.delete_namespace(namespace)

    namespace_folder = File.join(Settings.cnf_install_location, namespace)
    FileUtils.rm_rf(namespace_folder)
 end
end
