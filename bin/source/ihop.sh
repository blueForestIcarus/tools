ihop () {
    if ! [ -z "$1" ]; then
        dir="`i $1`"
        if [ -z "$dir" ]; then
            echo "ERR: \"$1\" not in index."
        else
            cd "$dir"
            pwd
        fi
    else
        target=`choosefrom <( i )  | cut -f 1`
        ihop "$target"
    fi
}
