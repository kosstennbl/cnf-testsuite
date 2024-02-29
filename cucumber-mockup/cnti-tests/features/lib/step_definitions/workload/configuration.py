from behave import given, then
import re
import os


@given("CNF is deployed in dry mode")
def step_given_cnf_deployed_in_dry_mode(context):
    if not CNFManager.cnf_installed():
        logging.info(f"Installing CNF in dry-run from {context.config.cnf_location} file")
        CNFManager.cnf_install(params=['--dry-run'])
        logging.info("CNF installed")
    else:
        logging.info("CNF is already installed")

@then("Helm files do not contain hardcoded ip addresses")
def step_then_helm_files_do_not_contain_hardcoded_ip_addresses(context):
    cnf_installation_dir = context.config['cnf_installation_dir']
    chart_path = os.path.join(cnf_installation_dir, "helm_chart.yml")

    ip_regex = re.compile(r"\b(?:[0-9]{1,3}\.){3}[0-9]{1,3}\b")
    with open(chart_path, 'r') as file:
        for line_number, line in enumerate(file, start=1):
            if "NOTES:" in line:
                continue
            match = ip_regex.search(line)
            if match and match.group(0) not in ["0.0.0.0", "127.0.0.1"]:
                raise Exception("Runtime Helm configuration at {} contains hardcoded ip address on line {}".format(chart_path, line_number))
