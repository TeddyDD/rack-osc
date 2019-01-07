run:
    love .
    
deploy: build
    zip ~/Sync/rack.love *

build:
    tup
