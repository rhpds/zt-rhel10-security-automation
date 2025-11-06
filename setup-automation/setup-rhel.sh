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
    - tmp_password: "$6$rounds=656000$mysecretsalt$eAieC11.b9YrreFtSVQGB0wK2gxhlNk0IOYmtbF7OLGgHFG0Ie99zSZm8wr7P9ALqtshUmn8Wo2gvJPSx5oPS0"
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


#useradd rhel
#echo -e "test\ntest" | passwd rhel
#mkdir -p /home/rhel/.ssh
#cp .ssh/id_rsa.pub /home/rhel/.ssh/
#cp .ssh/authorized_keys /home/rhel/.ssh/
#chown rhel:rhel -R /home/rhel/.ssh/

#ssh-keyscan -H client1 >> ~/.ssh/known_hosts

#set up tmux so it has to restart itself whenever the system reboots

#step 1: make a script
#tee ~/startup-tmux.sh << EOF
#TMUX='' tmux new-session -d -s 'rhel-session' > /dev/null 2>&1
#tmux set -g pane-border-status top
#tmux setw -g pane-border-format ' #{pane_index} #{pane_current_command}'
#tmux set -g mouse on
#tmux set mouse on
#EOF

#step 2: make it executable
#chmod +x ~/startup-tmux.sh
#step 3: use cron to execute 
#echo "@reboot ~/startup-tmux.sh" | crontab -

#step 4: start tmux for the lab
#~/startup-tmux.sh

