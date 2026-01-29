<#
.SYNOPSIS
    Unity Package Template Setup Script
.DESCRIPTION
    Creates a standard Unity package structure with all required files and configurations.
.PARAMETER TargetPath
    The target directory where the Unity package will be created.
.EXAMPLE
    .\Setup-UnityPackage.ps1 -TargetPath "C:\MyUnityPackages\MyAwesomePackage"
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory=$false)]
    [string]$TargetPath
)

# Set error action preference
$ErrorActionPreference = "Stop"

# Script banner
Write-Host @"
╔═══════════════════════════════════════════════════════════╗
║                                                           ║
║        Unity Package Template Setup Script               ║
║                                                           ║
╚═══════════════════════════════════════════════════════════╝
"@ -ForegroundColor Cyan

Write-Host ""

# Function to get user input with validation
function Get-UserInput {
    param(
        [string]$Prompt,
        [string]$Default = "",
        [bool]$Required = $false,
        [scriptblock]$Validator = $null
    )
    
    do {
        if ($Default) {
            $userInput = Read-Host "$Prompt [$Default]"
            if ([string]::IsNullOrWhiteSpace($userInput)) {
                $userInput = $Default
            }
        } else {
            $userInput = Read-Host $Prompt
        }
        
        if ($Required -and [string]::IsNullOrWhiteSpace($userInput)) {
            Write-Host "This field is required. Please provide a value." -ForegroundColor Yellow
            continue
        }
        
        if ($Validator -and -not [string]::IsNullOrWhiteSpace($userInput)) {
            $validationResult = & $Validator $userInput
            if (-not $validationResult) {
                Write-Host "Invalid input. Please try again." -ForegroundColor Yellow
                continue
            }
        }
        
        break
    } while ($true)
    
    return $userInput
}

# Function to create directory if it doesn't exist
function New-DirectoryIfNotExists {
    param([string]$Path)
    
    if (-not (Test-Path $Path)) {
        New-Item -ItemType Directory -Path $Path -Force | Out-Null
        Write-Host "  ✓ Created: $Path" -ForegroundColor Green
    } else {
        Write-Host "  • Already exists: $Path" -ForegroundColor Gray
    }
}

# Function to create a file with content
function New-FileWithContent {
    param(
        [string]$Path,
        [string]$Content
    )
    
    if (-not (Test-Path $Path)) {
        $Content | Out-File -FilePath $Path -Encoding UTF8
        Write-Host "  ✓ Created: $Path" -ForegroundColor Green
    } else {
        Write-Host "  • Already exists: $Path" -ForegroundColor Gray
    }
}

# Function to get license text
function Get-LicenseText {
    param(
        [string]$LicenseType,
        [string]$Author,
        [string]$Year
    )
    
    switch ($LicenseType) {
        "MIT" {
            return @"
MIT License

Copyright (c) $Year $Author

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
"@
        }
        "Apache-2.0" {
            return @"
Apache License
Version 2.0, January 2004
http://www.apache.org/licenses/

Copyright $Year $Author

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
"@
        }
        "GPL-3.0" {
            return @"
GNU GENERAL PUBLIC LICENSE
Version 3, 29 June 2007

Copyright (C) $Year $Author

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.
"@
        }
        "BSD-3-Clause" {
            return @"
BSD 3-Clause License

Copyright (c) $Year, $Author
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation
   and/or other materials provided with the distribution.

3. Neither the name of the copyright holder nor the names of its
   contributors may be used to endorse or promote products derived from
   this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
"@
        }
        "Unlicense" {
            return @"
This is free and unencumbered software released into the public domain.

Anyone is free to copy, modify, publish, use, compile, sell, or
distribute this software, either in source code form or as a compiled
binary, for any purpose, commercial or non-commercial, and by any
means.

In jurisdictions that recognize copyright laws, the author or authors
of this software dedicate any and all copyright interest in the
software to the public domain. We make this dedication for the benefit
of the public at large and to the detriment of our heirs and
successors. We intend this dedication to be an overt act of
relinquishment in perpetuity of all present and future rights to this
software under copyright law.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.

For more information, please refer to <http://unlicense.org/>
"@
        }
        default {
            return ""
        }
    }
}

