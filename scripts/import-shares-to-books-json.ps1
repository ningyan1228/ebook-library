param(
  [Parameter(Mandatory = $true)]
  [string[]]$InputCsv,

  [string]$OutputJson = "books.json"
)

$ErrorActionPreference = "Stop"

function U {
  return -join ($args | ForEach-Object { [char]$_ })
}

function Get-BookFormat {
  param([string]$Name)

  $match = [regex]::Match($Name, '\.([A-Za-z0-9]{2,5})(?:\s*)$')
  if ($match.Success) {
    return $match.Groups[1].Value.ToUpperInvariant()
  }

  return U 26410 30693
}

function Get-CleanTitle {
  param([string]$Name)

  $title = ($Name -replace '\.([A-Za-z0-9]{2,5})(?:\s*)$', '').Trim()
  $title = ($title -replace '\s*\((?:Z-Library|z-library|zlib|1lib|z-lib|z-library\.sk|1lib\.sk|z-lib\.sk)[^)]+\)\s*$', '').Trim()
  return $title
}

function Get-CloudProvider {
  param(
    [string]$Text,
    [string]$Url
  )

  if ($Url -match 'pan\.quark\.cn') { return U 22840 20811 32593 30424 }
  if ($Url -match 'pan\.baidu\.com') { return U 30334 24230 32593 30424 }
  if ($Url -match 'aliyundrive|alipan') { return U 38463 37324 20113 30424 }
  if ($Url -match 'xunlei') { return U 36805 38647 32593 30424 }
  return U 32593 30424
}

function Get-ShareUrl {
  param([string]$Text)

  $match = [regex]::Match($Text, 'https?://[^\s，。",]+')
  if ($match.Success) {
    return $match.Value.Trim()
  }

  return ""
}

function Get-PropertyValueByIndex {
  param(
    [object]$Row,
    [int]$Index
  )

  $props = @($Row.PSObject.Properties)
  if ($props.Count -le $Index) {
    return ""
  }

  return [string]$props[$Index].Value
}

$books = New-Object System.Collections.Generic.List[object]
$seen = @{}
$csvPaths = @($InputCsv | ForEach-Object { [string]$_ -split ',' } | ForEach-Object { $_.Trim() } | Where-Object { $_ })

foreach ($csvPath in $csvPaths) {
  $content = [System.IO.File]::ReadAllText($csvPath, [System.Text.Encoding]::UTF8)
  $rows = $content | ConvertFrom-Csv

  foreach ($row in $rows) {
    $rawName = Get-PropertyValueByIndex $row 1
    $shareText = Get-PropertyValueByIndex $row 2
    $code = Get-PropertyValueByIndex $row 3
    $shareTime = Get-PropertyValueByIndex $row 4
    $url = Get-ShareUrl $shareText

    if ([string]::IsNullOrWhiteSpace($rawName) -or [string]::IsNullOrWhiteSpace($url)) {
      continue
    }

    $dedupeKey = "$rawName|$url"
    if ($seen.ContainsKey($dedupeKey)) {
      continue
    }
    $seen[$dedupeKey] = $true

    $index = $books.Count + 1
    $format = Get-BookFormat $rawName
    $title = Get-CleanTitle $rawName
    $provider = Get-CloudProvider $shareText $url

    $books.Add([ordered]@{
      id = "book-{0:D4}" -f $index
      title = $title
      authors = @()
      publisher = ""
      year = ""
      category = U 26410 20998 31867
      tags = @($format, $provider)
      format = $format
      language = U 20013 25991
      description = $rawName
      cloudProvider = $provider
      url = $url
      extractionCode = $code
      size = ""
      accessNote = ""
      sharedAt = $shareTime
    })
  }
}

$result = [ordered]@{
  updatedAt = (Get-Date -Format "yyyy-MM-dd")
  sourceFiles = $csvPaths | ForEach-Object { Split-Path -Leaf $_ }
  books = $books
}

$json = $result | ConvertTo-Json -Depth 8
$utf8NoBom = New-Object System.Text.UTF8Encoding($false)
[System.IO.File]::WriteAllText((Resolve-Path -LiteralPath $OutputJson), $json, $utf8NoBom)

Write-Output ("Imported {0} books into {1}" -f $books.Count, (Resolve-Path -LiteralPath $OutputJson))
