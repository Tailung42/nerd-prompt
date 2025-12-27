# Custom Oh My Zsh Theme - Based on nebirhos with Nerd Fonts
# Save this as ~/.oh-my-zsh/custom/themes/custom.zsh-theme

# Nerd Font Icons
local host_icon='󰒋'
local dir_icon=''
local git_icon='󰊢'
local dirty_icon=''
local clean_icon=''

# Get the current ruby version in use with RVM:
if [ -e ~/.rvm/bin/rvm-prompt ]; then
    RUBY_PROMPT_="%{$fg_bold[blue]%}rvm:(%{$fg[green]%}\$(~/.rvm/bin/rvm-prompt s i v g)%{$fg_bold[blue]%})%{$reset_color%} "
else
  if which rbenv &> /dev/null; then
    RUBY_PROMPT_="%{$fg_bold[blue]%}rbenv:(%{$fg[green]%}\$(rbenv version | sed -e 's/ (set.*$//')%{$fg_bold[blue]%})%{$reset_color%} "
  fi
fi

# Host and directory with icons
HOST_PROMPT_="%{$fg_bold[magenta]%}$host_icon ➜ %{$reset_color%}%{$fg_bold[cyan]%}$dir_icon %c%{$reset_color%} "

# Custom git prompt with colored branch names
function git_prompt_info_custom() {
  local ref
  ref=$(command git symbolic-ref HEAD 2> /dev/null) || \
  ref=$(command git rev-parse --short HEAD 2> /dev/null) || return 0
  
  local git_status
  git_status=$(git status --porcelain 2> /dev/null)
  
  local branch_color
  local status_icon
  
  if [[ -n $git_status ]]; then
    branch_color="red"
    status_icon="%{$fg[yellow]%}$dirty_icon"
  else
    branch_color="green"
    status_icon="%{$fg[green]%}$clean_icon"
  fi
  
  echo "%{$fg_bold[red]%}$git_icon [%{$fg[$branch_color]%}${ref#refs/heads/} $status_icon%{$fg[red]%} ]%{$reset_color%} "
}

GIT_PROMPT='$(git_prompt_info_custom)'
PROMPT="$HOST_PROMPT_$RUBY_PROMPT_$GIT_PROMPT%{$fg_bold[green]%}❱ %{$reset_color%}"