# Get target path
if ([string]::IsNullOrWhiteSpace($TargetPath)) {
    Write-Host "Enter package configuration details:" -ForegroundColor Cyan
    Write-Host ""
    
    $TargetPath = Get-UserInput -Prompt "Target directory for the package" -Required $true
}

# Expand path to absolute
$TargetPath = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($TargetPath)

# Check if target directory exists
if (Test-Path $TargetPath) {
    Write-Host "Target directory already exists: $TargetPath" -ForegroundColor Yellow
    $continue = Read-Host "Do you want to continue and add missing files? (y/n)"
    if ($continue -ne "y") {
        Write-Host "Setup cancelled." -ForegroundColor Red
        exit 1
    }
} else {
    New-Item -ItemType Directory -Path $TargetPath -Force | Out-Null
    Write-Host "Created target directory: $TargetPath" -ForegroundColor Green
}

Write-Host ""

# Gather package information
Write-Host "Package Information:" -ForegroundColor Cyan
Write-Host ""

$packageName = Get-UserInput -Prompt "Package name (e.g., com.company.packagename)" -Required $true -Validator {
    param($value)
    return $value -match '^[a-z0-9\-]+(\.[a-z0-9\-]+)+$'
}

$displayName = Get-UserInput -Prompt "Display name" -Required $true

$version = Get-UserInput -Prompt "Version" -Default "1.0.0" -Validator {
    param($value)
    return $value -match '^\d+\.\d+\.\d+$'
}

$description = Get-UserInput -Prompt "Description" -Required $true

$unity = Get-UserInput -Prompt "Unity version (minimum required)" -Default "2021.3"

$author = Get-UserInput -Prompt "Author name" -Required $true

$authorEmail = Get-UserInput -Prompt "Author email" -Default ""

$authorUrl = Get-UserInput -Prompt "Author URL" -Default ""

Write-Host ""
Write-Host "Select License Type:" -ForegroundColor Cyan
Write-Host "  1. MIT License (recommended)"
Write-Host "  2. Apache License 2.0"
Write-Host "  3. GNU GPL v3.0"
Write-Host "  4. BSD 3-Clause License"
Write-Host "  5. The Unlicense (public domain)"
Write-Host ""

$licenseChoice = Get-UserInput -Prompt "Enter license number (1-5)" -Default "1" -Validator {
    param($value)
    return $value -match '^[1-5]$'
}

$licenseMap = @{
    "1" = "MIT"
    "2" = "Apache-2.0"
    "3" = "GPL-3.0"
    "4" = "BSD-3-Clause"
    "5" = "Unlicense"
}

$license = $licenseMap[$licenseChoice]
$currentYear = (Get-Date).Year

Write-Host ""
Write-Host "Creating Unity package structure..." -ForegroundColor Cyan
Write-Host ""

# Create directory structure
Write-Host "Creating directories..." -ForegroundColor Yellow
New-DirectoryIfNotExists (Join-Path $TargetPath "Runtime")
New-DirectoryIfNotExists (Join-Path $TargetPath "Editor")
New-DirectoryIfNotExists (Join-Path $TargetPath "Tests")
New-DirectoryIfNotExists (Join-Path $TargetPath "Tests/Runtime")
New-DirectoryIfNotExists (Join-Path $TargetPath "Tests/Editor")
New-DirectoryIfNotExists (Join-Path $TargetPath "Samples~")
New-DirectoryIfNotExists (Join-Path $TargetPath "Documentation~")

Write-Host ""

# Create package.json
Write-Host "Creating package manifest..." -ForegroundColor Yellow
$packageJson = @{
    name = $packageName
    version = $version
    displayName = $displayName
    description = $description
    unity = $unity
    keywords = @()
    author = @{
        name = $author
    }
}

if ($authorEmail) {
    $packageJson.author.email = $authorEmail
}

if ($authorUrl) {
    $packageJson.author.url = $authorUrl
}

$packageJsonContent = $packageJson | ConvertTo-Json -Depth 10
New-FileWithContent -Path (Join-Path $TargetPath "package.json") -Content $packageJsonContent

