:: Place this file on your portable / USB drive

@echo off

:: Get current drive letter into WD.
for /F %%A in ('cd') do set WD=%%~dA
:: This will get the current drive letter for your USB drive, so whatever machine you plug into, you don’t have to worry what letter Windows maps it to.

:: Store any existing mounts, unmount them, and replace with mounts to current drive letter.
cygwin\bin\mount -m | cygwin\bin\sed s/mount/"%WD%\/cygwin\\/bin\\/mount"/ > cygwin\tmp\mount.log
cygwin\bin\umount -U
cygwin\bin\mount -f %WD%cygwin/ /
cygwin\bin\mount -f %WD%cygwin\bin /usr/bin
cygwin\bin\mount -f %WD%cygwin\lib /usr/lib

:: Set some general environment variables
set path=%path%;%WD%cygwin\bin;%WD%cygwin\usr\X11R6\bin
set ALLUSERSPROFILE=%WD%ProgramData
set ProgramData=%WD%ProgramData
set CYGWIN=nodosfilewarning

:: This specifies the login to use.
set USERNAME=YOUR_USER_NAME
set HOME=/home/%USERNAME%
set GROUP=None
set GRP=
:: Replace “YOUR_USER_NAME” with the user name that you want Cygwin to use. Cygwin will show the file owner as this user name, and that will also be the name of your home directory.
:: Now, the idea here is that when you run this bat file, it is going to get your current Windows login, no matter what machine you are on, and it is going to map that Windows user to the Cygwin user and group that you indicated in that section.

:: If this is the current user's first time running Cygwin, add them to /etc/passwd
for /F %%A in ('cygwin\bin\mkpasswd.exe -c ^| cygwin\bin\gawk.exe -F":" '{ print $5 }'') do set SID=%%A
findstr /m %SID% cygwin\etc\passwd
if %errorlevel%==1 (
echo Adding a user for SID: %SID%
for /F %%A in ('cygwin\bin\gawk.exe -F":" '/^%GROUP%/ { print $3 }' cygwin/etc/group') do set GRP=%%A
)
if "%GRP%" neq "" (
echo Adding to Group number: %GRP%
cygwin\bin\printf.exe "\n%USERNAME%:unused:1001:%GRP%:%SID%:%HOME%:/bin/bash" >> cygwin\etc\passwd
)
set GRP=
set SID=
set GROUP=
:: These commands use the Cygwin “mkpasswd.exe” program to get your SID for your current Windows user, and adds it into Cygwin’s \etc\passwd file, mapping the SID to your specified username and group.
:: Again, not that I have Cygwin installed in the \cygwin folder off the root of my portable drive. If you choose a different path, then you will have to edit the paths in this bit of script.

:: Make a symlink from /curdrive to the current drive letter.
cygwin\bin\rm.exe /curdrive
cygwin\bin\ln.exe -s %WD% /curdrive
:: This makes a symlink from “/curdrive” to our current drive letter. That way you can always “cd /curdrive” to get to your current drive letter. Otherwise, you will find yourself hunting for the drive letter in “/cygdrive/{drive_letter}/”.

...




jh
