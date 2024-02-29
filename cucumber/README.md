AI-generated human-edited documentation for better navigation through structure:
# CNF-testcatalog with cucumber documentation

## Project Structure

The project is structured around a set of Cucumber features and step definitions that define the tests to be run, as well as a set of Helm charts and configuration files that define the CNFs to be tested.

### Cucumber Features

Cucumber features are written in Gherkin language and describe the behavior of the CNFs. They are located in the `cucumber/features/docs` directory. Each feature file contains scenarios that describe the expected behavior of the CNF under test. Features that have defined corresponding CBPP are proposed to be separated from other tests.

### Step Defenitions

Step defenitions are written in the Ruby language, they are executable implementations of the steps from `.feature` files. They are located in `cucumber/features/lib/step_definitions` directory and follow similar structure as `.feature` files with an exception for steps that are shared between multiple features.

### Configuration Files

Configuration files are used to customize the behavior of the tests and the deployment of the CNFs. They are located in the `cucumber/config` directory. The main configuration file is `testcatalog-config.yml`, which specifies the path to the Helm chart for the CNF to be tested (and can be used for configuring many different parameters).

### Support Files

Support files are located in the `cucumber/features/lib/support` directory. These include Ruby files that define hooks and external tools used during the test run, such as Helm and Kyverno.

### Helm Charts

Helm charts are used to deploy the CNFs to a Kubernetes cluster. They are located in the `cucumber/cnf` directory, with each CNF having its own subdirectory or configuration file (same as cnf-testsuite.yml). The Helm charts include templates for Kubernetes resources such as Deployments, Services, ConfigMaps, and more.

## Running the Tests

To run the tests, you need to have Ruby and all required gems (from GemFile) installed.

The tests can be run using the `cucumber` command, with the appropriate profile specified in the `cucumber.yml` configuration file. For example, to run the default set of tests, you would use:

```sh
cucumber
```

To run a specific profile, such as the certification profile, you would use:

```sh
cucumber --profile certification
```

## Writing New Tests

To write new tests, you can add new scenarios to the existing feature files or create new feature files. Each scenario should describe the behavior of the CNF under test, and the step definitions should be implemented in the `step_definitions` directory.