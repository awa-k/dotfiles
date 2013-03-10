# Katz's zprofile for Mac OSX

#
# start ssh-agent if if uid is greater than 1000 (regular user)
#
if  [[ $UID -gt 1000 ]] then
    # SSH-Agent
    if [[ -d "${HOME}/.ssh" ]] then
        SSH_AGENT="/usr/bin/ssh-agent"
        if [[ -e $SSH_AGENT && -z `pgrep -u $UID ssh-agent` ]] then
            eval $(ssh-agent)
        fi
    fi
fi

#
# PYTHONPATH for homebrew
#
export PYTHONPATH=/usr/local/lib/python2.7/site-packages
