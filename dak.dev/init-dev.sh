#! /bin/bash

echo -n "CONFIGURING DAK ENVIRONMENT ... "
echo 'export PATH="/srv/dak/bin:${PATH}"' > ~/.bashrc
echo 'export PATH="/srv/dak/bin:${PATH}"' > /home/dak/.bashrc
source ~/.bashrc

USER_CMD="sudo -E -u dak -s -H"
DAK="/srv/dak/bin/dak"
service postgresql start 1>/dev/null 2>&1
service nginx start 1>/dev/null 2>&1
echo "DONE"


KEY=451DD5811062DFC93DF54EEC259531ED17EE37C1
KEYPATH=/dak.dev/keys/.no-key
KEYRING=
# DO SOME KEY SELECTION LOGIC HERE IF NEEDED

if [ !-z "$KEYRING" ]; then
    if [ ! -f "$KEYRING" ]; then
        echo "ERROR: KEY FILE NOT FOUND AT $KEYPATH"
        exit 1
    fi
    dpkg -i $KEYRING #1>/dev/null 2>&1
fi

echo -n "IMPORTING TEST REPO GPG KEY ... "
$USER_CMD gpg --homedir /srv/dak/keyrings/s3kr1t/dot-gnupg --import $KEYPATH 1>/dev/null 2>&1
echo DONE

echo -n "IMPORTING TEST DEVELOPER GPG KEY ... "
$USER_CMD gpg --no-default-keyring --keyring /srv/dak/keyrings/upload-keyring.gpg --import $KEYPATH  1>/dev/null 2>&1
echo "DONE"

echo -n "IMPORTING dak REPO GPG KEY ... "
$USER_CMD $DAK import-keyring -U '%s' /srv/dak/keyrings/upload-keyring.gpg  1>/dev/null 2>&1
echo "DONE"

echo -n "INITING AN EMPTY REPO ... "
$USER_CMD $DAK admin architecture add amd64 "KSLinux 26 AMD64" 1>/dev/null 2>&1
$USER_CMD $DAK admin suite add-all-arches trixie 26 origin=KSLinux label=KSL_26 codename=trixie signingkey=$KEY 1>/dev/null 2>&1

#$USER_CMD $DAK admin component rm main 1>/dev/null 2>&1
#$USER_CMD $DAK admin component rm contrib 1>/dev/null 2>&1
#$USER_CMD $DAK admin component rm non-free 1>/dev/null 2>&1
#$USER_CMD $DAK admin component rm non-free-firmware 1>/dev/null 2>&1

$USER_CMD $DAK admin s-c add trixie main contrib non-free non-free-firmware 1>/dev/null 2>&1

$USER_CMD $DAK init-dirs 1>/dev/null 2>&1

$USER_CMD $DAK generate-packages-sources2 1>/dev/null 2>&1

$USER_CMD $DAK generate-release 1>/dev/null 2>&1
echo "DONE"

debootstrap --no-check-gpg trixie /test file:///srv/dak/ftp 1>/dev/null 2>&1

rm -rvf /test 1>/dev/null 2>&1

ln -s /srv/dak/ftp /var/www/html/kslinux
