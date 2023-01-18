param ($sitename, $backupPath)
$sitePath = (Get-Website "$sitename" | Select-Object).PhysicalPath

# (tumakov): move to https://gitlab.nsysgroup.com/DevOps/NSYS.TOOLS-devops

. "$workingDir/DeployScripts/common_iis.ps1"

site_stop $sitename
"Test to see if folder [$backupPath]  exists"
if (Test-Path -Path $backupPath) {
	"deleting current version"
    Remove-Item -Path $sitePath -Force -Recurse
	"move old version to current"
    Move-Item -Path $backupPath -Destination $sitePath -Force -ErrorAction STOP
    ""
	Write-Host "Folder [$backupPath] did exist and now renamed as [$sitePath]"
} else {
    "Folder doesn't exist."
}
site_start $sitename
"$sitename site is running now"