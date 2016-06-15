$patches = Get-Childitem *.msu
$patches | Foreach-Object {wusa $_ /quiet /norestart | Wait-Process }