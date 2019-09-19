# To Build:
#
# vagrant up / vagrant provision
#

%define install_dir /opt/visualvm
%define apps_dir /usr/share/applications

# Disable brp-java-repack-jars which is really slow, and not useful for VisualVM.
%define __jar_repack 0
# Disable Debug extraction
%global debug_package %{nil}

Name:	    visualvm
Version:    1.4.3
Release:    1
Summary:    All-in-One Java Troubleshooting Tool

Group:      Development/Tools
License:    GPLv2
URL:        https://visualvm.github.io/index.html
BuildArch:  noarch
Source0:    visualvm-%{version}.zip
Source1:    visualvm.desktop
Source2:    visualvm-logo.png
Requires:   java
BuildRoot:  %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)

# Disable automatic dependency processing, so that the rpm package only
# provides visualvm
AutoReqProv: no

%description
VisualVM is a visual tool integrating commandline JDK tools and lightweight profiling capabilities.
Designed for both development and production time use.

%prep
%setup -q -c -n visualvm-%{version}

%build

%install
export QA_RPATHS=255
# ignore rpaths errors (or else this step fails)

mkdir -p "%{buildroot}%{install_dir}"
mkdir -p "%{buildroot}%{apps_dir}"
cp -R visualvm_*/* "%{buildroot}%{install_dir}/"

install    -m 644 %_sourcedir/visualvm.desktop %{buildroot}/%{apps_dir}
chmod +x "%{buildroot}%{install_dir}/bin/visualvm"

%files
/*

%changelog
* Thu Sep 19 2019 Thomas Kriener <thomas@kriener.de> - 1.4.3-1
- Use visualvm 1.4.3

