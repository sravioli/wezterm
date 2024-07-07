# Contributing to wezterm

First off, thank you for considering contributing to wezterm! It's people like
you who make it a great project.

## How to Contribute

### Reporting Bugs

If you find a bug, please report it by opening an issue the [GitHub
Issues](https://github.com/sravioli/wezterm/issues) page. Before reporting,
please check if the issue has already been reported. When reporting a bug, please
include:

- A clear and descriptive title.
- A detailed description of the problem.
- Steps to reproduce the issue.
- Any relevant log files or screenshots.

### Suggesting Features

If you have an idea for a new feature or improvement, please submit it as an
issue the [GitHub Issues](https://github.com/sravioli/wezterm/issues) page.
Include as much detail as possible about the feature and why it would be
beneficial.

### Code Contributions

#### Getting Started

1. **Fork the repository**: Click the "Fork" button at the top right of the repository page.

2. **Clone your fork**:

    ```bash
    git clone https://github.com/your-username/wezterm.git
    cd wezterm
    ```

3. **Create a branch**:

    ```bash
    git checkout -b feat/new-feature
    ```

#### Making Changes

1. Make sure your fork is up to date with the latest changes from the original repository:

    ```bash
    git remote add upstream https://github.com/sravioli/wezterm.git
    git fetch upstream
    git merge upstream/main
    ```

2. Make your changes in your branch.

3. **Commit your changes** Please follow the [conventional
   commit](https://www.conventionalcommits.org/en/v1.0.0/#summary) specification:

    ```bash
    git add .
    git commit -m "<type>: <description"
    ```

4. **Push your changes**:

    ```bash
    git push origin feat/new-feature
    ```

5. **Open a Pull Request**: Go to your fork on GitHub and click the "New Pull
   Request" button. Follow the template and provide as much detail as possible
   about your changes.

#### Code Style

Please follow the existing coding style used in the project. This ensures
consistency and readability across the codebase.

### Documentation

Contributions to documentation are welcome. If you see something that can be
improved or clarified, feel free to submit a pull request.

### Community

We welcome you to join the discussions the [GitHub
Discussions](https://github.com/sravioli/wezterm/discussions) page. Here, you can
ask questions, share ideas, and collaborate with others in the community.

## Code of Conduct

This project adheres to the Contributor Covenant [code of
conduct](https://github.com/sravioli/wezterm/blob/main/.github/CODE_OF_CONDUCT.md).
By participating, you are expected to uphold this code. Please report any
unacceptable behavior to the project maintainers.

## License

By contributing, you agree that your contributions will be licensed under the
project's [GNU GPLv3.0 license](https://github.com/sravioli/wezterm/blob/main/LICENSE.txt).

Thank you for your interest in contributing to wezterm!
