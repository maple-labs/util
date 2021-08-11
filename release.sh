#!/usr/bin/env bash
set -e

while getopts v: flag
do
    case "${flag}" in
        v) version=${OPTARG};;
    esac
done

echo $version

./build.sh -c ./config/prod.json

rm -rf ./package
mkdir -p package

echo "{
  \"name\": \"@maplelabs/util\",
  \"version\": \"${version}\",
  \"description\": \"Util Artifacts and ABIs\",
  \"author\": \"Maple Labs\",
  \"license\": \"AGPLv3\",
  \"repository\": {
    \"type\": \"git\",
    \"url\": \"https://github.com/maple-labs/util.git\"
  },
  \"bugs\": {
    \"url\": \"https://github.com/maple-labs/util/issues\"
  },
  \"homepage\": \"https://github.com/maple-labs/util\"
}" > package/package.json

mkdir -p package/artifacts
mkdir -p package/abis

cat ./out/dapp.sol.json | jq '.contracts | ."contracts/Util.sol" | .Util' > package/artifacts/Util.json
cat ./out/dapp.sol.json | jq '.contracts | ."contracts/Util.sol" | .Util | .abi' > package/abis/Util.json

npm publish ./package --access public

rm -rf ./package