Write-Host ""

# Create assembly definitions
Write-Host "Creating assembly definitions..." -ForegroundColor Yellow

# Runtime assembly definition
$runtimeAsmdef = @{
    name = "$packageName.Runtime"
    rootNamespace = ""
    references = @()
    includePlatforms = @()
    excludePlatforms = @()
    allowUnsafeCode = $false
    overrideReferences = $false
    precompiledReferences = @()
    autoReferenced = $true
    defineConstraints = @()
    versionDefines = @()
    noEngineReferences = $false
}
$runtimeAsmdefContent = $runtimeAsmdef | ConvertTo-Json -Depth 10
New-FileWithContent -Path (Join-Path $TargetPath "Runtime/$packageName.Runtime.asmdef") -Content $runtimeAsmdefContent

# Editor assembly definition
$editorAsmdef = @{
    name = "$packageName.Editor"
    rootNamespace = ""
    references = @("$packageName.Runtime")
    includePlatforms = @("Editor")
    excludePlatforms = @()
    allowUnsafeCode = $false
    overrideReferences = $false
    precompiledReferences = @()
    autoReferenced = $true
    defineConstraints = @()
    versionDefines = @()
    noEngineReferences = $false
}
$editorAsmdefContent = $editorAsmdef | ConvertTo-Json -Depth 10
New-FileWithContent -Path (Join-Path $TargetPath "Editor/$packageName.Editor.asmdef") -Content $editorAsmdefContent

# Tests Runtime assembly definition
$testsRuntimeAsmdef = @{
    name = "$packageName.Tests.Runtime"
    rootNamespace = ""
    references = @(
        "$packageName.Runtime",
        "UnityEngine.TestRunner",
        "UnityEditor.TestRunner"
    )
    includePlatforms = @()
    excludePlatforms = @()
    allowUnsafeCode = $false
    overrideReferences = $true
    precompiledReferences = @(
        "nunit.framework.dll"
    )
    autoReferenced = $false
    defineConstraints = @("UNITY_INCLUDE_TESTS")
    versionDefines = @()
    noEngineReferences = $false
}
$testsRuntimeAsmdefContent = $testsRuntimeAsmdef | ConvertTo-Json -Depth 10
New-FileWithContent -Path (Join-Path $TargetPath "Tests/Runtime/$packageName.Tests.Runtime.asmdef") -Content $testsRuntimeAsmdefContent

# Tests Editor assembly definition
$testsEditorAsmdef = @{
    name = "$packageName.Tests.Editor"
    rootNamespace = ""
    references = @(
        "$packageName.Runtime",
        "$packageName.Editor",
        "UnityEngine.TestRunner",
        "UnityEditor.TestRunner"
    )
    includePlatforms = @("Editor")
    excludePlatforms = @()
    allowUnsafeCode = $false
    overrideReferences = $true
    precompiledReferences = @(
        "nunit.framework.dll"
    )
    autoReferenced = $false
    defineConstraints = @("UNITY_INCLUDE_TESTS")
    versionDefines = @()
    noEngineReferences = $false
}
$testsEditorAsmdefContent = $testsEditorAsmdef | ConvertTo-Json -Depth 10
New-FileWithContent -Path (Join-Path $TargetPath "Tests/Editor/$packageName.Tests.Editor.asmdef") -Content $testsEditorAsmdefContent

Write-Host ""

# Create README.md
Write-Host "Creating documentation..." -ForegroundColor Yellow
$readmeContent = @"
# $displayName

$description

## Installation

### Via Package Manager

1. Open the Package Manager window in Unity (Window > Package Manager)
2. Click the '+' button in the top-left corner
3. Select 'Add package from git URL...'
4. Enter the URL of this repository

### Via manifest.json

Add the following line to your project's ``Packages/manifest.json`` file:

``````json
{
  "dependencies": {
    "$packageName": "https://github.com/yourusername/yourrepo.git"
  }
}
``````

## Quick Start

For detailed instructions, see the [Quick Start Guide](Documentation~/QuickStart.md).

### Basic Usage

``````csharp
// Add your usage examples here
using $packageName;

