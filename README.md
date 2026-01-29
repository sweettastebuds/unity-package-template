# Unity Package Template

A comprehensive PowerShell setup script to quickly create Unity packages with a standard structure, complete with assembly definitions, documentation templates, and Git configuration.

## Features

- 🏗️ **Standard Unity Package Structure** - Automatically creates Runtime, Editor, Tests, Samples, and Documentation folders
- 📦 **Assembly Definitions** - Generates .asmdef files for proper code organization and compilation control
- 📝 **Package Manifest** - Creates package.json with all required metadata
- 📚 **Documentation Templates** - Includes README, CHANGELOG, and Quick Start Guide
- 🔧 **Git Configuration** - Sets up .gitignore and .gitattributes for Unity projects
- ⚖️ **License Generator** - Choose from MIT, Apache-2.0, GPL-3.0, BSD-3-Clause, or Unlicense
- ✅ **Sample Code** - Includes example scripts to get you started quickly

## Prerequisites

- PowerShell 5.1 or later (Windows) or PowerShell Core 7+ (cross-platform)
- No Unity installation required to run the setup script

## Quick Start

### Option 1: Interactive Mode (Recommended)

Simply run the script and follow the prompts:

```powershell
.\Setup-UnityPackage.ps1
```

### Option 2: Specify Target Path

Provide the target directory as a parameter:

```powershell
.\Setup-UnityPackage.ps1 -TargetPath "C:\MyUnityPackages\MyAwesomePackage"
```

### Option 3: Use in Your Own Projects

Download the script and run it from any location:

```powershell
# Download the script
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/yourusername/unity-package-template/main/Setup-UnityPackage.ps1" -OutFile "Setup-UnityPackage.ps1"

# Run it
.\Setup-UnityPackage.ps1
```

## What Gets Created

Running the script will create the following structure:

```
YourPackage/
├── Runtime/
│   ├── YourPackage.Runtime.asmdef
│   └── ExampleClass.cs
├── Editor/
│   ├── YourPackage.Editor.asmdef
│   └── ExampleEditor.cs
├── Tests/
│   ├── Runtime/
│   │   ├── YourPackage.Tests.Runtime.asmdef
│   │   └── ExampleTests.cs
│   └── Editor/
│       └── YourPackage.Tests.Editor.asmdef
├── Samples~/
│   └── README.md
├── Documentation~/
│   └── QuickStart.md
├── package.json
├── README.md
├── CHANGELOG.md
├── LICENSE
├── .gitignore
└── .gitattributes
```

## Package Information Prompts

The script will prompt you for the following information:

- **Target Directory** - Where to create the package
- **Package Name** - Unity package identifier (e.g., `com.company.packagename`)
- **Display Name** - Human-readable name shown in Unity
- **Version** - Package version (e.g., `1.0.0`)
- **Description** - Brief description of your package
- **Unity Version** - Minimum Unity version required
- **Author Name** - Your name or organization
- **Author Email** - (Optional) Contact email
- **Author URL** - (Optional) Website or repository URL
- **License Type** - Choose from 5 popular open-source licenses

## License Options

1. **MIT License** (Recommended) - Permissive, widely used
2. **Apache License 2.0** - Permissive with patent grant
3. **GNU GPL v3.0** - Copyleft license
4. **BSD 3-Clause License** - Permissive with attribution
5. **The Unlicense** - Public domain dedication
6. **Proprietary License** - Commercial license allowing extension but not redistribution

## After Setup

Once the script completes, you can:

1. **Review Generated Files** - Customize the templates to match your needs
2. **Add Your Code** - Start developing in the Runtime and Editor folders
3. **Write Tests** - Add tests in the Tests folders
4. **Update Documentation** - Enhance the README and Quick Start guide
5. **Initialize Git** - Run `git init` in the package directory
6. **First Commit** - Add and commit your files

```powershell
cd YourPackageDirectory
git init
git add .
git commit -m "Initial package setup"
```

## Unity Integration

To use your package in Unity:

### Method 1: Local Package
1. Copy your package folder to your Unity project's `Packages` folder

### Method 2: Git URL
1. Push your package to a Git repository
2. In Unity Package Manager, click `+` → `Add package from git URL...`
3. Enter your repository URL

### Method 3: Add to manifest.json
Add your package to `Packages/manifest.json`:

```json
{
  "dependencies": {
    "com.yourcompany.yourpackage": "file:../../path/to/package"
  }
}
```

## Examples

### Creating a Simple Tools Package

```powershell
.\Setup-UnityPackage.ps1
# Enter: com.mycompany.editortools
# Display Name: My Editor Tools
# Version: 1.0.0
# Description: Collection of useful Unity Editor tools
# Unity: 2021.3
# Author: John Doe
# License: MIT
```

### Creating a Runtime Library

```powershell
.\Setup-UnityPackage.ps1
# Enter: com.mycompany.utilities
# Display Name: Common Utilities
# Version: 0.1.0
# Description: Reusable utility scripts for Unity projects
# Unity: 2020.3
# Author: Jane Smith
# License: Apache-2.0
```

## Troubleshooting

### PowerShell Execution Policy

If you encounter an execution policy error, run:

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### Script Not Found

Ensure you're in the correct directory:

```powershell
cd path\to\unity-package-template
.\Setup-UnityPackage.ps1
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support

For questions, issues, or feature requests, please open an issue on the [GitHub repository](https://github.com/yourusername/unity-package-template/issues).
