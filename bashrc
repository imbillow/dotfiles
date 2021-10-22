export OPAMREUSEBUILDDIR=true
# opam configuration
test -r /home/aya/.opam/opam-init/init.sh && . /home/aya/.opam/opam-init/init.sh > /dev/null 2> /dev/null || true

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

#PS1='[\u@\h \W]\$ '
