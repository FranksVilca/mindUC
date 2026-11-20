Add-Type -AssemblyName System.Drawing

$srcPath = Resolve-Path "assets/icons/app_logo.png"
$src = [System.Drawing.Image]::FromFile($srcPath)

# Create a square master bitmap to preserve aspect ratio without stretching
$maxDim = [Math]::Max($src.Width, $src.Height)
$squareMaster = New-Object System.Drawing.Bitmap($maxDim, $maxDim, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
$gMaster = [System.Drawing.Graphics]::FromImage($squareMaster)
$gMaster.Clear([System.Drawing.Color]::Transparent)
$gMaster.CompositingQuality = [System.Drawing.Drawing2D.CompositingQuality]::HighQuality
$gMaster.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
$gMaster.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
$gMaster.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality

$offsetX = [int](($maxDim - $src.Width) / 2)
$offsetY = [int](($maxDim - $src.Height) / 2)
$gMaster.DrawImage($src, $offsetX, $offsetY, $src.Width, $src.Height)
$gMaster.Dispose()

function Get-ResizedPngBytes([System.Drawing.Bitmap]$source, [int]$size) {
    $bmp = New-Object System.Drawing.Bitmap($size, $size, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.Clear([System.Drawing.Color]::Transparent)
    $g.CompositingQuality = [System.Drawing.Drawing2D.CompositingQuality]::HighQuality
    $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
    $g.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
    $g.DrawImage($source, 0, 0, $size, $size)
    $g.Dispose()

    $ms = New-Object System.IO.MemoryStream
    $bmp.Save($ms, [System.Drawing.Imaging.ImageFormat]::Png)
    $bytes = $ms.ToArray()
    $ms.Dispose()
    $bmp.Dispose()
    return ,$bytes
}

function Save-ResizedPng([System.Drawing.Bitmap]$source, [int]$size, [string]$destPath) {
    $dir = [System.IO.Path]::GetDirectoryName($destPath)
    if (-not [System.IO.Directory]::Exists($dir)) {
        [System.IO.Directory]::CreateDirectory($dir) | Out-Null
    }
    $bytes = Get-ResizedPngBytes -source $source -size $size
    [System.IO.File]::WriteAllBytes($destPath, $bytes)
    Write-Output "Saved: $destPath ($size x $size)"
}

# 1. Generate Windows .ico with multi-resolutions (256, 128, 64, 48, 32, 16)
$icoSizes = @(256, 128, 64, 48, 32, 16)
$icoFrames = @()
foreach ($sz in $icoSizes) {
    $pngBytes = Get-ResizedPngBytes -source $squareMaster -size $sz
    $icoFrames += [PSCustomObject]@{
        Size = $sz
        Bytes = $pngBytes
    }
}

$icoPath = "windows/runner/resources/app_icon.ico"
$icoStream = New-Object System.IO.MemoryStream
$writer = New-Object System.IO.BinaryWriter($icoStream)

# ICONDIR header: idReserved (0), idType (1 for ICO), idCount
$writer.Write([uint16]0)
$writer.Write([uint16]1)
$writer.Write([uint16]$icoFrames.Count)

$offset = 6 + (16 * $icoFrames.Count)

# Write ICONDIRENTRY for each frame
foreach ($frame in $icoFrames) {
    $w = if ($frame.Size -ge 256) { 0 } else { $frame.Size }
    $h = if ($frame.Size -ge 256) { 0 } else { $frame.Size }
    $writer.Write([byte]$w)
    $writer.Write([byte]$h)
    $writer.Write([byte]0) # ColorCount (0 if >=8bpp)
    $writer.Write([byte]0) # Reserved
    $writer.Write([uint16]1) # Planes
    $writer.Write([uint16]32) # BitCount
    $writer.Write([uint32]$frame.Bytes.Length) # BytesInRes
    $writer.Write([uint32]$offset) # ImageOffset
    $offset += $frame.Bytes.Length
}

# Write frame image data
foreach ($frame in $icoFrames) {
    $writer.Write($frame.Bytes)
}

$writer.Flush()
[System.IO.File]::WriteAllBytes($icoPath, $icoStream.ToArray())
$writer.Dispose()
$icoStream.Dispose()
Write-Output "Successfully updated Windows ICO: $icoPath"

# 2. Generate Android mipmap launcher icons
Save-ResizedPng -source $squareMaster -size 48 -destPath "android/app/src/main/res/mipmap-mdpi/ic_launcher.png"
Save-ResizedPng -source $squareMaster -size 72 -destPath "android/app/src/main/res/mipmap-hdpi/ic_launcher.png"
Save-ResizedPng -source $squareMaster -size 96 -destPath "android/app/src/main/res/mipmap-xhdpi/ic_launcher.png"
Save-ResizedPng -source $squareMaster -size 144 -destPath "android/app/src/main/res/mipmap-xxhdpi/ic_launcher.png"
Save-ResizedPng -source $squareMaster -size 192 -destPath "android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png"

# 3. Generate Web icons
Save-ResizedPng -source $squareMaster -size 32 -destPath "web/favicon.png"
Save-ResizedPng -source $squareMaster -size 192 -destPath "web/icons/Icon-192.png"
Save-ResizedPng -source $squareMaster -size 512 -destPath "web/icons/Icon-512.png"
Save-ResizedPng -source $squareMaster -size 192 -destPath "web/icons/Icon-maskable-192.png"
Save-ResizedPng -source $squareMaster -size 512 -destPath "web/icons/Icon-maskable-512.png"

$src.Dispose()
$squareMaster.Dispose()
Write-Output "All icons generated successfully!"
