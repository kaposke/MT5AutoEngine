#gets the File To Compile as an external parameter... Defaults to a Test file...
Param( $FileToCompile = "C:\Users\guilh\AppData\Roaming\MetaQuotes\Terminal\D0E8209F77C8CF37AD8BF550E51FF075\MQL5\Experts\Test.mq5")

#cleans the terminal screen and sets the log file name...
Clear-Host
$LogFile = $FileToCompile + ".log"

#before continue check if the Compile File has any spaces in it...
if ($FileToCompile.Contains(" ")) {
    ""; "";
    Write-Host "ERROR!  Impossible to Compile! Your Filename or Path contains SPACES!" -ForegroundColor Red;
    "";
    Write-Host $FileToCompile -ForegroundColor Red;
    ""; "";
    return;
}

#first of all, kill MT Terminal (if running)... otherwise it will not see the new compiled version of the code...
# Get-Process -Name terminal64 -ErrorAction SilentlyContinue | Where-Object { $_.Id -gt 0 } | Stop-Process

#fires up the Metaeditor compiler...
& "C:\Program Files\MetaTrader 5\metaeditor64.exe" /compile:"$FileToCompile" /log:"$LogFile" /inc:"C:\Users\guilh\AppData\Roaming\MetaQuotes\Terminal\D0E8209F77C8CF37AD8BF550E51FF075\MQL5" | Out-Null

#get some clean real state and tells the user what is being compiled (just the file name, no path)...
""; ""; ""; ""; ""
$JustTheFileName = Split-Path $FileToCompile -Leaf
Write-Host "Compiling...: $JustTheFileName"
""

#reads the log file. Eliminates the blank lines. Skip the first line because it is useless.
$Log = Get-Content -Path $LogFile | Where-Object { $_ -ne "" } | Select-Object -Skip 1

#Green color for successful Compilation. Otherwise (error/warning), Red!
$WhichColor = "Red"
# $Log | ForEach-Object { if ($_.Contains("0 error(s)")) { $WhichColor = "Green" } }
if ($log[$log.Count - 1].StartsWith("Result: 0")) { $WhichColor = "Green" }

#runs through all the log lines...
$Log | ForEach-Object {
    #ignores the ": information: error generating code" line when ME was successful
    if (-Not $_.Contains("information:") -and -Not $_.Contains(": warning")) {
        #common log line... just print it...
        $color = "red"
        if ($_.StartsWith("Result")) { 
            $color = $WhichColor 
        }
        Write-Host $_ -ForegroundColor $color
    }
}

#get the MT Terminal back if all went well...
# if ( $WhichColor -eq "Green") { & "C:\Program Files\MetaTrader 5\terminal64.exe" }