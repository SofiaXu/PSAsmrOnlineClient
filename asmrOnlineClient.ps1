[CmdletBinding(DefaultParameterSetName = "InputFile")]
param (
    [Parameter(Mandatory = $true, ParameterSetName = "Search")]
    [switch]
    $Search,
    [Parameter(Mandatory = $true, ParameterSetName = "Login")]
    [switch]
    $Login,
    [Parameter(Mandatory = $true, ParameterSetName = "Search")]
    [ValidateNotNullOrEmpty()]
    [string]
    $KeyWord,
    [Parameter(ParameterSetName = "InputFile")]
    [ValidateNotNullOrEmpty()]
    [string]
    $InputFilePath = "input.json",
    [Parameter(Mandatory = $true, ParameterSetName = "Login")][ValidateNotNullOrEmpty()][string]$Username,
    [Parameter(Mandatory = $true, ParameterSetName = "Login")][ValidateNotNullOrEmpty()][securestring]$Password,
    [Parameter(ParameterSetName = "Search")][Parameter(ParameterSetName = "InputFile")][ValidateSet("Lossless", "Lossy", "All")][string]$LosslessMode,
    [string]$ConfigFilePath = "config.json"
)
function Invoke-AsmrOnlineAuthenticate {
    param (
        [Parameter(Mandatory = $true)][ValidateNotNullOrEmpty()][string]$Username,
        [Parameter(Mandatory = $true)][ValidateNotNullOrEmpty()][securestring]$Password
    )
    try {
        $result = (Invoke-WebRequest -UseBasicParsing -Uri "https://api.asmr.one/api/auth/me" `
                -Headers @{
                "method"             = "POST"
                "authority"          = "api.asmr.one"
                "scheme"             = "https"
                "accept"             = "application/json, text/plain, */*"
                "dnt"                = "1"
                "sec-ch-ua-mobile"   = "?0"
                "sec-ch-ua-platform" = "`"Windows`""
                "origin"             = "https://www.asmr.one"
                "sec-fetch-site"     = "same-site"
                "sec-fetch-mode"     = "cors"
                "sec-fetch-dest"     = "empty"
                "referer"            = "https://www.asmr.one/"
                "accept-language"    = "zh-CN,zh;q=0.9,en;q=0.8,en-GB;q=0.7,en-US;q=0.6"
            } -Method Post -Body (@{password = (ConvertFrom-SecureString $Password -AsPlainText); name = $Username }) -ErrorVariable errorResult).Content | ConvertFrom-Json
    }
    catch {
        try {
            return $errorResult.Message | ConvertFrom-Json
        }
        catch {
            return @{
                error = $errorResult.Message
            }
        }
    }
    return $result;
}
function Get-Works {
    param (
        [Parameter(Mandatory = $true)][ValidateNotNullOrEmpty()][string]$Token,
        [uint]$Page = 0,
        [ValidateSet('id', 'release', 'rating', 'dl_count', 'review_count', 'price', 'rate_average_2dp', 'nsfw', 'create_date')][string]$Order = 'release',
        [ValidateSet('asc', 'desc')][string]$Sort = 'desc'
    )
    $result = (Invoke-WebRequest -UseBasicParsing -Uri "https://api.asmr.one/api/works?order=$Order&sort=$Sort&page=$Page&seed=8&subtitle=0" `
            -Headers @{
            "method"             = "GET"
            "authority"          = "api.asmr.one"
            "scheme"             = "https"
            "accept"             = "application/json, text/plain, */*"
            "dnt"                = "1"
            "authorization"      = "Bearer $Token"
            "sec-ch-ua-mobile"   = "?0"
            "sec-ch-ua-platform" = "`"Windows`""
            "origin"             = "https://www.asmr.one"
            "sec-fetch-site"     = "same-site"
            "sec-fetch-mode"     = "cors"
            "sec-fetch-dest"     = "empty"
            "referer"            = "https://www.asmr.one/"
            "accept-language"    = "zh-CN,zh;q=0.9,en;q=0.8,en-GB;q=0.7,en-US;q=0.6"
        }).Content | ConvertFrom-Json
    return $result;
}
function Find-Works {
    param (
        [Parameter(Mandatory = $true)][ValidateNotNullOrEmpty()][string]$Token,
        [Parameter(Mandatory = $true)][ValidateNotNullOrEmpty()][string]$KeyWord,
        [uint]$Page = 1,
        [ValidateSet('id', 'release', 'rating', 'dl_count', 'review_count', 'price', 'rate_average_2dp', 'nsfw', 'create_date')][string]$Order = 'release',
        [ValidateSet('asc', 'desc')][string]$Sort = 'desc'
    )
    if ($Page -lt 1) {
        $Page = 1
    }
    $result = (Invoke-WebRequest -UseBasicParsing -Uri "https://api.asmr.one/api/search/$($KeyWord)?order=$Order&sort=$Sort&page=$Page&subtitle=0&seed=80" `
            -Headers @{
            "method"             = "GET"
            "authority"          = "api.asmr.one"
            "scheme"             = "https"
            "accept"             = "application/json, text/plain, */*"
            "dnt"                = "1"
            "authorization"      = "Bearer $Token"
            "sec-ch-ua-mobile"   = "?0"
            "sec-ch-ua-platform" = "`"Windows`""
            "origin"             = "https://www.asmr.one"
            "sec-fetch-site"     = "same-site"
            "sec-fetch-mode"     = "cors"
            "sec-fetch-dest"     = "empty"
            "referer"            = "https://www.asmr.one/"
            "accept-language"    = "zh-CN,zh;q=0.9,en;q=0.8,en-GB;q=0.7,en-US;q=0.6"
        }).Content | ConvertFrom-Json
    return $result;
}
function Get-Tracks {
    param (
        [Parameter(Mandatory = $true)][string]$Token,
        [Parameter(Mandatory = $true)][string]$RJNumber
    )
    (Invoke-WebRequest -UseBasicParsing -Uri "https://api.asmr.one/api/tracks/$($RJNumber.Replace('RJ', ''))" `
        -Headers @{
        "method"             = "GET"
        "authority"          = "api.asmr.one"
        "scheme"             = "https"
        "accept"             = "application/json, text/plain, */*"
        "dnt"                = "1"
        "authorization"      = "Bearer $Token"
        "sec-ch-ua-mobile"   = "?0"
        "sec-ch-ua-platform" = "`"Windows`""
        "origin"             = "https://www.asmr.one"
        "sec-fetch-site"     = "same-site"
        "sec-fetch-mode"     = "cors"
        "sec-fetch-dest"     = "empty"
        "referer"            = "https://www.asmr.one/"
        "accept-language"    = "zh-CN,zh;q=0.9,en;q=0.8,en-GB;q=0.7,en-US;q=0.6"
    }).Content | ConvertFrom-Json
}
function Get-Work {
    param (
        [Parameter(Mandatory = $true)][string]$Token,
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)][string]$RJNumber
    )
    (Invoke-WebRequest -UseBasicParsing -Uri "https://api.asmr.one/api/work/$($RJNumber.Replace('RJ', ''))" `
        -Headers @{
        "method"             = "GET"
        "authority"          = "api.asmr.one"
        "scheme"             = "https"
        "accept"             = "application/json, text/plain, */*"
        "dnt"                = "1"
        "authorization"      = "Bearer $Token"
        "sec-ch-ua-mobile"   = "?0"
        "sec-ch-ua-platform" = "`"Windows`""
        "origin"             = "https://www.asmr.one"
        "sec-fetch-site"     = "same-site"
        "sec-fetch-mode"     = "cors"
        "sec-fetch-dest"     = "empty"
        "referer"            = "https://www.asmr.one/"
        "accept-language"    = "zh-CN,zh;q=0.9,en;q=0.8,en-GB;q=0.7,en-US;q=0.6"
    }).Content | ConvertFrom-Json
}
function Out-Tracks {
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)][object[]]$Tracks,
        [string]$OutDirectory,
        [string]$Token,
        [ValidateSet("Lossless", "Lossy", "All")][string]$LosslessMode = "All"
    )
    if ($Tracks.Count -eq 0) {
        return;
    }
    if ([string]::IsNullOrWhiteSpace($OutDirectory)) {
        $OutDirectory = Join-Path "." -ChildPath "" -Resolve;
    }
    $dictionary = Get-TrackList -Tracks $Tracks -OutDirectory $OutDirectory -LosslessMode $LosslessMode
    $job = Start-BitsTransfer $dictionary[0].Item1 $dictionary[0].Item2 -CustomHeaders "authorization: Bearer $Token" -Asynchronous
    $retryTimes = 0;
    for ($i = 1; $i -lt $dictionary.Count; $i++) {
        [void](Add-BitsFile -BitsJob $job -Source $dictionary[$i].Item1 -Destination $dictionary[$i].Item2)
    }
    while (($job.JobState -eq "Transferring") -or ($job.JobState -eq "Connecting") -or ($job.JobState -eq "TransientError")) {
        if ($job.JobState -eq "TransientError") {
            $retryTimes++;
            Write-Warning "Retrying ... Times: $retryTimes"
            [void]($job | Resume-BitsTransfer -Asynchronous)
        }
        Get-BitsTransferProgress $job.JobId
    } # Poll for status, sleep for 5 seconds, or perform an action.

    Switch ($job.JobState) {
        "Transferred" { Complete-BitsTransfer -BitsJob $job }
        "Error" { $job | Format-List } # List the errors.
        "TransientError" { $job | Format-List }
        default { "Other action" } #  Perform corrective action.
    }
}
function Get-TrackList {
    [OutputType([System.Collections.Generic.List[System.Tuple[string, string]]])]
    param (
        [object[]]$Tracks,
        [string]$OutDirectory,
        [ValidateSet("Lossless", "Lossy", "All")][string]$LosslessMode = "All"
    )
    $dictionary = [System.Collections.Generic.List[System.Tuple[string, string]]]::new()
    $Tracks | ForEach-Object {
        if ($_.type -eq "folder") {
            $out = (Join-Path -Path $OutDirectory -ChildPath $_.title.Replace("\", "_").Replace("/", "_")).ToString();
            $list = (Get-TrackList -Tracks $_.children -OutDirectory $out -Token $t -LosslessMode $LosslessMode)
            if (($null -ne $list) -and ($list.Count -gt 0)) {
                try {
                    $dictionary.AddRange([System.Collections.Generic.List[System.Tuple[string, string]]]$list)
                }
                catch {
                    $dictionary.AddRange([System.Tuple[string, string][]]$list)
                }
            }
            return;
        }
        $title = $_.title.Replace("\", "_").Replace("/", "_");
        $url = $_.mediaDownloadUrl
        $outFile = (Join-Path -Path $OutDirectory -ChildPath $title).ToString()
        if ($_.type -eq "audio") {
            switch ($LosslessMode) {
                "Lossless" {
                    if ([Regex]::IsMatch($title, "\.(wav|flac)$")) {
                        $dictionary.Add([System.Tuple[string, string]]::new($url, $outFile));
                    }
                }
                "Lossy" {
                    if (-not [Regex]::IsMatch($title, "\.(wav|flac)$")) {
                        $dictionary.Add([System.Tuple[string, string]]::new($url, $outFile));
                    }
                }
                Default {
                    $dictionary.Add([System.Tuple[string, string]]::new($url, $outFile));
                }
            }
        }
        else {
            $dictionary.Add([System.Tuple[string, string]]::new($url, $outFile));
        }
    }
    if ($dictionary.Count -gt 0) {
        if (-not (Test-Path $OutDirectory)) {
            [void](mkdir $OutDirectory)
        }
        Write-Output -NoEnumerate $dictionary;
    }
}
function Get-BitsTransferProgress {
    param (
        [guid]$jobID
    )
    
    #Dynamically choose whether to return one or all based on if a Job ID was provided
    function DynamicBitsStatus {
        If ($jobID) {
            return (Get-BitsTransfer -JobId $jobID | Where-Object { ($job.JobState -eq "Transferring") -or ($job.JobState -eq "Connecting") })
        }
        Else {
            return (Get-BitsTransfer | Where-Object { ($job.JobState -eq "Transferring") -or ($job.JobState -eq "Connecting") })
        }
    }
    
    #Borrowed from https://theposhwolf.com/howtos/Format-Bytes/
    Function Format-Bytes {
        Param
        (
            [Parameter(
                ValueFromPipeline = $true
            )]
            [ValidateNotNullOrEmpty()]
            [float]$number
        )
        Begin {
            $sizes = 'KB', 'MB', 'GB', 'TB', 'PB'
        }
        Process {
            # New for loop
            for ($x = 0; $x -lt $sizes.count; $x++) {
                if ($number -lt [int64]"1$($sizes[$x])") {
                    if ($x -eq 0) {
                        return "$number B"
                    }
                    else {
                        $num = $number / [int64]"1$($sizes[$x-1])"
                        $num = "{0:N2}" -f $num
                        return "$num $($sizes[$x-1])"
                    }
                }
            }
        }
        End {}
    }
    while (DynamicBitsStatus) {     
        $totalbytes = 0;
        $bytestransferred = 0;
        $timeTaken = 0;
        if ((DynamicBitsStatus | Where-Object { $_.JobState -eq "Connecting" }).Count -gt 0) {
            Write-Progress -Status "Connecting" -Activity "Dowloading files" -PercentComplete 0
            continue;
        }
        foreach ($job in (DynamicBitsStatus | Where-Object { $_.JobState -eq "Transferring" } | Sort-Object CreationTime)) {         
            $totalbytes += $job.BytesTotal;         
            $bytestransferred += $job.bytestransferred     
            if ($timeTaken -eq 0) {
                $timeTaken = ((Get-Date) - $job.CreationTime).TotalSeconds
            }
        }    
        #TimeRemaining = (TotalFileSize - BytesDownloaded) * TimeElapsed/BytesDownloaded
        if ($totalbytes -gt 0) {
            $timeLeft = ($totalBytes - $bytestransferred) * ($timeTaken / $bytestransferred)
            $pctComplete = $(($bytestransferred * 100) / $totalbytes);
            $timeUnit = "second(s)"
            If ($timeLeft -gt 60) {
                $timeLeft = ($timeLeft / 60)
                $timeUnit = "minute(s)"
            }
            If (($timeUnit -eq "minute(s)") -and ($timeLeft -gt 60)) {
                $timeLeft = ($timeLeft / 60)
                $timeUnit = "hour(s)"
            }
            If (($timeUnit -eq "hour(s)") -and ($timeLeft -gt 24)) {
                $timeLeft = ($timeLeft / 24)
                $timeUnit = "day(s)"
            }
            $formattedBytesTransferred = (Format-Bytes($bytestransferred))
            $formattedBytesTotal = (Format-Bytes($totalbytes))
            $formattedPctComplete = ("{0:p}" -f ($pctComplete / 100))
            $roundedTimeRemaining = [math]::Round($timeLeft, 2)
            Write-Progress -Status "Transferring $formattedBytesTransferred of $formattedBytesTotal ($formattedPctComplete). $roundedTimeRemaining $timeUnit remaining." -Activity "Dowloading files" -PercentComplete $pctComplete  
        }
    } 
}
function Format-OutputPath {
    param (
        [object]$Work,
        [string]$OutputPattern
    )
    return $OutputPattern.Replace("<id>", $work.id).Replace("<title>", $Work.title.Replace("\", "_").Replace("/", "_")).Replace("<circle>", $Work.name.Replace("\", "_").Replace("/", "_")).Replace("<vas>", [string]::Join("&", $Work.vas.name).Replace("\", "_").Replace("/", "_")).Replace("<tags>", [string]::Join("&", $Work.tags.name).Replace("\", "_").Replace("/", "_"))
}

$configSchema = @"
{
    "`$schema": "http://json-schema.org/draft-07/schema",
    "type": "object",
    "required": [
        "token"
    ],
    "properties": {
        "token": {
            "type": "string",
            "pattern": "(?:\\w|\\+|/|=)+\\.(?:\\w|\\+|/|=)+\\.(?:\\w|\\+|/|=|-|_)+"
        },
        "losslessMode": {
            "type": "string",
            "enum": [
                "All",
                "Lossless",
                "Lossy"
            ]
        },
        "outputPattern": {
            "type": "string"
        }
    },
    "additionalProperties": true
}
"@

if ($Login) {
    if (Test-Path $ConfigFilePath) {
        try {
            $configFile = Get-Content $ConfigFilePath -Raw
            $config = ConvertFrom-Json $configFile
            if (-not (Test-Json $configFile -Schema $configSchema)) {
                $config = @{}
            }
        }
        catch {
            $config = @{}
        }
    }
    $token = Invoke-AsmrOnlineAuthenticate -Username $Username -Password $Password;
    if ([string]::IsNullOrWhiteSpace($token.token)) {
        if ([string]::IsNullOrWhiteSpace($token.error)) {
            Write-Error -Message ([string]::Join(", ", $token.errors.msg));
        }
        else {
            Write-Error -Message $token.error;
        }
        return;
    }
    if ([string]::IsNullOrEmpty($config.token)) {
        if ($null -eq $config) {
            $config = @{}
        }
        $config | Add-Member -Name "token" -Value $token.token -MemberType NoteProperty
    }
    else {
        $config.token = $token.token
    }
    $config | ConvertTo-Json | Out-File $ConfigFilePath;
    Write-Host "Login Succeed."
    return;
}
if (Test-Path $ConfigFilePath) {
    try {
        $configFile = Get-Content $ConfigFilePath -Raw
        $config = ConvertFrom-Json $configFile
        if (-not (Test-Json $configFile -Schema $configSchema)) {
            Write-Error "Read User Token Failed. (JSON File error)";
            return;
        }
    }
    catch {
        Write-Error "Read User Token Failed. (JSON File error)";
        return;
    }
}
else {
    Write-Error "Read User Token Failed. (File Not Found)";
    return;
}
if ([string]::IsNullOrWhiteSpace($config.token)) {
    Write-Error ".";
    return;
}
if ($Search) {
    $list = Find-Works -Token $config.token -KeyWord $KeyWord
    $temp = $list.works | Out-GridView -Title "Select to Download" -OutputMode Multiple;
    if ($temp.Count -eq 0) {
        Write-Error "Nothing Has been Selected.";
        return;
    }
    $list = ($temp).id
}
else {
    if (Test-Path $InputFilePath) {
        try {
            $list = (Get-Content $InputFilePath | ConvertFrom-Json)
        }
        catch {
            Write-Error "Read Input.json Failed.";
            return;
        }
    }
    else {
        Write-Error "Read Input.json Failed.";
        return;
    }
}
if ([string]::IsNullOrWhiteSpace($LosslessMode)) {
    if ([string]::IsNullOrWhiteSpace($config.losslessMode)) {
        $LosslessMode = "All";
        Write-Warning "LosslessMode Not Set! Set to `"All`".";
    }
    else {
        $LosslessMode = $config.losslessMode;
    }
}
if ([string]::IsNullOrWhiteSpace($config.outputPattern)) {
    $outputPattern = "RJ<id>";
}
else {
    $outputPattern = $config.outputPattern
}
try {
    foreach ($item in $list) {
        $work = Get-Work -Token $config.token -RJNumber $item
        $outDirectory = Format-OutputPath -Work $work $outputPattern;
        Write-Host "Start Download: $($work.title) into $($outDirectory)"
        $tracks = Get-Tracks -Token $config.token -RJNumber $item;
        Out-Tracks -Tracks $tracks -OutDirectory $outDirectory -Token $config.token -LosslessMode $LosslessMode
        $work | ConvertTo-Json | Out-File (Join-Path -Path $outDirectory -ChildPath "workInfo.json")
        Write-Host "Finished Download: $($work.title) into $($work.id)"
    }
}
finally {
    Get-BitsTransfer | Remove-BitsTransfer
}
