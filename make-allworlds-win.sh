#!/bin/sh
zip -x '*.git*' -r allworlds.love ./
mv ./allworlds.love ../dist/
cat ../dist/love.exe ../dist/allworlds.love > ../dist/allworlds.exe
rm ../dist/allworlds.love
cd ../dist/
mkdir allworlds
cp * ./allworlds/
zip allworlds.zip ./allworlds/* -x '*love.exe*' -x '*allworlds.love*'
zip -u allworlds.zip ../allworlds/readme.md
