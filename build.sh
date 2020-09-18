#!/bin/bash
DIR_BASE=$(cd ${BASH_SOURCE[0]%/*} && pwd)
RELEASE_VERSION=$1
SPEC_FILE=ovpn-convert.spec
if [ "$RELEASE_VERSION" == "" ]; then
  echo "First argument must be release version to compile"; exit 1
fi

set -e

if [ -f ".${SPEC_FILE}" ]; then
  unlink .${SPEC_FILE}
fi

cp ${SPEC_FILE}.template .${SPEC_FILE}
sed -i "s/__RELEASE_VERSION__/${RELEASE_VERSION}/g" .${SPEC_FILE}

rm -rf ovpn-convert ovpn-convert-${RELEASE_VERSION}
mkdir -p ~/rpmbuild/SOURCES
rm -rf ~/rpmbuild/SOURCES/ovpn-convert-${RELEASE_VERSION} ovpn-convert-${RELEASE_VERSION}
set -e

od=$(pwd)
(cd $od && cmake . && make && cd $od/.. && rm -rf ovpn-convert-$RELEASE_VERSION && cp -prf $od ovpn-convert-$RELEASE_VERSION && tar -czf ~/rpmbuild/SOURCES/ovpn-convert-${RELEASE_VERSION}.tar.gz ovpn-convert-$RELEASE_VERSION/ovpn-convert && tar -tzf ~/rpmbuild/SOURCES/ovpn-convert-${RELEASE_VERSION}.tar.gz)



rpmbuild -bb .${SPEC_FILE}
set +e

rm -rf ovpn-convert ovpn-convert-${RELEASE_VERSION}

