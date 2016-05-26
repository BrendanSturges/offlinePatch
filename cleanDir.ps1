$includeFiles = ("*.msu","*.exe")
Get-ChildItem -recurse -include $includeFiles | % {Copy-Item -path $_.FullName -Destination (get-item -path ".\" -verbose).fullname}