// Example code
``````

## Features

- Feature 1
- Feature 2
- Feature 3

## Requirements

- Unity $unity or later

## Documentation

For full documentation, please see the [Documentation~](Documentation~) folder.

## Samples

Sample scenes and examples are available in the Package Manager under the Samples section.

## Support

For questions, issues, or feature requests, please open an issue on the [GitHub repository](https://github.com/yourusername/yourrepo).

## License

This project is licensed under the $license License - see the [LICENSE](LICENSE) file for details.

## Author

**$author**
$(if ($authorEmail) { "- Email: $authorEmail" })
$(if ($authorUrl) { "- Website: $authorUrl" })
"@
New-FileWithContent -Path (Join-Path $TargetPath "README.md") -Content $readmeContent

# Create CHANGELOG.md
$changelogContent = @"
# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [$version] - $currentYear-$(Get-Date -Format 'MM-dd')

### Added
- Initial release
- Basic package structure
- Runtime assembly
- Editor assembly
- Test assemblies
- Documentation templates

### Changed
- N/A

### Deprecated
- N/A

### Removed
- N/A

### Fixed
- N/A

### Security
- N/A
"@
New-FileWithContent -Path (Join-Path $TargetPath "CHANGELOG.md") -Content $changelogContent

# Create Quick Start Guide
$quickStartContent = @"
# Quick Start Guide - $displayName

## Introduction

Welcome to $displayName! This guide will help you get started quickly.

## Installation

See the main [README.md](../README.md) for installation instructions.

## Getting Started

### Step 1: Import the Package

After installing the package, you should see it listed in the Package Manager.

### Step 2: Set Up Your Scene

1. Create a new scene or open an existing one
2. [Add specific setup instructions here]

### Step 3: Basic Usage

``````csharp
// Add step-by-step code examples here
using $packageName;

public class ExampleScript : MonoBehaviour
{
    void Start()
    {
        // Your code here
    }
}
``````

### Step 4: Test Your Setup

1. Enter Play mode
2. Verify that everything works as expected

## Next Steps

- Explore the [Samples](../Samples~) folder for more examples
- Check out the full [API Documentation](./API.md)
- Join our community for support and discussions

## Troubleshooting

### Common Issues

**Issue 1: [Describe common issue]**
- Solution: [Provide solution]

**Issue 2: [Describe common issue]**
- Solution: [Provide solution]

## Additional Resources

- [Unity Documentation](https://docs.unity3d.com/)
- [Package Documentation](./README.md)

## Support

If you encounter any issues, please:
1. Check the [Changelog](../CHANGELOG.md) for recent updates
2. Search existing [Issues](https://github.com/yourusername/yourrepo/issues)
3. Create a new issue with detailed information
"@
New-FileWithContent -Path (Join-Path $TargetPath "Documentation~/QuickStart.md") -Content $quickStartContent

Write-Host ""

# Create .gitignore
Write-Host "Creating Git configuration files..." -ForegroundColor Yellow
$gitignoreContent = @"
# Unity generated files
[Ll]ibrary/
[Tt]emp/
[Oo]bj/
[Bb]uild/
[Bb]uilds/
[Ll]ogs/
[Uu]ser[Ss]ettings/

# Never ignore Asset meta data
![Aa]ssets/**/*.meta

# Uncomment this line if you wish to ignore the asset store tools plugin
# [Aa]ssets/AssetStoreTools*

# Visual Studio cache directory
.vs/

# Rider cache directory
.idea/

# Gradle cache directory
.gradle/

# Autogenerated VS/MD/Consulo solution and project files
*.csproj
*.unityproj
*.sln
*.suo
*.tmp
*.user
*.userprefs
*.pidb
*.booproj
*.svd
*.pdb
*.mdb
*.opendb
*.VC.db

# Unity3D generated meta files
*.pidb.meta
*.pdb.meta
*.mdb.meta

# Unity3D generated file on crash reports
sysinfo.txt

# Builds
*.apk
*.unitypackage

# OS generated files
.DS_Store
.DS_Store?
._*
.Spotlight-V100
.Trashes
ehthumbs.db
Thumbs.db

# Temporary files
*.tmp
*~
"@
New-FileWithContent -Path (Join-Path $TargetPath ".gitignore") -Content $gitignoreContent

# Create .gitattributes
$gitattributesContent = @"
# Unity YAML files should be merged using UnityYAMLMerge
*.unity merge=unityyamlmerge eol=lf
*.prefab merge=unityyamlmerge eol=lf
*.asset merge=unityyamlmerge eol=lf
*.meta merge=unityyamlmerge eol=lf
*.controller merge=unityyamlmerge eol=lf
*.anim merge=unityyamlmerge eol=lf

# Unity LFS (Large File Storage) - Uncomment if using LFS
# *.psd filter=lfs diff=lfs merge=lfs -text
# *.jpg filter=lfs diff=lfs merge=lfs -text
# *.png filter=lfs diff=lfs merge=lfs -text
# *.gif filter=lfs diff=lfs merge=lfs -text
# *.bmp filter=lfs diff=lfs merge=lfs -text
# *.tga filter=lfs diff=lfs merge=lfs -text
# *.tif filter=lfs diff=lfs merge=lfs -text
# *.iff filter=lfs diff=lfs merge=lfs -text
# *.pict filter=lfs diff=lfs merge=lfs -text
# *.dds filter=lfs diff=lfs merge=lfs -text
# *.xcf filter=lfs diff=lfs merge=lfs -text
# *.wav filter=lfs diff=lfs merge=lfs -text
# *.mp3 filter=lfs diff=lfs merge=lfs -text
# *.ogg filter=lfs diff=lfs merge=lfs -text
# *.aiff filter=lfs diff=lfs merge=lfs -text
# *.aif filter=lfs diff=lfs merge=lfs -text
# *.mod filter=lfs diff=lfs merge=lfs -text
# *.it filter=lfs diff=lfs merge=lfs -text
# *.s3m filter=lfs diff=lfs merge=lfs -text
# *.xm filter=lfs diff=lfs merge=lfs -text
# *.mov filter=lfs diff=lfs merge=lfs -text
# *.avi filter=lfs diff=lfs merge=lfs -text
# *.asf filter=lfs diff=lfs merge=lfs -text
# *.mpg filter=lfs diff=lfs merge=lfs -text
# *.mpeg filter=lfs diff=lfs merge=lfs -text
# *.mp4 filter=lfs diff=lfs merge=lfs -text
# *.flv filter=lfs diff=lfs merge=lfs -text
# *.ogv filter=lfs diff=lfs merge=lfs -text
# *.wmv filter=lfs diff=lfs merge=lfs -text

# Enforce Unix-style line endings
*.cs text eol=lf
*.shader text eol=lf
*.cginc text eol=lf
*.hlsl text eol=lf
*.compute text eol=lf
*.json text eol=lf
*.md text eol=lf
*.txt text eol=lf
*.xml text eol=lf
*.yaml text eol=lf
*.yml text eol=lf
"@
New-FileWithContent -Path (Join-Path $TargetPath ".gitattributes") -Content $gitattributesContent

Write-Host ""

# Create LICENSE file
Write-Host "Creating LICENSE file..." -ForegroundColor Yellow
$licenseText = Get-LicenseText -LicenseType $license -Author $author -Year $currentYear
New-FileWithContent -Path (Join-Path $TargetPath "LICENSE") -Content $licenseText

Write-Host ""

# Create sample placeholder files
Write-Host "Creating sample files..." -ForegroundColor Yellow

# Runtime sample script
$runtimeSampleContent = @"
// Example runtime script for $displayName
// Remove or modify this file as needed

namespace $packageName
{
    /// <summary>
    /// Example class demonstrating package structure.
    /// </summary>
    public class ExampleClass
    {
        /// <summary>
        /// Example method.
        /// </summary>
        public void ExampleMethod()
        {
            // Your implementation here
        }
    }
}
"@
New-FileWithContent -Path (Join-Path $TargetPath "Runtime/ExampleClass.cs") -Content $runtimeSampleContent

# Editor sample script
$editorSampleContent = @"
// Example editor script for $displayName
// Remove or modify this file as needed

#if UNITY_EDITOR
using UnityEditor;
using UnityEngine;

namespace $packageName.Editor
{
    /// <summary>
    /// Example editor class demonstrating package structure.
    /// </summary>
    public class ExampleEditor
    {
        [MenuItem("Tools/$displayName/Example Menu Item")]
        public static void ExampleMenuItem()
        {
            Debug.Log("Example menu item clicked!");
        }
    }
}
#endif
"@
New-FileWithContent -Path (Join-Path $TargetPath "Editor/ExampleEditor.cs") -Content $editorSampleContent

# Sample test file
$testSampleContent = @"
// Example test file for $displayName
// Remove or modify this file as needed

using NUnit.Framework;

namespace $packageName.Tests
{
    /// <summary>
    /// Example test class demonstrating test structure.
    /// </summary>
    public class ExampleTests
    {
        [Test]
        public void ExampleTest()
        {
            // Arrange
            var example = new ExampleClass();
            
            // Act
            example.ExampleMethod();
            
            // Assert
            Assert.Pass();
        }
    }
}
"@
New-FileWithContent -Path (Join-Path $TargetPath "Tests/Runtime/ExampleTests.cs") -Content $testSampleContent

# Sample documentation
$sampleReadmeContent = @"
# Sample for $displayName

This folder contains sample scenes and scripts demonstrating the usage of $displayName.

## Samples

### Sample 1: Basic Example
Description of what this sample demonstrates.

### Sample 2: Advanced Example
Description of what this sample demonstrates.

## How to Import Samples

1. Open the Package Manager (Window > Package Manager)
2. Select $displayName from the list
3. Expand the Samples section
4. Click Import next to the sample you want to use

## Notes

- Samples are optional and can be imported as needed
- Each sample is self-contained and can be used independently
"@
New-FileWithContent -Path (Join-Path $TargetPath "Samples~/README.md") -Content $sampleReadmeContent

Write-Host ""

# Final summary
Write-Host "═══════════════════════════════════════════════════════════" -ForegroundColor Green
Write-Host "✓ Unity package setup completed successfully!" -ForegroundColor Green
Write-Host "═══════════════════════════════════════════════════════════" -ForegroundColor Green
Write-Host ""
Write-Host "Package Details:" -ForegroundColor Cyan
Write-Host "  Name:        $packageName"
Write-Host "  Display:     $displayName"
Write-Host "  Version:     $version"
Write-Host "  Unity:       $unity+"
Write-Host "  License:     $license"
Write-Host "  Location:    $TargetPath"
Write-Host ""
Write-Host "Created Structure:" -ForegroundColor Cyan
Write-Host "  ✓ Runtime/              - Runtime scripts and assets"
Write-Host "  ✓ Editor/               - Editor-only scripts and tools"
Write-Host "  ✓ Tests/Runtime/        - Runtime tests"
Write-Host "  ✓ Tests/Editor/         - Editor tests"
Write-Host "  ✓ Samples~/             - Sample content (optional import)"
Write-Host "  ✓ Documentation~/       - Documentation and guides"
Write-Host ""
Write-Host "Created Files:" -ForegroundColor Cyan
Write-Host "  ✓ package.json          - Package manifest"
Write-Host "  ✓ README.md             - Package documentation"
Write-Host "  ✓ CHANGELOG.md          - Version history"
Write-Host "  ✓ LICENSE               - License file"
Write-Host "  ✓ .gitignore            - Git ignore rules"
Write-Host "  ✓ .gitattributes        - Git attributes"
Write-Host "  ✓ Assembly definitions  - Code organization"
Write-Host ""
Write-Host "Next Steps:" -ForegroundColor Yellow
Write-Host "  1. Review and customize the generated files"
Write-Host "  2. Add your code to the Runtime and Editor folders"
Write-Host "  3. Write tests in the Tests folders"
Write-Host "  4. Update the README.md with specific information"
Write-Host "  5. Initialize a git repository: git init"
Write-Host "  6. Make your first commit: git add . && git commit -m 'Initial commit'"
Write-Host ""
Write-Host "Happy coding! 🚀" -ForegroundColor Green
Write-Host ""
