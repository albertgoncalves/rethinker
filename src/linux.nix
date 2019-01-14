{ pkgs ? import <nixpkgs> {} }:
with pkgs; mkShell {
    name = "Rethinking";
    buildInputs = [ R
                    rPackages.rstan
                    rPackages.ggplot2
                    rPackages.mvtnorm
                    rPackages.coda
                    rPackages.lintr
                    python36Packages.csvkit
                    fzf
                    glibcLocales
                  ];
    shellHook = ''
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
        alias open=xdg-open
        export -f withfzf

        cd src/
        rethinking_path=$(pwd)
        sh install_rethinking.sh
        cd ../

        lintr() {
            R -e "library(lintr); lint('$1')" | \
                awk '/> /{ found=1 } { if (found) print }'
        }

        export -f lintr
        export rethinking_path
    '';
}
