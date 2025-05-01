---
description: Learn how to contribute to LND’s code and documentation
---

# Contribute to LND

The Lightning Network Daemon is open source software published and maintained by Lightning Labs. The project relies heavily on contributions from users, developers, and the projects building on top of it.

LND is used in production by countless individuals and companies all around the world. They entrust the software with their funds, and their users’ funds. Consequently, LND has formalized and implemented a rigorous development process that values safety, security, reliability, and quality above features or development speed.

There are many ways to contribute to the project, as a user, developer, entrepreneur, or through documentation.

## Contribute as a user

{% hint style="success" %}
Thank you for running LND! We are always attentive to our users’ needs and rely on users to report bugs and share their use cases.
{% endhint %}

To be effective in providing user feedback, you should be prepared to provide extensive logs (e.g. debug mode) as well as profiling data. Detailed logs and profiles help us troubleshoot bugs more effectively.

[Read more: Debugging LND](debugging_lnd.md)

We appreciate any extensive testing, especially in environments like signet. As a user, you can contribute to LND by applying patches in your testing environment, running a signet node, and by upgrading to release candidates early and often. Running Release Candidates as when it's published and publishing bug reports is a great way to contribute towards improving the quality of the releases. Although it’s recommended to run RC on signet nodes only.

You may also contribute to the development process below by applying patches and testing new features and pull requests before they are released.

[Discover: Open issues](https://github.com/lightningnetwork/lnd/issues/)

## Contribute as a developer

LND has strict contributor standards and frequently merges pull requests from outside contributors.

To effectively contribute code, it helps to

* Understand Bitcoin and the Lightning Network at a high level
* Comprehend c-like languages, their data structures and performance
* Have some level of proficiency with Go, as LND is written in Go
* Possess domain specific knowledge in the field you are contributing to
* Have a strong appetite to review code, in addition to developing&#x20;

[Must read: Code contribution guidelines](https://github.com/lightningnetwork/lnd/blob/master/docs/code_contribution_guidelines.md)

The LND issue log provides a good starting point for opportunities. Filter issues with flags like ‘good first issue’, ‘up for grabs’ or ‘beginner’ to find a convenient starting point.

Code reviews are an extremely important area of contribution. High quality code reviews are highly appreciated by the development team. You may start with a small or medium sized pull request, discern why it was created, and what code changes are needed to address that need. Also, to improve familiarity with the code base you can ask pr authors questions on the prs on specific areas to get clarity on the decisions made by the developers.

Continue by looking into the proposed code changes and analyze what each line does. Run the code locally, debug it, and go through all unit and integration tests.

[Discover: Open pull requests](https://github.com/lightningnetwork/lnd/pulls)

Another important venue to improve your understanding of the LND code base and functionality is the [LND PR Review Club](https://lnd.reviews/).

LND core developers run this forum and provide high quality inputs which helps in building subject matter expertise on different areas of function within LND

## Contribute to documentation

There are a million ways to configure and run LND. You can help other users by documenting your setup and configurations, together with the tools you use to manage your node.

When discovering errors in LND documentation, don’t hesitate to reach out or make a pull request.

Share your guides, sample configurations, and setups with the community.

## Stay in touch

[Follow Lightning Labs on X](https://twitter.com/lightning/)

[Join the LND Slack](https://lightning.engineering/slack.html)
