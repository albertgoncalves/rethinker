{ pkgs ? import <nixpkgs> {} }:
with pkgs; mkShell {
    name = "Rethinking";
    buildInputs = [
        (with rPackages; [
            R
            rstan
            ggplot2
            mvtnorm
            coda
            lintr
        ])
        fzf
        glibcLocales
    ] ++ (with python37Packages; [(csvkit.overridePythonAttrs (oldAttrs: {
        doCheck = false;
    }))]);
    shellHook = ''
        alias open=xdg-open

        cd src/
        rethinking_path=$(pwd)
        sh install_rethinking.sh
        cd ../

        lintr() {
            R -e "library(lintr); lint('$1')" \
                | awk '/> /{ found=1 } { if (found) print }'
        }

        export -f lintr
        export rethinking_path
    '';
}
