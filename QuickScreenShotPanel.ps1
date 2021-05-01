Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName System.Windows.Forms

. "$($PSScriptRoot)/QuickScreenShotFunctions.ps1"

function SS-To-Bmp($Left,$Top,$Width,$Height){
    $bitmap = new-object -TypeName System.Drawing.Bitmap -ArgumentList $Width, $Height
    $graphics = [System.Drawing.Graphics]::FromImage($bitmap)
    $graphics.CopyFromScreen($Left, $Top, 0, 0, $bitmap.Size)
    return $bitmap
}

function getPointerLoop(){
    while($true){
        $x = [System.Windows.Forms.Cursor]::Position.X
        $y = [System.Windows.Forms.Cursor]::Position.Y # �}�E�X��Y���W

        if($px -ne $x -or $py -ne $y ){
            echo "$x ,$y"
        }
        $px = $x
        $py = $y
    }
}

function dispForm(){
    $settings = loadSettings

    # �t�H�[���̍쐬
    $form = New-Object System.Windows.Forms.Form 
    $form.Text = "�N�C�b�N��ʃV���b�g �Ǘ��p�l��"
    $form.Size = New-Object System.Drawing.Size(320,350)
    $form.TopLevel = $true
    $form.TopMost = $true
    #$form.AutoSize = $true

    # ��`�͂��Ă�����
    $tpath = $Null
    $tFolder = $Null
    $tName = $Null
    $tX = $Null
    $tY = $Null
    $tWidth = $Null
    $tHeight = $Null

    # �����񂾂���O���[�o��...�Q�Ɠn���̂�͂ǁ[�ł�������
    $global:choise = "Default"

    # �ύX���m�̍ۂɎ��s����鏈��
    $blockChange = {
        if(-not $global:stopEvent){
            $settings.Path = $tpath.Text
            $settings.Folder = $tFolder.Text
            $settings.Name = $tName.Text
            $settings.Left = [Int]($tX.Text)
            $settings.Top = [Int]($tY.Text)
            $settings.Width = [Int]($tWidth.Text)
            $settings.Height = [Int]($tHeight.Text)
            saveSettings $settings $global:choise
        }
    }
    
    # �ݒ�ǂݍ��݂̍ۂɎ��s�����
    $blockLoadSettings = {
        $settings = loadSettings $global:choise

        $tpath.Text = $settings.Path
        $tFolder.Text = $settings.Folder
        $tName.Text = $settings.Name
        $tX.Text = $settings.Left
        $tY.Text = $settings.Top
        $tWidth.Text = $settings.Width
        $tHeight.Text = $settings.Height
    }


    $label = New-Object System.Windows.Forms.Label 
    $label.Location = New-Object System.Drawing.Point(10,30) 
    $label.Size = New-Object System.Drawing.Size(50,30)
    $label.Text = "�e�p�X"
    $form.Controls.Add($label)

    $tpath = New-Object System.Windows.Forms.TextBox 
    $tpath.Location = New-Object System.Drawing.Point(70,30) 
    $tpath.Size = New-Object System.Drawing.Size(225,30)
    $form.Controls.Add($tpath)


    $label = New-Object System.Windows.Forms.Label 
    $label.Location = New-Object System.Drawing.Point(10,60) 
    $label.Size = New-Object System.Drawing.Size(50,25)
    $label.Text = "�t�H���_"
    $form.Controls.Add($label)

    $tFolder = New-Object System.Windows.Forms.TextBox 
    $tFolder.Location = New-Object System.Drawing.Point(70,60) 
    $tFolder.Size = New-Object System.Drawing.Size(225,25)
    $form.Controls.Add($tFolder)


    $label = New-Object System.Windows.Forms.Label 
    $label.Location = New-Object System.Drawing.Point(10,90) 
    $label.Size = New-Object System.Drawing.Size(50,25)
    $label.Text = "���O"
    $form.Controls.Add($label)

    $tName = New-Object System.Windows.Forms.TextBox 
    $tName.Location = New-Object System.Drawing.Point(70,90) 
    $tName.Size = New-Object System.Drawing.Size(225,25)
    $form.Controls.Add($tName)

    
    $label = New-Object System.Windows.Forms.Label 
    $label.Location = New-Object System.Drawing.Point(10,120) 
    $label.Size = New-Object System.Drawing.Size(50,25)
    $label.Text = "�ʒu"
    $form.Controls.Add($label)

    $tX = New-Object System.Windows.Forms.TextBox 
    $tX.Location = New-Object System.Drawing.Point(70,120) 
    $tX.Size = New-Object System.Drawing.Size(50,25)
    $form.Controls.Add($tX)

    $label = New-Object System.Windows.Forms.Label 
    $label.Location = New-Object System.Drawing.Point(120,120) 
    $label.Size = New-Object System.Drawing.Size(25,25)
    $label.TextAlign = "MiddleCenter"
    $label.Text = "x"
    $form.Controls.Add($label)

    $tY = New-Object System.Windows.Forms.TextBox 
    $tY.Location = New-Object System.Drawing.Point(145,120) 
    $tY.Size = New-Object System.Drawing.Size(50,25)
    $form.Controls.Add($tY)

    
    $label = New-Object System.Windows.Forms.Label 
    $label.Location = New-Object System.Drawing.Point(10,150) 
    $label.Size = New-Object System.Drawing.Size(50,25)
    $label.Text = "�T�C�Y"
    $form.Controls.Add($label)

    $tWidth = New-Object System.Windows.Forms.TextBox 
    $tWidth.Location = New-Object System.Drawing.Point(70,150) 
    $tWidth.Size = New-Object System.Drawing.Size(50,25)
    $form.Controls.Add($tWidth)

    $label = New-Object System.Windows.Forms.Label 
    $label.Location = New-Object System.Drawing.Point(120,150) 
    $label.Size = New-Object System.Drawing.Size(25,25)
    $label.TextAlign = "MiddleCenter"
    $label.Text = "x"
    $form.Controls.Add($label)

    $tHeight = New-Object System.Windows.Forms.TextBox 
    $tHeight.Location = New-Object System.Drawing.Point(145,150) 
    $tHeight.Size = New-Object System.Drawing.Size(50,25)
    $form.Controls.Add($tHeight)

    
    $lSettings = New-Object System.Windows.Forms.label 
    $lSettings.Location = New-Object System.Drawing.Point(10,210) 
    $lSettings.Size = New-Object System.Drawing.Size(100,15)
    $lSettings.Text = "�v���Z�b�g"
    $form.Controls.Add($lSettings)

    $cSettings = New-Object System.Windows.Forms.ComboBox
    $cSettings.Location = New-Object System.Drawing.Point(10,232) 
    $cSettings.Size = New-Object System.Drawing.Size(225,25)
    $cSettings.Add_SelectedIndexChanged({
        if(Test-Path -Path "$($PSScriptRoot)/settings/$($cSettings.Text).json" -PathType Leaf){
            $global:choise = $cSettings.Text
            $global:stopEvent = $true
            Invoke-Command -ScriptBlock $blockLoadSettings
            $global:stopEvent = $false

        }
    })
    # �R���{�{�b�N�X�ɃA�C�e����o�^
    ls "$($PSScriptRoot)/settings/" -File | Where-Object {$_.Extension -eq ".json"} | %{
        $cSettings.Items.Add($_.BaseName) | Out-Null
    }
    $cSettings.text = $global:choise
    
    $form.Controls.Add($cSettings)

    $bSettings = New-Object System.Windows.Forms.Button
    $bSettings.Location = New-Object System.Drawing.Point(245,235)
    $bSettings.Size = New-Object System.Drawing.Size(50,25)
    $bSettings.Text = "�쐬"
    $bSettings.Add_Click({
        $global:choise = $cSettings.Text
        Invoke-Command -ScriptBlock $blockChange
        if(-not $cSettings.items.Contains($global:choise)){
            $cSettings.items.Add($global:choise) | Out-Null
            [System.Windows.Forms.MessageBox]::Show("�v���Z�b�g��V�K�쐬���܂����B","�N�C�b�N��ʃV���b�g")
        }else{
            
        }
    })
    $form.Controls.Add($bSettings)

    $bCap = New-Object System.Windows.Forms.Button
    $bCap.Location = New-Object System.Drawing.Point(215,270)
    $bCap.Size = New-Object System.Drawing.Size(80,30)
    $bCap.Text = "�L���v�`��"
    $bCap.Add_Click({
        try{
            SS-SettingsSave -Name $choise
        }catch{
            [System.Windows.Forms.MessageBox]::Show($error[0], "�G���[")
        }
    })
    $form.Controls.Add($bCap)

    # �����l�̐ݒ�
    Invoke-Command -ScriptBlock $blockLoadSettings
    
    # �ύX���m��������
    $tpath.Add_TextChanged($blockChange)
    $tFolder.Add_TextChanged($blockChange)
    $tName.Add_TextChanged($blockChange)
    $tX.Add_TextChanged($blockChange)
    $tY.Add_TextChanged($blockChange)
    $tWidth.Add_TextChanged($blockChange)
    $tHeight.Add_TextChanged($blockChange)

    # �t�H�[����\�������A���̌��ʂ��󂯎��
    $result = $form.ShowDialog()
}

dispForm