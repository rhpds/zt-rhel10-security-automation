#!/bin/bash

# This is placing a prewritten playbook in the default user directory 
cat <<EOF > add-audit-user.yml
---
- name: Config audit team group and members
  hosts: all
  gather_facts: yes
  become: true
  vars:
    - group_name: "auditteam"
    - service_accounts:
      - name: "johnp"

  tasks:

    - name: Create group
      ansible.builtin.group:
        name: "{{ group_name }}"
        state: present

    - name: Add the Audit user to the "{{ group_name }}" User group
      ansible.builtin.user:
        name: "{{ item.name }}"
        groups: "{{ group_name }}"
        append: true
#        password: "{{ tmp_password }}"
      with_items: "{{ service_accounts }}"
EOF


# This is placing a prewritten ansible inventory file in the default user directory
cat > hosts.ini << EOF
localhost  ansible_connection=local
EOF


 sudo groupadd auditteam

 sudo useradd -m -G auditteam -s /bin/bash johnp

 echo 'johnp:redhat' | sudo chpasswd


sudo groupadd webdev

sudo useradd -m -G webdev -s /bin/bash davidj

echo 'davidj:redhat' | sudo chpasswd

cat >  /var/www/html/index.html << EOF 
<html>
    <head>
        <title>Test Webpage</title>
    </head>
        <body>
            <h1>Welcome to the test webpage!</h1>
            <p>This is a simple webpage created using Ansible on RHEL 9.</p>
        </body>
</html>
EOF

sudo dnf install  rhel-system-roles -y

cat <<EOF > /var/www/html/index.html
          <html>
            <head>
              <title>My Test Website</title>
            </head>
            <body>
              <h1>Welcome to my Test website!</h1>
              <p>This is a basic website created using HTML.</p>
            </body>
          </html>

EOF

cat >webdev.yml << EOF
---
- hosts: localhost
  vars:
    sudo_sudoers_files:
      - path: /etc/sudoers.d/webdev
        user_specifications:
          - users:
              - davidj
              - "%webdev"
            hosts:
              - ALL
            operators:
              - ALL
            commands:
              - /usr/bin/systemctl start httpd
              - /usr/bin/systemctl stop httpd
              - /usr/bin/systemctl status httpd
  roles:
    - role: rhel-system-roles.sudo
EOF
