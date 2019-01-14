{ pkgs ? import <nixpkgs> {} }:
with pkgs; mkShell {
    name = "Rethinking";
    buildInputs = [ jdk
                    fzf
                    wget
                  ];
    shellHook = ''
        . ~/miniconda3/etc/profile.d/conda.sh

        strcd() { cd "$(dirname $1)"; }
        withfzf() {
            local h
            h=$(fzf)
            if (( $? == 0 )); then
                $1 "$h"
            fi
        }

        alias cdfzf="withfzf strcd"
        alias vimfzf="withfzf vim"
        export -f withfzf

        cd src/
        rethinking_path=$(pwd)
        env="Rethinking"
        sh install_env.sh $env
        conda activate $env
        sh install_rethinking.sh
        cd ../

        alias ls='ls --color=auto'
        alias ll='ls -al'

        lintr() {
            R -e "library(lintr); lint('$1')" | \
                awk '/> /{ found=1 } { if (found) print }'
        }

        export -f lintr
        export rethinking_path
    '';
}
