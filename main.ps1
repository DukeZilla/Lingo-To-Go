# Quick definitions on the fly

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
write-host "Version 0.1.5 Pre-Alpha"
write-host "~ DukeZilla 2022"
echo " "
write-host "Source: Wordnik.com"
"`n"		
echo " "

$uc00 = read-host "LTG>"
echo " "

if ( $uc00 -like "help" ) {
	dictionary
}
# - - - - - - - - - - - - - - - - - - - - - -
# BEGINNING
function dictionary {
$word = read-host "Define"
#-#-#
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
echo $word >> "$word.txt"
echo " " >> "$word.txt"
# - - - - - - - - - - - - - - - - - - - - - -
# WEB PROCESS
$ErrorActionPreference = 'silentlycontinue'
if ( $word -contains ' ' ) {
	$word = $word.replace(" ", "%20")
}
#$web00 = invoke-webrequest -uri 
#$web00.Content >> temp05.txt
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
$v03.readline()
# - - - - - - - - - - - - - - - - - - - - - -
# SPELLING CHECK
$v03.readline() | foreach-object {$_ -match "<p?(.*)</p>"} | Out-Null
$check = $matches[1] -split ">(.*)Check" | select-object -index 1
# - # - #
if ($check -like "Sorry, no definitions found.") {
	write-host "Sorry, no definitions found."
	$v01.Close()
	$v01.Dispose()
	$v03.Close()
	$v03.Dispose()
	"`n"
	remove-item temp00.txt
	remove-item temp01.txt
	remove-item temp02.txt
	Clear-Variable -name "matches"
	pause
	"`n"
	echo --------------------------------------------------------------------------------O
	"`n"
	dictionary
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
for ($i=0; $i -le 7; $i++) {
	remove-item temp0$i.txt
	if ($i -eq 7) {
		break
	}
}
echo --------------------------------------------------------------------------------O
"`n"
dictionary }

# Initiator

dictionary