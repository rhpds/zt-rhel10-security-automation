= RHEL 10 Security Automation Lab
:toc:
:icons: font
:experimental:

== Objective

By the end of this guided lab exercise, you will be able to:

* Quickly cover the Ansible basics.
* Create users and groups securely.
* Manage permissions and local sudo rules.
* Modify SELinux permissions.
* Configure system integrity with AIDE.
* Define an allow list of permitted applications using fapolicyd.
* Define a basic security automation policy in a playbook.

== Introduction

Get started with System Roles on RHEL.

Red Hat Enterprise Linux System Roles are a collection of supported Ansible roles that ensure consistent workflows and streamline the execution of manual tasks.

Get familiar with the System Roles (Ansible) for RHEL operating model. In this lab you will use Ansible and RHEL System Roles to automate common security configuration tasks across your environment.

=== Lab Modules

. *Introduction* — Subscribe to Ansible and verify `rhel-system-roles`
. *Create Audit* — Configure system integrity with AIDE
. *HTTPD Permissions* — Manage permissions and local sudo rules
. *SELinux* — Modify SELinux permissions
. *AuditD* — Configure security auditing
. *fapolicyd* — Define an allow list of permitted applications
. *BSA Playbook* — Define a basic security automation policy in a playbook

== Lab Environment

As part of this lab you will have access to 2 machines:

* rhel
* client1

* **Operating System**: Red Hat Enterprise Linux 10
* **Required Packages**: `rhel-system-roles` (pre-installed)
* **Estimated Time**: Approximately 30 minutes

The `rhel` system acts as the Ansible control node (bastion). The `client1` system is a managed node.

=== Environment Diagram

[source,text]
----
                         Lab Environment
    ┌──────────────────────────────────────────────────────┐
    │                                                      │
    │   ┌──────────────┐              ┌──────────────┐    │
    │   │     rhel     │   Ansible    │   client1    │    │
    │   │  (bastion)   │─────────────▶│    (node)    │    │
    │   │    rhel      │              │  rhel, root  │    │
    │   └──────────────┘              └──────────────┘    │
    │                                                      │
    └──────────────────────────────────────────────────────┘
----

You will have a couple of accounts you will have access to.

*rhel*

* rhel
* root

*client1*

* rhel
* root

[NOTE]
====
*Lab Note: If Using Red Hat Demo System (RHPDS)*

The terminal window to your right is already logged into the lab environment as the `rhel` user via SSH. All steps of this lab are to be completed as the `rhel` user on the bastion server.

When you follow the next steps, you will have instructions followed by a small box with text that is meant to be used in the terminal. In the upper right corner there will be a couple of symbols. It should say something like "BASH", an icon of a clipboard, and an icon of a terminal.

You should also be able to click the terminal icon and the command is then auto-typed into the machine terminal.

Alternatively, you should be able to click the clipboard icon in the code box to copy the command, and you will either use the middle mouse button or right click and paste. The keyboard shortcuts for copy and paste (`Ctrl+C` and `Ctrl+V`) won't work in this environment.

To move to the next step, click the *Next* button.
====

[NOTE]
====
The `rhel-system-roles` package is pre-installed for this lab. You can verify the installed version with `sudo dnf info rhel-system-roles`.
====
