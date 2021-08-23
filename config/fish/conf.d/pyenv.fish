if which pyenv &> /dev/null
    status is-interactive; and pyenv init --path | source
    pyenv init - | source
end
