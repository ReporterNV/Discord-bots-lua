cat 1  | grep -Eo '\"[0-9]+\"[[:space:]]\"[[:alnum:]]+\"' | grep -Eo "[[:alnum:]]+\"$" | grep -Eo '\w+' 1> 1.txt
