class Kyverno
  def initialize
    @helm = Helm.new
  end

  def installed?
    system("kyverno version")
  end

  def install
    unless installed?
      puts "Kyverno is not installed. Attempting to install the latest version via Helm."
      @helm.add_repo("kyverno", "https://kyverno.github.io/kyverno/")
      @helm.install_chart("kyverno", "kyverno/kyverno")
      puts "Kyverno installation successful."
    else
      puts "Kyverno is already installed."
    end
  end

  def uninstall
     if installed?
       puts "Uninstalling Kyverno..."
       @helm.uninstall_chart("kyverno", "kyverno/kyverno")
       puts "Kyverno uninstalled successfully."
       cleanup_webhooks
     else
       puts "Kyverno is not installed"
     end
  end

  def cleanup_webhooks
    mutating_webhooks = [
        "kyverno-policy-mutating-webhook-cfg",
        "kyverno-resource-mutating-webhook-cfg",
        "kyverno-verify-mutating-webhook-cfg"
      ]

    validating_webhooks = [
      "kyverno-policy-validating-webhook-cfg",
      "kyverno-resource-validating-webhook-cfg",
      "kyverno-cleanup-validating-webhook-cfg",
      "kyverno-exception-validating-webhook-cfg"
    ]
    system("kubectl delete mutatingwebhookconfigurations #{mutating_webhooks.join(' ')}")
    system("kubectl delete validatingwebhookconfigurations #{validating_webhooks.join(' ')}")
    if !system("kubectl get mutatingwebhookconfigurations,validatingwebhookconfigurations")
      puts "Webhooks cleaned up successfully."
    else
      raise "Failed to clean up webhooks. Please check your Kubernetes cluster and try again."
    end
  end

  def run_policy(policy_file_path)
    kubectl_command = "kubectl kyverno apply #{policy_file_path}"
    output = `#{kubectl_command}`
  end
end
   