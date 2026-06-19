#requires -Version 5.1
[CmdletBinding()]
param([string]$OutputPath)
$stamp=Get-Date -Format 'yyyyMMdd_HHmmss'
if([string]::IsNullOrWhiteSpace($OutputPath)){$OutputPath=Join-Path ([Environment]::GetFolderPath('Desktop')) 'Service_Dependency_Reports'}
New-Item -ItemType Directory -Path $OutputPath -Force|Out-Null
$services=Get-CimInstance Win32_Service|Select-Object Name,DisplayName,State,StartMode,StartName,ProcessId
$relations=@()
foreach($svc in Get-Service){foreach($required in $svc.ServicesDependedOn){$relations+=[PSCustomObject]@{Service=$svc.Name;Relationship='Requires';RelatedService=$required.Name}};foreach($dependent in $svc.DependentServices){$relations+=[PSCustomObject]@{Service=$svc.Name;Relationship='RequiredBy';RelatedService=$dependent.Name}}}
$services|Export-Csv (Join-Path $OutputPath "services_$stamp.csv") -NoTypeInformation -Encoding UTF8
$relations|Export-Csv (Join-Path $OutputPath "service_dependencies_$stamp.csv") -NoTypeInformation -Encoding UTF8
@{Computer=$env:COMPUTERNAME;Generated=Get-Date;Services=$services;Dependencies=$relations}|ConvertTo-Json -Depth 6|Set-Content (Join-Path $OutputPath "service_map_$stamp.json") -Encoding UTF8
$html="<h1>Windows Service Dependency Map - $env:COMPUTERNAME</h1><p>Generated $(Get-Date)</p><h2>Services</h2>$($services|ConvertTo-Html -Fragment)<h2>Dependencies</h2>$($relations|ConvertTo-Html -Fragment)"
$html|ConvertTo-Html -Title 'Service Dependency Map'|Set-Content (Join-Path $OutputPath "service_map_$stamp.html") -Encoding UTF8
Write-Host "Reports saved to: $OutputPath" -ForegroundColor Green
