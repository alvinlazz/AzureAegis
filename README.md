# AzureAegis 🔐

Welcome to **AzureAegis**! 🎉 This PowerShell script provides a user-friendly interface for interacting with Azure Key Vault, helping you manage and access your secrets efficiently.

![Windows](https://img.shields.io/badge/Windows-05122A?style=flat&logo=microsoft&logoColor=white)
![PowerShell](https://img.shields.io/badge/PowerShell-0078D4?style=flat&logo=powershell&logoColor=white)
[![Version](https://img.shields.io/github/v/release/alvinlazz/AzureAegis?color=blue&label=release)](https://github.com/alvinlazz/AzureAegis/releases)
[![GitHub license](https://img.shields.io/github/license/alvinlazz/AzureAegis?color=green)](https://github.com/alvinlazz/AzureAegis/blob/main/LICENSE)
[![GitHub issues](https://img.shields.io/github/issues/alvinlazz/AzureAegis?color=red)](https://github.com/alvinlazz/AzureAegis/issues)
[![GitHub stars](https://img.shields.io/github/stars/alvinlazz/AzureAegis?color=yellow)](https://github.com/alvinlazz/AzureAegis/stargazers)
[![GitHub forks](https://img.shields.io/github/forks/alvinlazz/AzureAegis?color=orange)](https://github.com/alvinlazz/AzureAegis/network/members)
[![GitHub watchers](https://img.shields.io/github/watchers/alvinlazz/AzureAegis?color=blue)](https://github.com/alvinlazz/AzureAegis/watchers)

## Table of Contents

- [Introduction](#introduction)
- [Installation](#installation)
- [Usage](#usage)
- [Project History](#project-history)
- [Contributing](#contributing)
- [License](#license)
- [Contact](#contact)

## Introduction

**AzureAegis** simplifies the process of managing Azure Key Vault secrets by providing clear instructions and real-time feedback through a PowerShell script. Whether you're an admin or a developer, **AzureAegis** ensures you have the tools you need to work efficiently with your Azure Key Vault.

## Installation

To get started with **AzureAegis**, follow these steps:

1. **Clone the repository:**

    ```bash
    git clone https://github.com/owner/AzureAegis.git
    cd AzureAegis
    ```

2. **Install the Azure modules:**

    ```powershell
    Install-Module -Name Az
    ```

3. **Run the script:**

    ```powershell
    .\AzureAegis.ps1
    ```

## Usage

When you run **AzureAegis**, you'll see the following instructions in the PowerShell console:

- **Important:** Always keep an eye on colored text.
- **Filtered most common Vault names print always.**
- **Type 'x' and Press ENTER** for a list of all options.
- **Type 'number'** to enter a valid number seen in the console.
- **Type 'name'** to refer to 'part or full' secret name.
- **If 'name' given with 'part', there will be multiple secrets printed.**
- **'Permission Error'** means you don't have access to the selected vault.
- **Type 'H' and Press ENTER** to print this message.

**Security Alert**

Please ensure you follow these security best practices:

- **Do not share your password** with anyone.
- **Keep script updated** to guard against bugs/vulnerabilities.
- **Report any suspicious/bug activity** immediately.

Happy exploring! 🌟

For detailed documentation, visit: [KB Link Soon Publish]

## Project History

**AzureAegis** has evolved over time:

- **v1.0**: Initial release with core features and basic instructions.
- **v1.1**: Added detailed security alerts and updated user interface.
- **v1.2**: Improved error handling and documentation.

## Contributing

We welcome contributions to **AzureAegis**! To get involved:

1. **Fork the repository.**
2. **Create a new branch:**

    ```bash
    git checkout -b feature-branch
    ```

3. **Make your changes and commit:**

    ```bash
    git commit -am 'Add new feature'
    ```

4. **Push to your branch:**

    ```bash
    git push origin feature-branch
    ```

5. **Open a Pull Request** on GitHub.

Please refer to our [contributing guidelines](contributing.md) for more details.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contact

For questions or feedback, feel free to reach out:

- [To Me](mailto:alvin@seatec.uu.me)

Happy exploring with **AzureAegis**! 🎉
