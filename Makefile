prod    :; ./build.sh -c ./config/prod.json
dev     :; ./build.sh -c ./config/dev.json
ci      :; ./test.sh
clean   :; dapp clean
test    :; ./test.sh
