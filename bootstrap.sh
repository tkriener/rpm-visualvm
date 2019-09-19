#!/bin/bash

VERSION=$(grep "Version:" /vagrant/visualvm.spec |cut -d ":" -f2 |tr -d "[:space:]")
RELEASE=$(grep "Release:" /vagrant/visualvm.spec |cut -d ":" -f2 |tr -d "[:space:]")
ARCH=$(grep "BuildArch:" /vagrant/visualvm.spec |cut -d ":" -f2 |tr -d "[:space:]")

echo "Version: $VERSION-$RELEASE BuildArch: $ARCH"

# Exclude kernels from update as they may break hgfs under VMWare
yum --exclude=kernel\* update -y
yum -y install policycoreutils-python rpmdevtools
if [ ! -f /root/.rpmmacros ];
then
  rpmdev-setuptree
fi

if [ ! -f /root/rpmbuild/SOURCES/visualvm-$VERSION.zip ];
then
  curl -L -o  /root/rpmbuild/SOURCES/visualvm-$VERSION.zip https://github.com/oracle/visualvm/releases/download/$VERSION/visualvm_143.zip
fi

cp "/vagrant/visualvm-logo.png" "/root/rpmbuild/SOURCES/"
cp "/vagrant/visualvm.desktop" "/root/rpmbuild/SOURCES/"
cp "/vagrant/visualvm.spec" "/root/rpmbuild/SPECS/"

if [ ! -f /vagrant/visualvm-$VERSION-$RELEASE.noarch.rpm ];
then
  cd /root/rpmbuild
  rpmbuild --buildroot "/root/rpmbuild/BUILDROOT" /root/rpmbuild/SPECS/visualvm.spec -bb
  cp /root/rpmbuild/RPMS/noarch/visualvm-$VERSION-$RELEASE.noarch.rpm /vagrant
fi
