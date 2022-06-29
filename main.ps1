# Quick definitions on the fly

$ErrorActionPreference = 'silentlycontinue'
$p00 = (pwd).path

function banner_func {
	
echo --------------------------------------------------------------------------------O
"`n"
write-host '
██╗     ██╗███╗   ██╗ ██████╗  ██████╗     ████████╗ ██████╗      ██████╗  ██████╗ 
██║     ██║████╗  ██║██╔════╝ ██╔═══██╗    ╚══██╔══╝██╔═══██╗    ██╔════╝ ██╔═══██╗
██║     ██║██╔██╗ ██║██║  ███╗██║   ██║       ██║   ██║   ██║    ██║  ███╗██║   ██║
██║     ██║██║╚██╗██║██║   ██║██║   ██║       ██║   ██║   ██║    ██║   ██║██║   ██║
███████╗██║██║ ╚████║╚██████╔╝╚██████╔╝       ██║   ╚██████╔╝    ╚██████╔╝╚██████╔╝
╚══════╝╚═╝╚═╝  ╚═══╝ ╚═════╝  ╚═════╝        ╚═╝    ╚═════╝      ╚═════╝  ╚═════╝ 
                                                                                   ' -foregroundcolor Red
echo " "
write-host "Vocab words for takeout!" -foregroundcolor Yellow
echo " "
write-host "Version 0.4.23 Pre-Alpha"
write-host "~ DukeZilla 2022"
echo " "
echo --------------------------------O
echo " "
# -internet check-
ping google.com -n 1 | Out-Null
if ( $lastexitcode -eq "1" ) {
	write-host "Internet Status: Not Connected" -foregroundcolor Red
} else {
	write-host "Internet Status: Connected" -foregroundcolor Green
}
# -recently defined / info-
cd \
cd "$env:USERPROFILE"
cd desktop
cd words
$rcntA = ls | sort LastWriteTime -descending | select name
$rcntB = $rcntA -split ".txt" | select -index 0,2,4
$rcntC = $rcntB -split "=" | select -index 1,3,5
$rcntD = [string]::join(", ", $rcntC)
cd $p00
write-host "Recently defined words: $rcntD"
write-host "Sources: www.wordnik.com, www.thesaurus.com, www.duckduckgo.com"
write-host "Type ""help"" for information on usage of Lingo To Go."
echo " "	
echo --------------------------------O
echo " "	
}

