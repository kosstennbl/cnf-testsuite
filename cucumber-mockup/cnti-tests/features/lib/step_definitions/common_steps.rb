Given("Cnf is deployed") do
  if !CNFManager.cnf_installed? do
    Log.info("Installing CNF from #{Settings.cnf_location} file")
    CNFManager.cnf_install()
    Log.info("CNF installed")
  else do
    Log.info("CNF is already installed")
  end
end