param ($sitename, $workingDir, $newVersionDir)

. "$workingDir/DeployScripts/common_iis.ps1"

"run siteChange.ps1, sitename: '$sitename', workingDir: '$workingDir', newVersionDir: '$newVersionDir'"

$CurrentPath = (Get-Website "$sitename" | Select-Object).PhysicalPath
"PhysicalPath of site '$sitename': '$CurrentPath'"
$CurrentDirName = ($CurrentPath -split '\\')[-1]

"directory name: '$CurrentDirName'"

$OldDirName = $workingDir + "${CurrentDirName}_old"
"old directory name: '$OldDirName'"

site_stop "$sitename"

"Test to see if folder [$CurrentPath]  exists"
if (Test-Path -Path $CurrentPath) {
    
	"Remove old backup directory '$OldDirName'"
	if (Test-Path -Path $OldDirName) {
		Remove-Item -Path $OldDirName -Force -Recurse
	}
	
	"moving '$CurrentPath' to '$OldDirName'"
	$attempts = 0
	while ($attempts -le 10) {
		try {
			Move-Item -Path $CurrentPath -Destination $OldDirName -Force -ErrorAction STOP
		} catch {
			$attempts++
			sleep 1
		}
	}
	
    "Folder '$CurrentPath' did exist and now renamed as '$OldDirName'"
} else {
    "Folder doesn't exist."
}
Move-Item -Path $newVersionDir -Destination $CurrentPath -Force -ErrorAction STOP
"New version was moved to working directory"

site_start "$sitename"