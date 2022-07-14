export OPAMREUSEBUILDDIR=true
# opam configuration
test -r /home/aya/.opam/opam-init/init.sh && . /home/aya/.opam/opam-init/init.sh > /dev/null 2> /dev/null || true

append_path () {
    case ":$PATH:" in
        *:"$1":*)
            ;;
        *)
            PATH="${PATH:+$PATH:}$1"
    esac
}

append_path "$HOME/.local/bin"

unset -f append_path

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

#PS1='[\u@\h \W]\$ '
