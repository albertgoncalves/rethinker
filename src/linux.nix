{ pkgs ? import <nixpkgs> {} }:
with pkgs; mkShell {
    name = "Rethinking";
    buildInputs = [ R
                    rPackages.rstan
                    rPackages.ggplot2
                    rPackages.mvtnorm
                    rPackages.coda
                    python36Packages.csvkit
                    fzf
                    glibcLocales
                  ];
    shellHook = ''
        set -e

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
        sh install_rethinking.sh
        cd ../
    '';
}
