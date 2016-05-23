$location = (get-item -path ".\" -verbose).fullname

$patches = (Get-ChildItem -path $location -filter "*.msu").name

$i = 0
$date = (Get-Date).toString('MM-dd-yyyy')
$systemName = $env:computername

foreach($patch in $patches){
	$i++
	Write-Progress -id 1 -activity "Attempting to patch: $patch `($i of $($patches.count)`)" -percentComplete ($i / ($patches.Count)*100)
	Try{
		$argList = "$patch /install /quiet /norestart /log:$($date)_$($systemName)_$($patch).evtx"
		Start-Process -filepath 'C:\windows\system32\wusa.exe' -argumentList $argList -noNewWindow -Wait
		Write-Host "$patch applied"
	}
	Catch{
		Write-Host "$patch failed see logs"
	}
	Finally{
	rm *.dpx
	}
}