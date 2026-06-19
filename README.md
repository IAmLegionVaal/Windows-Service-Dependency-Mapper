# Windows Service Dependency Mapper

A read-only PowerShell toolkit for mapping Windows service dependencies and status.

## Features

- Service state and startup type
- Required and dependent services
- Dependency relationship export
- CSV, JSON, and HTML reports

## Run

```powershell
powershell.exe -ExecutionPolicy Bypass -File .\Windows_Service_Dependency_Mapper.ps1
```

## Safety

Read-only reporting only. No services are changed.
