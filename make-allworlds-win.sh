#!/bin/sh
zip -x '*.git*' -r allworlds.love ./
mv ./allworlds.love ../dist/
cat ../dist/love.exe ../dist/allworlds.love > ../dist/allworlds.exe
rm ../dist/allworlds.love
cd ../dist/
zip allworlds.zip -r ./ -x '*love.exe*' -x '*allworlds.love*' 