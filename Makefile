prod    :; ./build.sh -c ./config/prod.json
dev     :; ./build.sh -c ./config/dev.json
clean   :; dapp clean
test    :; ./test.sh
release :; ./release.sh
