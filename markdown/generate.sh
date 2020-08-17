#!/bin/bash

# A special csplit(1) is needed, see https://github.com/reale/coreutils

CSPLIT=../../coreutils/src/csplit

$CSPLIT -o 1 -sz -n 2 -f '' -b '%02d.md' ../tex/mediterranea.tex '/\\poemtitle{.*}/' '{*}'

cat > README.md <<EOF
# Mediterranea

* [Prefazione](PREFACE.md)

* Mediterranea
EOF

for f in ??.md
do
    poemtitle="$(sed -n 's/\\poemtitle{\(.*\)}/\1/p' "$f")"
    echo "    * [$poemtitle]($f)" >> README.md

    sed -i 's/\\poemtitle{\(.*\)}/# \1/' "$f"
    sed -i 's/\\[^{\]\+\({[^}]\+}\)*//'  "$f"
    sed -i 's/\\\\/  /'                  "$f"
    sed -i 's/^[ \t]*//'                 "$f"

    cat -s "$f" > "$f~" && mv "$f~" "$f"

    sed -i '${/^$/d;}'                   "$f"
done
