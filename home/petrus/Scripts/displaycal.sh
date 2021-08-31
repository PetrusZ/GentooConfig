#/bin/bash

for PY_EXEC in $(qlist displaycal | grep exec)
do
    NAME=$(echo $PY_EXEC | awk -F '/' '{print $6}')
    ln -s $PY_EXEC /usr/bin/$NAME
done
