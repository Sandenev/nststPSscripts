function get_env {
	param (
		$name
	)
	(Get-ChildItem -Path ENV:${name}).Value
}

function site_start {
	param (
		$sitename
	)
	
	"Starting $sitename..."
	try {
		Start-IISSite -Name $sitename
	} catch {
		appcmd start apppool $sitename
	}
	"$sitename site is running now"
}

function site_stop {
	param (
		$sitename
	)
	
	"stopping site '$sitename'..."
	try {
		Stop-IISSite -Name $sitename -Confirm:$False
	} catch {
		appcmd stop apppool $sitename
	}
	"$sitename site was stopped"
}
