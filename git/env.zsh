# Git user setup with env vars so to allow overrides with `direnv`
# Inspired by https://collectiveidea.com/blog/archives/2016/04/04/multiple-personalities-in-git
export GIT_AUTHOR_NAME="${GIT_AUTHOR_NAME=Alejandro Avilés}"
export GIT_COMMITTER_NAME="${GIT_COMMITTER_NAME=$GIT_AUTHOR_NAME}"
export GIT_AUTHOR_EMAIL="${GIT_AUTHOR_EMAIL=omegak@gmail.com}"
export GIT_COMMITTER_EMAIL="${GIT_COMMITTER_EMAIL=GIT_AUTHOR_EMAIL}"

export GIT_DUET_GLOBAL=true
export GIT_DUET_ROTATE_AUTHOR=true
