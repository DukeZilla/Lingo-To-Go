cd ..
$p = (pwd).path
$source = "https://github.com/DukeZilla/Lingo-To-Go/archive/refs/heads/main.zip"
$destination = "$env:USERPROFILE\Downloads\Lingo-To-Go.zip"
Invoke-WebRequest $source -OutFile $destination
cd \
cd $env:USERPROFILE\Downloads
Expand-Archive -LiteralPath "$env:USERPROFILE\Downloads\Lingo-To-Go.zip" -DestinationPath "$p"
cd $p 
cd Lingo-To-Go-Main
copy "main.ps1" "$p\Lingo To Go"
copy "updater.ps1" "$p\Lingo To Go"
copy "help.txt" "$p\Lingo To Go"
copy "Lingo-To-Go.bat" "$p\Lingo To Go"
copy "readme.txt" "$p\Lingo To Go"
cd ..
rmdir Lingo-To-Go-Main
echo Done.
echo " "
start-sleep 3
exit