$includeFiles = ("*.msu","*.exe")
$patches = Get-ChildItem -include $includeFiles -recurse
$patchNames = $patches | Select-Object $_.Name

# Originally I wanted the previous two lines to look like:
# $patches = (Get-ChildItem -include $includeFiles -recurse).Name 
# Like a sane person, but server 2008 with PS 2.0 would break on this for some reason, even though I wrote the thing in PS2.0 on Win7!

$i = 0
$date = (Get-Date).toString('MM-dd-yyyy')
$systemName = $env:computername

foreach($patch in $patchNames){
	$i++
	Write-Progress -id 1 -activity "Attempting to patch: $i of $($patchNames.count)" -percentComplete ($i / ($patchNames.Count)*100)
	Try{
		$argList = "/install /quiet /norestart /log:$($date)_$($systemName)_$($patch).evtx"
		Start-Process $patch -argumentList $argList -noNewWindow -Wait
		Write-Host "$patch applied"
	}
	Catch{
		Write-Host "$patch failed see logs!" -foregroundcolor "blue" -backgroundcolor "yellow"
	}
	Finally{
	rm *.dpx
	}
}
