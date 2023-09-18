function getTenantConnectionString{
	param(
		$tenant,
		$environment
	)
	
	$connStringVarName="CONN_STR_$($tenant.ToUpper())_$($environment.ToUpper())"	
	$connStr=[System.Environment]::GetEnvironmentVariable($connStringVarName)
	return $connStr	
}

function processFile {
    param (
        $currFile,
		$baseDataPath
    )

	write-host "Current file: $($currFile) for tenant '$($Matches.Tenant)' on environment '$($Matches.Env)'"
    if($currFile -match 'resources\/data\/(?<Tenant>.+)\/(?<Env>.+)\/config.json' ) # TODO: check if file exists
	{
		write-host "deploying config file $($currFile) for tenant '$($Matches.Tenant)' on environment '$($Matches.Env)'"
		$connStr=getTenantConnectionString $Matches.Tenant $Matches.Env
		dotnet run -- -f "$($baseDataPath)/$($currFile)" -c "$($connStr)" -t "Actions"
	}
	}else{
		write-host "skipping $($currFile)"
	}
}

function run{
	param(		
		$feederPath,
		$baseDataPath
	)
	
	git diff HEAD HEAD~ --name-only
	$changes=$(git diff HEAD HEAD~ --name-only)
	if($changes){
		pushd $feederPath		

		if($changes -is [array]){
			for ($i=0; $i -lt $changes.length; $i++) {
				processFile $changes[$i] $baseDataPath		
			}
		}else{
			processFile $changes $baseDataPath
		}

		popd
	}else{
		write-host "no relevant changes detected."
	}
}

run $args[0] $args[1]