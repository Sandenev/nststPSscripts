$ssh_login = "ssh"
$ssh_port = "2244"

function get_env {
	param (
		$name
	)
	(Get-ChildItem -Path ENV:${name}).Value
}

$ssh_private_key = get_env "SSH_PRIVATE_TEST"
# materialize ssh key
New-Item -Path ~/.ssh -Name "privateKey" -ItemType "file" -Value "${ssh_private_key}" -f

function ssh_exec {
	param (
		$serverAddr,
		$cmd
	)
	"execute '$cmd' on server '$serverAddr'"
	
	ssh -o StrictHostKeyChecking=no -i ~/.ssh/privateKey -p "$ssh_port" "${ssh_login}@${serverAddr}" "$cmd"
}

function ssh_copy {
	param (
	    $serverAddr,
		$source,
		$target
	)
	"copy '$source' to server '$serverAddr', path '$target'"
	
	scp -o StrictHostKeyChecking=no -i ~/.ssh/privateKey -P "$ssh_port" -r "${source}" "${ssh_login}@${serverAddr}:${target}"
}

function start_site {
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