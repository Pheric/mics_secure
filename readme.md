## MICS Secure
This is a set of scripts for linux systems to secure them quickly for the 2019 MICS cybersecurity competition at NDSU.
Much of the configuration is based off experiences learned at DSU CCDC mock competitions held multiple times per semester.

### TODO
* Optimize for different systems beyond updated Debian
    * Arch, Ubuntu, CentOS, even *BSD
* Add scripts
    * Change the root user password for MySQL / MariaDB / PostgreSQL
        * Add a menu to change info about other users. Maybe it summarizes the mysql.user table to show username and
        host combinations for the admin at a glance
    * Add a script to secure php.ini
    * Remove sudo users' access and check the sudoers file for groups that have privileged access to things
        * remove the additional sudoers directory
    * Remove common vulnerable services (telnet, etc)
    * Run a system update
    * Install fail2ban, IPS, etc
* More error handling (see sshdConfigure.sh)