# Custom Oh My Zsh Theme - Based on nebirhos with Nerd Fonts
# Save this as ~/.oh-my-zsh/custom/themes/custom.zsh-theme

# Nerd Font Icons
local host_icon='󰣛'
local dir_icon=''
local git_icon='󰊢'
local dirty_icon=''
local clean_icon=''

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

# Enhanced git prompt with detailed status indicators
function git_prompt_info_custom() {
  local ref
  ref=$(command git symbolic-ref HEAD 2> /dev/null) || \
  ref=$(command git rev-parse --short HEAD 2> /dev/null) || return 0
  
  local branch_name="${ref#refs/heads/}"
  local branch_color="green"
  local status_icon="%{$fg[green]%}$clean_icon"
  
  # Get repository status
  local staged_count=$(git diff --cached --numstat 2>/dev/null | wc -l | tr -d ' ')
  local modified_count=$(git diff --numstat 2>/dev/null | wc -l | tr -d ' ')
  local untracked_count=$(git ls-files --others --exclude-standard 2>/dev/null | wc -l | tr -d ' ')
  
  # Get ahead/behind info
  local ahead_behind=""
  local upstream=$(git rev-parse --abbrev-ref @{upstream} 2>/dev/null)
  if [[ -n $upstream ]]; then
    local ahead=$(git rev-list --count @{upstream}..HEAD 2>/dev/null)
    local behind=$(git rev-list --count HEAD..@{upstream} 2>/dev/null)
    
    if (( ahead > 0 && behind > 0 )); then
      ahead_behind=" %{$fg[red]%}󰹺 $ahead%{$reset_color%}%{$fg[blue]%}󰁅 $behind%{$reset_color%}"
      branch_color="red"
    elif (( ahead > 0 )); then
      ahead_behind=" %{$fg[green]%}󰁝 $ahead%{$reset_color%}"
    elif (( behind > 0 )); then
      ahead_behind=" %{$fg[blue]%}󰁅 $behind%{$reset_color%}"
      branch_color="yellow"
    fi
  fi
  
  # Build status info
  local git_status_info=""
  if (( staged_count > 0 )); then
    git_status_info+=" %{$fg[green]%}󰐗 $staged_count%{$reset_color%}"
    branch_color="yellow"
    status_icon=""
  fi
  if (( modified_count > 0 )); then
    git_status_info+=" %{$fg[yellow]%}󰏫 $modified_count%{$reset_color%}"
    branch_color="yellow"
    status_icon=""
  fi
  if (( untracked_count > 0 )); then
    git_status_info+=" %{$fg[red]%}󰋗 $untracked_count%{$reset_color%}"
    branch_color="red"
    status_icon=""
  fi
  
  # Only show clean icon if there are no changes
  if [[ -z $git_status_info ]]; then
    status_icon="%{$fg[green]%}$clean_icon"
  fi
  
  echo "%{$fg_bold[red]%}$git_icon [%{$fg[$branch_color]%}${branch_name}${ahead_behind}${git_status_info} ${status_icon}%{$fg[red]%}]%{$reset_color%} "
}

GIT_PROMPT='$(git_prompt_info_custom)'
PROMPT="$HOST_PROMPT_$RUBY_PROMPT_$GIT_PROMPT
%{$fg_bold[green]%}❱ %{$reset_color%}"
