cd ..
$p = (pwd).path
$source = "https://github.com/DukeZilla/Lingo-To-Go/archive/refs/heads/main.zip"
$destination = "$env:USERPROFILE\Downloads\Lingo-To-Go.zip"
Invoke-WebRequest $source -OutFile $destination
cd \
cd $env:USERPROFILE\Downloads
Expand-Archive -LiteralPath "$env:USERPROFILE\Downloads\Lingo-To-Go.zip" -DestinationPath "$p\Lingo To Go"
echo Done.
echo " "
start-sleep 3
exit