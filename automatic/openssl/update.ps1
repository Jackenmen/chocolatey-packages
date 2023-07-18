﻿$ErrorActionPreference = 'Stop'
import-module au

[Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12

function global:au_BeforeUpdate { Get-RemoteFiles -NoSuffix -Purge }

function global:au_GetLatest {
    $releases = 'https://slproweb.com/products/Win32OpenSSL.html'
    $regex32  = 'Win32OpenSSL-([\d_]+)([a-z]+)?.exe'
    $regex64  = 'Win64OpenSSL-(?<Version>[\d_]+)(?<VersionLetter>[a-z]+)?.exe'

    $download_page = Invoke-WebRequest -Uri $releases -UseBasicParsing	
	$url32   = $download_page.links | ? href -match $regex32 | Select -First 1
    $url64   = $download_page.links | ? href -match $regex64 | Select -First 1
    $version = $matches.Version -Replace '_','.'

    if ($matches.VersionLetter) {
        $version = $version + '.' + ( [int][char]$matches.VersionLetter.toLower() - 96 ) + '00'
    }

    # When the fourth segment is already used, it is recommended to add two zeroes (00) to the end of the version. Then when you need to fix, you just increment that number.
    #$versionNbSegment = ($version.ToCharArray() | Where-Object {$_ -eq '.'} | Measure-Object).Count
    #if ($versionNbSegment -eq 3) { $version += "00" }

    return @{
        Version = $version
        URL32 = 'https://slproweb.com' + $url32.href
        URL64 = 'https://slproweb.com' + $url64.href
    }
}

function global:au_SearchReplace {
    @{
       "legal\VERIFICATION.txt"  = @{            
            "(?i)(x64: ).*"             = "`${1}$($Latest.URL64)"            
            "(?i)(checksum type:\s+).*" = "`${1}$($Latest.ChecksumType32)"            
            "(?i)(checksum64:).*"       = "`${1} $($Latest.Checksum64)"
        }

        "tools\chocolateyinstall.ps1" = @{
          "(^(\s)*url\s*=\s*)('.*')"        = "`${1}'$($Latest.URL32)'"
          "(^(\s)*checksum\s*=\s*)('.*')"   = "`${1}'$($Latest.Checksum32)'"          
          "(?i)(^\s*file64\s*=\s*`"[$]toolsDir\\)(.*)`"" = "`$1$($Latest.FileName64)`""
        }
    }
}

update -ChecksumFor none