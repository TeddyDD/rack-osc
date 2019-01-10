run:
    love .
    
deploy: build
    zip -r ~/Sync/rack.love *

build:
    tup
