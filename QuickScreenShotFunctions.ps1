Add-Type -AssemblyName System.Drawing

function SS-To-Bmp($Left,$Top,$Width,$Height){
    $bitmap = new-object -TypeName System.Drawing.Bitmap -ArgumentList ([Int]$Width), ([Int]$Height)
    $graphics = [System.Drawing.Graphics]::FromImage($bitmap)
    $graphics.CopyFromScreen($Left, $Top, 0, 0, $bitmap.Size)
    return $bitmap
}

function SS-SettingsSave($Name = "Default"){
    $settings = loadSettings -Name $Name

    $bmp = SS-To-Bmp $settings.Left $settings.Top $settings.Width $settings.Height

    if(Test-Path "$($settings.Path)/$($settings.Folder)" -PathType Leaf){
        return
    }elseif(-not (Test-Path "$($settings.Path)/$($settings.Folder)" -PathType Container)){
        mkdir "$($settings.Path)/$($settings.Folder)" |Out-Null
    }

    if(-not (Test-Path "$($settings.Path)/$($settings.Folder)/$($settings.Name).png")){
        $bmp.save("$($settings.Path)/$($settings.Folder)/$($settings.Name).png") | out-null
        "$($settings.Path)/$($settings.Folder)/$($settings.Name).png ‚É•Û‘¶‚µ‚Ü‚µ‚½" |oh
        return
    }

    $i = 1
    while($true){
        if(-not (Test-Path "$($settings.Path)/$($settings.Folder)/$($settings.Name)_$($i).png")){
            $bmp.save("$($settings.Path)/$($settings.Folder)/$($settings.Name)_$($i).png") | out-null
            "$($settings.Path)/$($settings.Folder)/$($settings.Name)_$($i).png ‚É•Û‘¶‚µ‚Ü‚µ‚½" |oh
            return
        }
        $i++
    }
}

function loadSettings($Name = "Default"){
    ConvertFrom-Json (Get-Content "$($PSScriptRoot)/settings/$($Name).json" -Raw)
}

function saveSettings($obj,$Name = "Default"){
    ConvertTo-Json $obj > "$($PSScriptRoot)/settings/$($Name).json"
}
