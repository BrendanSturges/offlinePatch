Function Get-Folder($initialDirectory) {
    [Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") | Out-Null
    [System.Windows.Forms.Application]::EnableVisualStyles()
    $browse = New-Object System.Windows.Forms.FolderBrowserDialog
    $browse.RootFolder = [System.Environment+SpecialFolder]'MyComputer'
    $browse.ShowNewFolderButton = $false
    $browse.Description = "Choose patch source directory"

    $loop = $true
    while($loop)
    {
        if ($browse.ShowDialog() -eq "OK")
        {
            $loop = $false
        } else
        {
            $res = [System.Windows.Forms.MessageBox]::Show("You clicked Cancel. Try again or exit script?", "Choose a directory", [System.Windows.Forms.MessageBoxButtons]::RetryCancel)
            if($res -eq "Cancel")
            {
                return
            }
        }
    }
    $browse.SelectedPath
    $browse.Dispose()
}

$folderLoc = Get-Folder
$logLocation = (get-item -path ".\" -verbose).fullname

$patches = (Get-ChildItem -path $folderLoc -filter "*.msu").name

$i = 0

foreach($patch in $patches){
	$i++
	Write-Progress -id 1 -activity "Attempting to patch: $patch `($i of $($patches.count)`)" -percentComplete ($i / ($patches.Count)*100)
	Try{
		$argList = "$patch /install /quiet /norestart /log:$patch.evtx"
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