function main_func {
	
cd $p00
echo " "
$uc00 = read-host "LTG>"
echo " "
	if ( $uc00 -like "help" ) {
	type help.txt
	main_func
	}
	if ( $uc00 -like "dictionary" ) {
	echo 'dictionary_func' > start.txt
	dictionary_func
	main_func
	}
	if ( $uc00 -like "wordbank") {
	echo 'wordbank_func' > start.txt
	wordbank_func
	main_func
	}
	if ( $uc00 -like "study" ) {
	echo 'study_func' > start.txt
	echo "Coming soon"
	main_func
	}
	if ( $uc00 -like "lang" ) {
	echo "Coming soon"
	main_func
	}
	if ( $uc00 -like "thesaurus" ) {
	echo 'thesaurus_func' > start.txt
	echo "Coming soon"
	main_func
	}
	if ( $uc00 -like "update" ) {
	set-executionpolicy bypass
	pwsh.exe updater.ps1
	echo 'Set shell = CreateObject("wscript.shell")' > "refresh.vbs"
	echo 'wscript.sleep 2000' >> "refresh.vbs"
	echo 'shell.run "taskkill /im pwsh.exe -f", 0' >> "refresh.vbs"
	echo 'shell.run "taskkill /im cmd.exe -f", 0' >> "refresh.vbs"
	echo 'wscript.sleep 1000' >> "refresh.vbs"
	echo 'shell.run "Lingo-To-Go.bat"' >> "refresh.vbs"
	start refresh.vbs
	start-sleep 1
	del refresh.vbs
	exit
	}
	if ( $uc00 -like "banner" ) {
	banner_func
	main_func
	}
	if ( $uc00 -like "clear" ) {
	clear
	main_func
	}
	if ( $uc00 -like "exit" ) {
	kill -name cmd
	exit
	}
write-host """$uc00"" is not a recognized command. Type ""help"" for more information."
main_func
}

# - - - - - - - - - - - - - - - - - - - - - -
# BEGINNING
function dictionary_func {
	
$word = read-host "Define"
if ($word -like "main") {
	cd $p00
	echo 'main_func' > start.txt
	main_func
}
# CHECKS
cd \
cd "$env:USERPROFILE"
cd desktop
if ( -not (Test-Path Words) ) {
	mkdir Words | Out-Null
	echo " "
	pwd
	write-host "A Word bank was added to your desktop."
}
cd Words
#-#-#
if (Test-Path "$word.txt") {
	echo " "
	type "$word.txt"
	echo " "
	echo --------------------------------------------------------------------------------O
	echo " "
	dictionary_func
}
ping google.com -n 1 | Out-Null
if ( $lastexitcode -eq "1" ) { 
	echo " "
	echo --------------------------------O
	echo " "
	write-host "Unable to search word."
	write-host "Internet Status: Not Connected" -foregroundcolor Red
	write-host "Connect to the internet and retry."
	echo " "
	echo --------------------------------O
	echo " "
	dictionary_func
}
echo $word >> "$word.txt"
echo " " >> "$word.txt"
# - - - - - - - - - - - - - - - - - - - - - -
# WEB PROCESS
echo " "
write-host "---------------------------O" -foregroundcolor Green
write-host "  Source: www.wordnik.com  " -foregroundcolor Green
write-host "---------------------------O" -foregroundcolor Green
if ( $word -contains ' ' ) {
	$word = $word.replace(" ", "+")
}
$web00 = invoke-webrequest -uri "https://duckduckgo.com/?q=spelling+$word&t=brave&ia=answer"
if ( $word -contains '+' ) {
	$word = $word.replace(" ", "%20")
}
$web00.Content >> temp08.txt
$web01 = invoke-webrequest -uri https://wordnik.com/words/$word
$web01.Content >> temp00.txt
$web02 = invoke-webrequest -uri https://thesaurus.com/browse/$word
$web02.Content >> temp03.txt
# - # - #
# ISOLATING DESIRED INFORMATION
$v00 = Select-String -Path temp00.txt -Pattern " <i></i>" >> temp01.txt
$v00 = Select-String -Path temp00.txt -Pattern "<p?(.*)/p>" >> temp02.txt
$v00 = Select-String -Path temp03.txt -Pattern '{"similarity"' >> temp04.txt
# - # - #
# DECLARING VARIABLES CONTAINING FILES
$path = (pwd).path
$file00 = "$path\temp01.txt"
$v01 = [System.IO.StreamReader]::new($file00)
$file01 = "$path\temp02.txt"
$v03 = [System.IO.StreamReader]::new($file01)
$file02 = "$path\temp04.txt"
$v04 = [System.IO.StreamReader]::new($file02)
$file03 = "$path\temp08.txt"
$v10 = [System.IO.StreamReader]::new($file03)
$v03.readline()
# - - - - - - - - - - - - - - - - - - - - - -
# SPELLING CHECK
$v03.readline() | foreach-object {$_ -match "<p?(.*)</p>"} | Out-Null
$check01 = $matches[1] -split ">(.*)Check" | select-object -index 1
$v10.readline() | foreach-object {$_ -match "does not appear to be spelled correctly."} | Out-Null
$check00 = $matches[0]
# - # - #
if ($check00 -like "*does not appear to be spelled correctly.*") {
	echo ------------------------------O
	echo " "
	write-host "Sorry, no definitions found."
	echo " "
	$v01.Close()
	$v01.Dispose()
	$v03.Close()
	$v03.Dispose()
	$v04.Close()
	$v04.Dispose()
	$v10.Close()
	$v10.Dispose()
	remove-item temp00.txt
	remove-item temp01.txt
	remove-item temp02.txt
	remove-item temp03.txt
	remove-item temp04.txt
	remove-item temp08.txt
	remove-item "$word.txt"
	Clear-Variable -name "matches"
	$v07 = $web00.links | select-object "href"
	$v08 = $v07 -split "[+}]" | select-object -index 7, 10, 13, 16, 19, 22, 25, 28
	$v09 = [string]::join(", ",$v08)
	$spell = $v09 -replace "%20", " "
	echo " "
	write-host "$word does not appear to be spelled correctly."
	echo " "
	write-host "Suggestions: $spell"
	echo " "
	echo ------------------------------O
	echo " "
	dictionary_func
}
if ($check01 -like "*Sorry, no definitions found.*") {
	echo ------------------------------O
	echo " "
	write-host "Sorry, no definitions found."
	echo " "
	$v01.Close()
	$v01.Dispose()
	$v03.Close()
	$v03.Dispose()
	$v04.Close()
	$v04.Dispose()
	$v10.Close()
	$v10.Dispose()
	remove-item temp00.txt
	remove-item temp01.txt
	remove-item temp02.txt
	remove-item temp03.txt
	remove-item temp04.txt
	remove-item temp08.txt
	remove-item "$word.txt"
	Clear-Variable -name "matches"
	echo " "
	write-host "Try using another source."
	echo " "
	echo ------------------------------O
	echo " "
	dictionary_func
}
# - - - - - - - - - - - - - - - - - - - - - -
# WORD TOPIC OUTPUT
$v02 = [IO.File]::ReadAllText("$path\temp01.txt")
$word_type = $v02 -split '[<>]' | select -index 4
$word_type >> "$word.txt"
echo " " >> "$word.txt"
$v01.readline()
# - # - #
# DEFINITION OUTPUT
for ($i=0; $i -le 12; $i++) {
	$v01.readline() | foreach-object {$_ -match "</i>?(.*)</li>"} | Out-Null
	$matches[1] -replace "<(.*)>" >> "$word.txt"
	Clear-Variable -name "matches"
	if ($i -eq 12) {
		break
	}
}
# - - - - - - - - - - - - - - - - - - - - - -
# SYNONYMS OUTPUT
$v04.readline()
$v04.readline() -split '"term"' | select-object -index 1, 2, 3, 4, 5, 6, 7 >> temp06.txt
$file03 = "$path\temp06.txt"
$v05 = [System.IO.StreamReader]::new($file03)
for ($i=0; $i -le 7; $i++) {
	$v05.readline() -split '"' | select-object -index 1 >> temp07.txt
	if ($i -eq 7) {
		break
	}
}
echo " " >> "$word.txt"
echo "Synonyms:" >> "$word.txt"
$v06 = get-content temp07.txt
echo " " >> "$word.txt"
[string]::join(", ",$v06) >> "$word.txt"
# - - - - - - - - - - - - - - - - - - - - - 
# FINAL OUTPUT
type "$word.txt"
echo " "
# - - - - - - - - - - - - - - - - - - - - - 
# CLEANUP 
$v01.Close()
$v01.Dispose()
$v03.Close()
$v03.Dispose()
$v04.Close()
$v04.Dispose()
$v05.Close()
$v05.Dispose()
$v10.Close()
$v10.Dispose()
for ($i=0; $i -le 8; $i++) {
	remove-item temp0$i.txt
	if ($i -eq 8) {
		break
	}
}
echo --------------------------------------------------------------------------------O
"`n"
dictionary_func }
# - - - - - - - - - - - - - - - - - - - - - 
function wordbank_func {
	
cd \
cd "$env:USERPROFILE"
cd desktop
cd Words
echo " "
$wb = read-host "Word Bank"
if ($wb -like "list") {
	ls | select-object "LastWriteTime", "Name"
	wordbank_func
}
if ($wb -like "open") {
	cd ..
	start Words
}
if ($wb -like "main") {
	echo 'main_func' > start.txt
	main_func
}
wordbank_func
}
# - - - - - - - - - - - - - - - - - - - - - 
function study_func {
	
$stud = read-host "Study"	
}
# - - - - - - - - - - - - - - - - - - - - - 
# Initiator
banner_func
Get-Content start.txt | Foreach-Object{
	$func_start = $_.Split('=')
	New-Variable -Name $func_start[0] -Value $func_start[1]
}
& $func_start
main_func