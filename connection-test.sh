if curl -Lsf google.com >/dev/null; then
    echo "Puh, its up!"
else
    echo 'Cannot connect to the interwebz, Check your network settings.' >&2
    exit 1
fi
