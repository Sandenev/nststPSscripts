param ($serverAddr, $product, $sitename)

# include common functions
. "DeployScripts/common.ps1"

$nsys_deploy_path = "C://nsys_deploy/"
$change = "${nsys_deploy_path}" + ${product}

# build project
dotnet build -c Release Presentation/$product/
dotnet publish -c Release -o build/$product Presentation/$product/

# copy builded app
ssh_copy "$serverAddr" "./build/$product" "${nsys_deploy_path}"

# copy scripts
ssh_copy "$serverAddr" "./DeployScripts" "${nsys_deploy_path}"

# run script
ssh_exec "$serverAddr" "powershell ${nsys_deploy_path}/DeployScripts/siteChange.ps1 -sitename $sitename -workingDir $nsys_deploy_path -newVersionDir ${change}"
