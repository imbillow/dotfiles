preappend_path () {
    case ":$PATH:" in
        *:"$1":*)
            ;;
        *)
            PATH="$1${PATH:+:$PATH}"
    esac
}

preappend_path $HOME/.local/bin
preappend_path $HOME/.local/share/gem/ruby/3.0.0/bin
preappend_path $HOME/.ghcup/bin
preappend_path $HOME/.cabal/bin
preappend_path $HOME/.cargo/bin/
preappend_path $HOME/.rustup/toolchains/nightly-x86_64-unknown-linux-gnu/bin/
preappend_path $HOME/.luarocks/bin/

export PATH
unset -f preappend_path

export OPAMREUSEBUILDDIR=true
# opam configuration
test -r /home/aya/.opam/opam-init/init.sh && . /home/aya/.opam/opam-init/init.sh > /dev/null 2> /dev/null || true

source $HOME/.env

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

#PS1='[\u@\h \W]\$ '
