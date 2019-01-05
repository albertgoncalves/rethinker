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
        env="Rethinking"
        sh install_env.sh $env
        conda activate $env
        sh install_rethinking.sh
        cd ../
    '';
}
