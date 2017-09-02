#!/bin/bash
PKG=baliance.com/gooxml
ALLPKGS=`go list $PKG/...`

cd $GOPATH/src/$PKG
echo "Prebuilding"
go build -i $PKG/...
go test -i $PKG/...

echo -e "mode: atomic"  > coverage.txt
echo "Running tests"
for pkg in $ALLPKGS; do 
    echo $pkg
    go test -coverprofile=coverprofile -covermode=atomic $pkg
    if [ -f coverprofile ]; then
        tail -n+2 coverprofile >> coverage.txt
        rm coverprofile
    fi
done
rm coverage.out
bash <(curl -s https://codecov.io/bash)