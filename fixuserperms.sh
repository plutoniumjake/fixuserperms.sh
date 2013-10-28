!/bin/bash
# Script to fix permissions of accounts.
# You must pass a valid user to the script when it is called.
# written by jvandeventer@liquidweb.com

if [ "$#" -lt "1" ];then
        echo "Must specify user"
        exit;
fi

USER=$@

for user in $USER
do
        HOMEDIR=$(egrep ^${user} /etc/passwd | cut -d: -f6)
        if [ ! -f /var/cpanel/users/$user ]; then
                echo "$user user file missing, likely an invalid user"
        elif [ "$HOMEDIR" == "" ];then
                echo "Couldn't determine home directory for $user"
        else
                echo "Setting ownership for user $user"
                        chown -R $user:$user $HOMEDIR
                        chown $user:nobody $HOMEDIR/public_html $HOMEDIR/.htpasswds
                        chown $user:mail $HOMEDIR/etc $HOMEDIR/etc/*/shadow $HOMEDIR/etc/*/passwd
                echo "Setting permissions for user $USER"
                        find $HOMEDIR -type f -exec chmod 644 {} \;
                        find $HOMEDIR -type d -exec chmod 755 {} \;
                        find $HOMEDIR -type d -name cgi-bin -exec chmod 755 {} \;
                        find $HOMEDIR -type f \( -name "*.pl" -o -name "*.perl" \) -exec chmod 755 {} \;
                        chmod 711 $HOMEDIR
                fi
done
