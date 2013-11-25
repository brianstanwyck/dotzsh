#
# dotzsh : https://github.com/dotphiles/dotzsh
#
# Defines general aliases and functions.
#
# Authors:
#   Robby Russell <robby@planetargon.com>
#   Suraj N. Kurapati <sunaku@gmail.com>
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#   Ben O'Hara <bohara@gmail.com>
#

# Load dependencies.
dzmodload 'spectrum'

# Correct commands.
setopt CORRECT
CORRECT_IGNORE='_*'

# Aliases

# Reload dotzsh
alias dzs='source ~/.zshrc && echo "Reloaded $HOME/.zshrc!"'
alias dzD='setopt XTRACE && echo "DEBUG ENABLED" && dzs'
alias dzd='unsetopt XTRACE && dzs'

# Disable correction.
for command in ack cd cp ebuild gcc gist grep heroku \
  ln man mkdir mv mysql rm scp
do
  if (( $+commands[$command] )); then
    alias $command="nocorrect ${command}"
  fi
done

# Disable globbing.
alias fc='noglob fc'
alias find='noglob find'
alias history='noglob history'
alias locate='noglob locate'
alias rake='noglob rake'

# Define general aliases.
alias cp="${aliases[cp]:-cp} -i"
alias ln="${aliases[ln]:-ln} -i"
alias mkdir="${aliases[mkdir]:-mkdir} -p"
alias mv="${aliases[mv]:-mv} -i"
alias rm="${aliases[rm]:-rm}"

if (( $+commands[htop] )); then
  alias top=htop
else
  alias topc='top -o cpu'
  alias topm='top -o vsize'
fi

#### global aliases
# zsh buch s.82 (z.B. find / ... NE)
alias -g NE='2>|/dev/null'
alias -g NO='&>|/dev/null'

alias -g G='| grep -'
alias -g P='2>&1 | $PAGER'
alias -g L='| less'
alias -g M='| most'
alias -g C='| wc -l'

### Functions

# Serves a directory via HTTP.
function http-serve {
  local port="${1:-8000}"
  sleep 1 && open "http://localhost:${port}/" &
  python -m SimpleHTTPServer ${port}
}

# Makes a directory and changes to it.
function mkdcd {
  [[ -n "$1" ]] && mkdir -p "$1" && builtin cd "$1"
}

# Changes to a directory and lists its contents.
function cdls {
  builtin cd "$argv[-1]" && ls "${(@)argv[1,-2]}"
}

# Pushes an entry onto the directory stack and lists its contents.
function pushdls {
  builtin pushd "$argv[-1]" && ls "${(@)argv[1,-2]}"
}

# Pops an entry off the directory stack and lists its contents.
function popdls {
  builtin popd "$argv[-1]" && ls "${(@)argv[1,-2]}"
}

# Prints columns 1 2 3 ... n.
function slit {
  awk "{ print ${(j:,:):-\$${^@}} }"
}

# Finds files and executes a command on them.
function find-exec {
  find . -type f -iname "*${1:-}*" -exec "${2:-file}" '{}' \;
}

# Displays user owned processes status.
function psu {
  ps -{U,u}" ${1:-$USER}" -o 'pid,%cpu,%mem,command' "${(@)argv[2,-1]}"
}

encode64(){ echo -n $1 | base64 }
decode64(){ echo -n $1 | base64 -d }

function up {
  for parent in {1..${1:-1}}; do
    builtin cd ..
  done
}

function scratch {
  _scratch=$HOME/scratch
  if [[ "$1" == "" ]]; then
    echo -e "Usage: $0 \"name\"\n"
    echo -e "Existing scratch dirs:\n"
    echo -n "   "
    ls $_scratch/
    echo
  else
    _scratch=$_scratch/$1
    if [[ -d $_scratch ]]; then
      cd $_scratch
    else
      mkdir -p $_scratch
      cd $_scratch
    fi
  fi
  unset _scratch
}

