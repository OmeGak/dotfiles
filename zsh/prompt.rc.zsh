autoload colors && colors
# cheers, @ehrenmurdick
# http://github.com/ehrenmurdick/config/blob/master/zsh/prompt.zsh

if (( $+commands[git] ))
then
  git="$commands[git]"
else
  git="/usr/bin/git"
fi

git_branch() {
  echo $($git symbolic-ref HEAD 2>/dev/null | awk -F/ {'print $NF'})
}

git_dirty() {
  if $(! $git status -s &> /dev/null)
  then
    echo ""
  else
    if [[ $($git status --porcelain) == "" ]]
    then
      echo "(%{$fg_bold[green]%}$(git_prompt_info)%{$reset_color%})"
    else
      if [[ $(unpushed) == "" ]]
      then
        echo "(%{$fg_bold[yellow]%}$(git_prompt_info)%{$reset_color%})"
      else
        echo "(%{$fg_bold[red]%}$(git_prompt_info)%{$reset_color%})"
      fi
    fi
  fi
}

git_prompt_info () {
 ref=$($git symbolic-ref HEAD 2>/dev/null) || return
 echo "${ref#refs/heads/}"
}

unpushed () {
  local revision
  revision="$($git rev-parse --symbolic-full-name @{push} 2> /dev/null)"
  [[ $? != 0 ]] && revision="$($git rev-parse --symbolic-full-name @{upstream} 2> /dev/null)"
  $git cherry -v ${revision} 2> /dev/null
}

need_push () {
  if [[ $(unpushed) == "" ]]
  then
    echo " "
  else
    echo " with %{$fg_bold[magenta]%}unpushed%{$reset_color%} "
  fi
}

ruby_version() {
  if (( $+commands[rbenv] ))
  then
    echo "$(rbenv version | awk '{print $1}')"
  fi

  if (( $+commands[rvm-prompt] ))
  then
    echo "$(rvm-prompt | awk '{print $1}')"
  fi
}

rb_prompt() {
  if ! [[ -z "$(ruby_version)" ]]
  then
    echo "%{$fg_bold[yellow]%}$(ruby_version)%{$reset_color%} "
  else
    echo ""
  fi
}

username() {
  echo "%{$fg_bold[white]%}$(whoami)%{$reset_color%}"
}

directory_name(){
  echo "%{$fg_bold[blue]%}%1~%\%{$reset_color%}"
}

export PROMPT=$'\n$(username): $(directory_name) $(git_dirty)$(need_push)\n› '
set_prompt() {
  export RPROMPT=""
}

precmd() {
  wtitle "zsh" "%m" "%55<...<%~"
  set_prompt
}
