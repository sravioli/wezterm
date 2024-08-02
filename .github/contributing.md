# Contributing to my wezterm config

First off, thanks for taking the time to contribute! ❤️

All types of contributions are encouraged and valued. See the [Table of Contents](#table-of-contents) for different ways to help and details about how this project handles them. Please make sure to read the relevant section before making your contribution. It will make it a lot easier for us maintainers and smooth out the experience for all involved. The community looks forward to your contributions. 🎉

> And if you like the project, but just don't have time to contribute, that's fine. There are other easy ways to support the project and show your appreciation, which we would also be very happy about:
>
> - Star the project
> - Tweet about it
> - Refer this project in your project's readme
> - Mention the project at local meetups and tell your friends/colleagues

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [I Have a Question](#i-have-a-question)
- [I Want To Contribute](#i-want-to-contribute)
  - [Reporting Bugs](#reporting-bugs)
  - [Suggesting Enhancements](#suggesting-enhancements)
  - [Your First Code Contribution](#your-first-code-contribution)
  - [Improving The Documentation](#improving-the-documentation)
- [Styleguides](#styleguides)
  - [Commit Messages](#commit-messages)

## Code of Conduct

This project and everyone participating in it is governed by the
[project Code of Conduct](https://www.github.com/sravioli/wezterm/blob/main/code_of_conduct.md).
By participating, you are expected to uphold this code. Please report unacceptable behavior
to <mailto:fsimone2002@proton.me>.

## I Have a Question

Before you ask a question, it is best to search for existing [Issues](https://www.github.com/sravioli/wezterm/issues) that might help you. In case you have found a suitable issue and still need clarification, you can write your question in this issue. It is also advisable to search the internet for answers first.

If you then still feel the need to ask a question and need clarification, we recommend the following:

- Open an [Issue](https://www.github.com/sravioli/wezterm/issues/new).
- Provide as much context as you can about what you're running into.
- Provide project and platform versions (Wezterm, Lua, etc), depending on what seems relevant.

We will then take care of the issue as soon as possible.

## I Want To Contribute

> [!NOTE]
>
> When contributing to this project, you must agree that you have authored 100% of the content, that you have the necessary rights to the content and that the content you contribute may be provided under the project license.

### Reporting Bugs

#### Before Submitting a Bug Report

A good bug report shouldn't leave others needing to chase you up for more information. Therefore, we ask you to investigate carefully, collect information and describe the issue in detail in your report. Please complete the following steps in advance to help us fix any potential bug as fast as possible.

- Make sure that you are using the latest version.
- Determine if your bug is really a bug and not an error on your side e.g. using incompatible environment components/versions (If you are looking for support, you might want to check [this section](#i-have-a-question)).
- To see if other users have experienced (and potentially already solved) the same issue you are having, check if there is not already a bug report existing for your bug or error in the [bug tracker](https://www.github.com/sravioli/wezterm/issues?q=label%3Abug).
- Also make sure to search the internet (including Stack Overflow) to see if users outside of the GitHub community have discussed the issue.
- Collect information about the bug:
  - Stack trace (Traceback)
  - OS, Platform and Version (Windows, Linux, macOS, x86, ARM)
  - Version of Wezterm.
  - Possibly your input and the output
  - Can you reliably reproduce the issue? And can you also reproduce it with older versions?

#### How Do I Submit a Good Bug Report?

> You must never report security related issues, vulnerabilities or bugs including sensitive information to the issue tracker, or elsewhere in public. Instead sensitive bugs must be sent by email to <mailto:fsimone2002@proton.me>.

We use GitHub issues to track bugs and errors. If you run into an issue with the project:

- Open an [Issue](https://www.github.com/sravioli/wezterm/issues/new).
- Explain the behavior you would expect and the actual behavior.
- Please provide as much context as possible and describe the _reproduction steps_ that someone else can follow to recreate the issue on their own. This usually includes your code. For good bug reports you should isolate the problem and create a reduced test case.
- Provide the information you collected in the previous section.

Once it's filed:

- The project team will label the issue accordingly.
- A team member will try to reproduce the issue with your provided steps. If there are no reproduction steps or no obvious way to reproduce the issue, the team will ask you for those steps and mark the issue as `needs-repro`. Bugs with the `needs-repro` tag will not be addressed until they are reproduced.
- If the team is able to reproduce the issue, it will be marked `needs-fix`, as well as possibly other tags (such as `critical`), and the issue will be left to be [implemented by someone](#your-first-code-contribution).

### Suggesting Enhancements

This section guides you through submitting an enhancement suggestion for wezterm, **including completely new features and minor improvements to existing functionality**. Following these guidelines will help maintainers and the community to understand your suggestion and find related suggestions.

#### Before Submitting an Enhancement

- Make sure that you are using the latest version.
- Find out if the functionality is already covered, maybe by an individual configuration.
- Perform a [search](https://www.github.com/sravioli/wezterm/issues) to see if the enhancement has already been suggested. If it has, add a comment to the existing issue instead of opening a new one.
- Find out whether your idea fits with the scope and aims of the project.

#### How Do I Submit a Good Enhancement Suggestion?

Enhancement suggestions are tracked as [GitHub issues](https://www.github.com/sravioli/wezterm/issues).

- Use a **clear and descriptive title** for the issue to identify the suggestion.
- Provide a **step-by-step description of the suggested enhancement** in as many details as possible.
- **Describe the current behavior** and **explain which behavior you expected to see instead** and why. At this point you can also tell which alternatives do not work for you.
- You may want to **include screenshots and animated GIFs** which help you demonstrate the steps or point out the part which the suggestion is related to. You can use [this tool](https://www.cockos.com/licecap/) to record GIFs on macOS and Windows, and [this tool](https://github.com/colinkeenan/silentcast) or [this tool](https://github.com/GNOME/byzanz) on Linux.
- **Explain why this enhancement would be useful** to most wezterm users. You may also want to point out the other projects that solved it better and which could serve as inspiration.

### Your First Code Contribution

1. **Fork the repository**:

    ~~~bash
    gh repo fork sravioli/wezterm
    cd wezterm
    ~~~

    Otherwise click the "Fork" button at the top right of the repository page and then clone it:

    ~~~bash
    git clone https://github.com/your-username/wezterm.git
    cd wezterm
    ~~~

2. **Create a branch**:

    ~~~bash
    git checkout -b feat/new-feature
    ~~~

Now make a change!

1. Make sure your fork is up to date with the latest changes from the original repository:

    ~~~bash
    git remote add upstream https://github.com/sravioli/wezterm.git
    git fetch upstream
    git merge upstream/main
    ~~~

2. Make your changes in your branch.

3. **Commit your changes** (please refer to the [styleguide](#styleguides))

    ~~~bash
    git add .
    git commit -m "feat: my new great feature"
    ~~~

4. **Push your changes**:

    ~~~bash
    git push origin feat/new-feature
    ~~~

5. **Open a Pull Request**: Go to your fork on GitHub and click the "New Pull
   Request" button. Follow the template and provide as much detail as possible
   about your changes.

## Styleguides

### Commit Messages

This project adheres to the [conventional commit](https://www.conventionalcommits.org/en/v1.0.0/#summary) specification.

You can install [cocogitto](https://github.com/cocogitto/cocogitto?tab=readme-ov-file#installation) to help you follow those rules.

## Attribution

This guide is based on the **contributing-gen**. [Make your own](https://github.com/bttger/contributing-gen)!
