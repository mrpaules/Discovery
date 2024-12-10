#!/bin/bash

#This script creates an RPM package that installs a file containing the installation date, time, and hostname
#in /etc/challenge

echo "Setting RPM Build Environment"

sudo dnf install -y rpmdevtools

echo "Setting up RPM build Directory"

rpmdev-setuptree

echo "Generating necessary scripts"

cd ~/rpmbuild/SOURCES

touch generate_challenge.sh

echo "#!/bin/bash" > generate_challenge.sh
echo "echo Installation Date: $(date)" >> generate_challenge.sh
echo "echo Hostname: $(hostname)" >> generate_challenge.sh
chmod +x generate_challenge.sh

#Creating the spec file for the build
echo "Creating the spec file"
cd ~/rpmbuild/SPECS/

touch challenge.spec

echo "Adding .spec file contents"

echo "Name:	challenge" > challenge.spec
echo "Version:	1.0" >> challenge.spec
echo "Release:	1%{?dist}" >> challenge.spec
echo "Summary:	Challenge file with install date, time and hostname" >> challenge.spec
echo "License:	GPL" >> challenge.spec
echo "Source0:	~/rpmbuild/SOURCES/generate_challenge.sh" >> challenge.spec 
echo "" >> challenge.spec
echo "Requires:	bash" >> challenge.spec
echo "%description" >> challenge.spec
echo "Package creates file with install date, time and hostname in /etc/challenge" >> challenge.spec
echo "" >> challenge.spec
echo -e "%install mkdir -p %{buildroot}/etc\n" >> challenge.spec

echo -e "sudo ~/rpmbuild/SOURCES/generate_challenge.sh\n" >> challenge.spec
#echo -e "cp ~/rpmbuild/SOURCES/generate_challenge.sh %{buildroot}/etc/challenge\n" >> challenge.spec

echo "%files" >> challenge.spec
echo -e "/etc/challenge\n" >> challenge.spec

echo "%changelog" >> challenge.spec
echo "* Mon Dec 09 2024 Charles Paules <mrpaules@gmail.com> - 1.0-1" >> challenge.spec
echo "- Initial Package creation." >> challenge.spec
echo ".spec file created"
#Building RPM package
echo "Building RPM Package"
rpmbuild -ba challenge.spec

#Installing the RPM Package
echo "Installing RPM Package"
sudo rpm -ivh ~/rpmbuild/RPMS/x86_64/challenge-1.0-1.el9.x86_64.rpm

#Verifying Package installation
echo "Check if package installed"
cat /etc/challenge
