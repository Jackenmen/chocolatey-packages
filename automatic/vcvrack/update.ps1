﻿$ErrorActionPreference = 'Stop'
import-module au

#[Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12

function global:au_BeforeUpdate { Get-RemoteFiles -NoSuffix -Purge }

function global:au_GetLatest {    
    $releases = 'https://vcvrack.com/downloads'    
    $regex    = 'RackFree-(?<Version>[\d\.]+)-win-x64.exe'

    $download_page = Invoke-WebRequest -Uri $releases -UseBasicParsing	
	$url = $download_page.links | ? href -match $regex | Select -Last 1

    return @{ Version = $matches.Version ; URL64 = 'https://vcvrack.com' + $url.href }
}

function global:au_SearchReplace {       
    @{
       "legal\VERIFICATION.txt"  = @{            
            "(?i)(x64: ).*"             = "`${1}$($Latest.URL64)"
            "(?i)(checksum type:\s+).*" = "`${1}$($Latest.ChecksumType64)"            
            "(?i)(checksum64:).*"       = "`${1} $($Latest.Checksum64)"
        }

        "tools\chocolateyinstall.ps1" = @{        
          #"(?i)(^\s*file64\s*=\s*`"[$]toolsDir\\)(.*)`"" = "`${1}$($Latest.FileName64)`""
          "(?i)(^\s*file64\s*=\s*`"[$]toolsDir\\)(.*)`"" = "`${1}$(($Latest.URL64).Substring($($Latest.URL64).LastIndexOf("/") + 1))`""
        }
    }
}

update -ChecksumFor None -NoCheckUrl