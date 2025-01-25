# personal stuff
function gsshx {
        local usr="deployer"
        local vm=$1
        if [[ -n "$vm" ]]
        then
                echo "sshing to $vm"
                case $vm in
                        db1) vm="db1-as1b";;
                        db2) vm="db2-as1b";;
                esac
        else
                echo "no destination quiting"
                return
        fi
        local zone
        if [[ -n "$3" ]]
        then
                usr=$3
                zone=$2
        elif [[ -n "$2" ]]
        then
                zone=$2
        else
                case $vm in
                        sws1 | ppws1 | sws2 | db3) zone="ase1b";;
                        analytics) zone="uc1c"; usr="aurora";;
                esac
        fi

        case $zone in
                ase1b)  zone="asia-southeast1-b";;
                as1a)   zone="asia-south1-a";;
                as1c)   zone="asia-south1-c";;
                uc1c)   zone="us-central1-c";;
                *)      zone="asia-south1-b";;
        esac

        command gcloud beta compute ssh "$usr@$vm" --zone "$zone"
}

function gsq() {
        local N
        if [[ -n "$1" ]]
        then
                N=$1
        else
                N=1
        fi
        local PN=$((N - 1))
        local COMMIT_MSG=$(git log --skip=$PN --max-count=1 --pretty=%B)
        git reset --soft HEAD~$N
        git add .
        git commit -m "$COMMIT_MSG"
}


alias gco="git checkout "
alias gcom="git checkout master"
alias gcop="git checkout pre_production"
alias gcos="git checkout staging"
alias gcb="git checkout -b"
gbo() {
        case $1 in
                stg)    local BASE="staging";;
                pp)             local BASE="pre_production";;
                mas)    local BASE="master";;
                *)              local BASE=$1;;
        esac

        command git checkout $BASE
        command git pull
        command git checkout -b $2
}
alias gcm="git commit -m"
alias gc="git commit"
alias gpom="git pull origin master"
alias gpop="git pull origin pre_production"
alias gpos="git pull origin staging"
alias gp="git pull"
alias gpoh="git push origin HEAD"
alias gm="!git for-each-ref --sort='-authordate' --format='%(authordate)%09%(objectname:short)%09%(refname)' refs/heads | sed -e 's-refs/heads/--'"
alias gl="git log --pretty=format:'%C(auto,yellow)%h%C(auto,magenta)% G? %C(auto,blue)%>(12,trunc)%ad %C(auto,green)%<(7,trunc)%aN%C(auto,reset)%s%C(auto,red)% gD% D'"
alias gs="git stash"
alias gss="git stash save"
alias gsl="git stash list"
alias gspop="git stash pop"

gpick() {
        if [[ -n $2 ]] && [[ -n $1 ]]
        then
                command git cherry-pick $1^..$2
        elif [[ -n $1 ]]
        then
                command git cherry-pick $1
        elif [[ $1 = "c" ]]
        then
                command git cherry-pick --continue
        else
                echo "not a proper command"
        fi
}
