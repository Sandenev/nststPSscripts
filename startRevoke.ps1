param ($serverAddr, $sitename)

# (tumakov): move to https://gitlab.nsysgroup.com/DevOps/NSYS.TOOLS-devops

# include common functions
. "DeployScripts/common.ps1"

$scriptPath = "C://nsys_deploy/"
$currentDir = ssh_exec "powershell (Get-WebFilePath 'IIS:\Sites\${sitename}').Name"
$backupPath = "${scriptPath}" + "${currentDir}_old"
ssh_copy "$serverAddr" ./DeployScripts "${scriptPath}"
ssh_exec "$serverAddr" "powershell ${scriptPath}DeployScripts/siteRevoke.ps1 -sitename ${sitename} -backupPath ${backupPath}"