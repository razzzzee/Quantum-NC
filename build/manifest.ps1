# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License.

<#
    .SYNOPSIS
        Provides the list of artifacts (Packages and Assemblies) generated by this repository.
    
    .PARAMETER OutputFormat
        Specifies if the output of this script should be a hashtable with the artifacts
        as strings with the absolute path (AbsolutePath) or FileInfo structures.
#>
param(
    [ValidateSet('FileInfo','AbsolutePath')]
    [string] $OutputFormat = 'FileInfo'
);


& "$PSScriptRoot/set-env.ps1" | Out-Null

$artifacts = @{
    Packages = @(
        "Microsoft.Quantum.Research.Chemistry",
        "Microsoft.Quantum.Research.Characterization",
        "Microsoft.Quantum.Research"
    ) | ForEach-Object { Join-Path $Env:NUGET_OUTDIR "$_.$Env:NUGET_VERSION.nupkg" };

    Assemblies = @(
        ".\src\characterization\bin\$Env:BUILD_CONFIGURATION\netstandard2.1\Microsoft.Quantum.Research.Characterization.dll",
        ".\src\chemistry\bin\$Env:BUILD_CONFIGURATION\netstandard2.1\Microsoft.Quantum.Research.Chemistry.dll",
        ".\src\simulation\qsp\bin\$Env:BUILD_CONFIGURATION\netstandard2.1\Microsoft.Quantum.Research.Simulation.Qsp.dll"
    ) | ForEach-Object { Join-Path $PSScriptRoot (Join-Path ".." $_) };
}

if ($OutputFormat -eq 'FileInfo') {
    $artifacts.Packages = $artifacts.Packages | ForEach-Object { Get-Item $_ };
    $artifacts.Assemblies = $artifacts.Assemblies | ForEach-Object { Get-Item $_ };
}
    
$artifacts | Write-Output;
