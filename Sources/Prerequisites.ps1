#========================================================================
#
# Tool Name	: SCCM Model_Procure Check
# Author 	: Damien VAN ROBAEYS
# Date 		: 12/02/2018
#
#========================================================================

[System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms')  				| out-null
[System.Reflection.Assembly]::LoadWithPartialName('System.ComponentModel') 				| out-null
[System.Reflection.Assembly]::LoadWithPartialName('System.Data')           				| out-null
[System.Reflection.Assembly]::LoadWithPartialName('System.Drawing')        				| out-null
[System.Reflection.Assembly]::LoadWithPartialName('presentationframework') 				| out-null
[System.Reflection.Assembly]::LoadWithPartialName('PresentationCore')      				| out-null
[System.Reflection.Assembly]::LoadFrom('assembly\MahApps.Metro.dll')       				| out-null
[System.Reflection.Assembly]::LoadFrom('assembly\System.Windows.Interactivity.dll') 	| out-null




function LoadXml ($global:filename)
{
    $XamlLoader=(New-Object System.Xml.XmlDocument)
    $XamlLoader.Load($filename)
    return $XamlLoader
}

# Load MainWindow
$XamlMainWindow=LoadXml("Prerequisites.xaml")
$Reader=(New-Object System.Xml.XmlNodeReader $XamlMainWindow)
$Form=[Windows.Markup.XamlReader]::Load($Reader)


$Refresh = $Form.findname("Refresh") 
$Refreshddd = $Form.findname("Refreshddd") 

$Border_Status = $Form.findname("Border_Status") 

$Model_Supported_border = $Form.findname("Model_Supported_border") 
$Model_Supported_btn = $Form.findname("Model_Supported_btn") 
$Model_Supported_Icon_Color = $Form.findname("Model_Supported_Icon_Color") 
$Model_Supported_Status = $Form.findname("Model_Supported_Status") 

$Line_Model_Disk = $Form.findname("Line_Model_Disk") 

$DiskSize_border = $Form.findname("DiskSize_border") 
$DiskSize_btn = $Form.findname("DiskSize_btn") 
$DiskSize_Icon_Color = $Form.findname("DiskSize_Icon_Color") 
$DiskSize_Status = $Form.findname("DiskSize_Status") 

$Line_Disk_RAM = $Form.findname("Line_Disk_RAM") 

$RAM_border = $Form.findname("RAM_border") 
$RAM_btn = $Form.findname("RAM_btn") 
$RAM_Icon_Color = $Form.findname("RAM_Icon_Color") 
$RAM_Status = $Form.findname("RAM_Status") 

$Line_RAM_Battery = $Form.findname("Line_RAM_Battery")  

$Battery_border = $Form.findname("Battery_border") 
$Battery_btn = $Form.findname("Battery_btn") 
$Battery_Icon_Color = $Form.findname("Battery_Icon_Color") 
$Battery_Status = $Form.findname("Battery_Status") 

$Line_Battery_SecureBoot = $Form.findname("Line_Battery_SecureBoot")  

$SecureBoot_border = $Form.findname("SecureBoot_border") 
$SecureBoot_btn = $Form.findname("SecureBoot_btn") 
$SecureBoot_Icon_Color = $Form.findname("SecureBoot_Icon_Color") 
$SecureBoot_Status = $Form.findname("SecureBoot_Status") 

$Model_Supported_Status.Fontweight = "bold"	
$DiskSize_Status.Fontweight = "bold"		

$Minimum_Disk = "20"
$Minimum_RAM = "4"

# $timer = New-Object System.Windows.Forms.Timer
# $timer.Interval = 2000 



$timer_model = New-Object System.Windows.Forms.Timer
$timer_model.Interval = 1000		
$timer_model.add_tick({Check_Model})

$timer_disksize = New-Object System.Windows.Forms.Timer
$timer_disksize.Interval = 2000		
$timer_disksize.add_tick({Check_DiskSize})

$timer_RAM = New-Object System.Windows.Forms.Timer
$timer_RAM.Interval = 3000		
$timer_RAM.add_tick({Check_RAM})

$timer_Battery = New-Object System.Windows.Forms.Timer
$timer_Battery.Interval = 4000		
$timer_Battery.add_tick({Check_Battery})

$timer_SecureBoot = New-Object System.Windows.Forms.Timer
$timer_SecureBoot.Interval = 5000		
$timer_SecureBoot.add_tick({Check_SecureBoot})

$timer_CheckColor = New-Object System.Windows.Forms.Timer
$timer_CheckColor.Interval = 6000		
$timer_CheckColor.add_tick({Final_Color})


$Current_Folder = split-path $MyInvocation.MyCommand.Path


Function First_Colors
	{
		$Model_Supported_Status.Content = "Checking supported model"
		$Model_Supported_Status.Foreground = "#E6E6E6"		
		$Model_Supported_btn.BorderBrush = "#E6E6E6"
		$Model_Supported_btn.Background = "White"		
		$Model_Supported_Icon_Color.Fill = "#E6E6E6"			
		$Model_Supported_border.BorderBrush = "#E6E6E6"			
		$Model_Supported_border.Background = "Transparent"	

		$DiskSize_Status.Content = "Checking free disk space"
		$DiskSize_Status.Foreground = "#E6E6E6"	
		$DiskSize_btn.BorderBrush = "#E6E6E6"
		$DiskSize_btn.Background = "white"
		$DiskSize_Icon_Color.Fill = "#E6E6E6"	
		$DiskSize_border.BorderBrush = "#E6E6E6"			
		$DiskSize_border.Background = "Transparent"	

		$RAM_Status.Content = "Checking RAM"
		$RAM_Status.Foreground = "#E6E6E6"
		$RAM_Status.Fontweight = "Bold"	
		$RAM_btn.BorderBrush = "#E6E6E6"	
		$RAM_btn.Background = "White"		
		$RAM_Icon_Color.Fill = "#E6E6E6"
		$RAM_border.BorderBrush = "#E6E6E6"			
		$RAM_border.Background = "Transparent"	
		
		$Battery_Status.Content = "Checking battery status"					
		$Battery_Status.Foreground = "#E6E6E6"
		$Battery_Status.Fontweight = "Bold"	   							
		$Battery_btn.BorderBrush = "#E6E6E6"
		$Battery_btn.Background = "white"					
		$Battery_Icon_Color.Fill = "#E6E6E6"
		$Battery_border.BorderBrush = "#E6E6E6"			
		$Battery_border.Background = "Transparent"	

		$SecureBoot_Status.Content = "Checking secure boot status"			
		$SecureBoot_Status.Foreground = "#E6E6E6"
		$SecureBoot_Status.Fontweight = "Bold"	   							
		$SecureBoot_btn.BorderBrush = "#E6E6E6"	
		$SecureBoot_btn.Background = "White"				
		$SecureBoot_Icon_Color.Fill = "#E6E6E6"		
		$SecureBoot_border.BorderBrush = "#E6E6E6"			
		$SecureBoot_border.Background = "Transparent"	

		$Line_Model_Disk.Stroke = "#E6E6E6"						
		$Line_Disk_RAM.Stroke = "#E6E6E6"						
		$Line_RAM_Battery.Stroke = "#E6E6E6"						
		$Line_Battery_SecureBoot.Stroke = "#E6E6E6"					
		$Border_Status.BorderBrush = "#E6E6E6"						
	}

	
Function Check_Model
	{
		$Win32_ComputerSystem = Get-WmiObject Win32_ComputerSystem 	
		$My_Model = $Win32_ComputerSystem.Model	
		$List_Supported_Models = "$Current_Folder\Supported_Models.xml"						
		$Input_Supported_Models = [xml] (Get-Content $List_Supported_Models)
		$Supported_Models = $Input_Supported_Models.Models.Model 
		$Global:Supported = $false		
		ForEach ($Model in $Supported_Models) 
			{
				$Model_Name = $Model.Name	
				If ($My_Model -eq $Model_Name)
					{
						$Supported = $true
						break					
					}
			}

		If($Supported -eq $true)
			{ 
				$Global:Model_Procure = "OK"
				$Model_Supported_Status.Content = "Your computer is supported"
				$Model_Supported_Status.Foreground = "white"		
				$Model_Supported_btn.BorderBrush = "#00A86B"
				$Model_Supported_btn.Background = "White"				
				$Model_Supported_Icon_Color.Fill = "#00A86B"					
				$Model_Supported_border.Background = "#00A86B"	
			}
			
		If($Supported -eq $false)
			{
				$Global:Model_Procure = "KO"				
				$Model_Supported_Status.Content = "Your computer is not supported"
				$Model_Supported_Status.Foreground = "White"		
				$Model_Supported_btn.BorderBrush = "White"
				$Model_Supported_btn.Background = "White"				
				$Model_Supported_Icon_Color.Fill = "#EA4335"	
				$Model_Supported_border.Background = "#EA4335"	
			}
		
			
		$timer_model.stop()			
	}


Function Check_DiskSize
	{
		$Win32_LogicalDisk = Get-WmiObject Win32_LogicalDisk | where {($_.DriveType -eq "3") -and ($_.DeviceID -eq "C:")}	
		ForEach ($disk in $Win32_LogicalDisk) 
			{
						$Total_size = [Math]::Round(($disk.size/1GB),1)
						$Free_size = [Math]::Round(($disk.Freespace/1GB),1) 
						$Disk_information =  $Disk_information + "(" + $disk.deviceid + ") " + $Total_size + " GB Total / " +  + $Free_size + " GB Free `n"
			}	

		If ($Free_size -gt $Minimum_Disk)
			{
				$Global:DiskSize = "OK"		
				$DiskSize_Status.Content = "There is enough disk space"
				$DiskSize_Status.Foreground = "White"	
				$DiskSize_Icon_Color.Fill = "#00A86B"		

				$DiskSize_btn.Background = "White"
				
				$DiskSize_border.Background = "#00A86B"	
				
			}	

		If ($Free_size -lt $Minimum_Disk)
			{
				$Global:DiskSize = "KO"					
				$DiskSize_Status.Content = "Not enough disk space - 20Gb minimum"
				$DiskSize_Status.Foreground = "white"	
				$DiskSize_btn.BorderBrush = "#EA4335"
				$DiskSize_Icon_Color.Fill = "#EA4335"	
				$DiskSize_btn.Background = "White"				
				$DiskSize_border.Background = "#EA4335"	
			}	

		$timer_disksize.stop()
		
		If (($Model_Procure -eq "OK") -and ($DiskSize -eq "OK"))
			{
				$Line_Model_Disk.Stroke = "#00A86B"						
			}			
		Else
			{
				$Line_Model_Disk.Stroke = "#EA4335"					
			}				
			
	}	
	
	
Function Check_RAM
	{	
		$Win32_ComputerSystem = Get-WmiObject Win32_ComputerSystem 	
		$Memory_RAM = [Math]::Round(($Win32_ComputerSystem.TotalPhysicalMemory/ 1GB),1) 		
		If ($Memory_RAM -gt $Minimum_RAM)
			{
				$Global:RAM = "OK"		
				$RAM_Status.Content = "There is enough RAM"
				$RAM_Status.Foreground = "White"
				$RAM_Status.Fontweight = "Bold"	
				$RAM_btn.BorderBrush = "#00A86B"	

				$RAM_btn.Background = "White"		
				
				$RAM_Icon_Color.Fill = "#00A86B"

				$RAM_border.Background = "#00A86B"	
			}	

		If ($Memory_RAM -lt $Minimum_RAM)
			{
				$Global:RAM = "KO"	
				$RAM_Status.Content = "Not enough RAM - 4Gb minimum"				
				$RAM_Status.Foreground = "#EA4335"
				$RAM_Status.Fontweight = "Bold"	   
				$RAM_btn.BorderBrush = "#EA4335"	
				$RAM_Icon_Color.Fill = "#EA4335"					
			}
			
		$timer_RAM.stop()	

		If (($DiskSize -eq "OK") -and ($RAM -eq "OK"))
			{
				$Line_Disk_RAM.Stroke = "#00A86B"						
			}			
		Else
			{
				$Line_Disk_RAM.Stroke = "#EA4335"					
			}			
	}	

Function Check_Battery
	{
		$Win32_Battery = Get-WmiObject Win32_Battery 	
		$isLaptop = $false
		$Global:Battery = "OK"				
		$Computer_chassis = (gwmi win32_systemenclosure).chassistypes
		If ($Computer_chassis -eq 9 -or $Computer_chassis -eq 10)
			{
				$isLaptop = $true	
			}
		Else
			{
				$isLaptop = $false						
				$Global:Battery = "OK"		
				$Battery_Status.Content = "Running on desktop"					
				$Battery_Status.Foreground = "White"
				$Battery_Status.Fontweight = "Bold"	   							
				$Battery_btn.BorderBrush = "#00A86B"			
				$Battery_Icon_Color.Fill = "#00A86B"	

				$Battery_btn.Background = "White"		
				$Battery_border.Background = "#00A86B"	
				$Battery_border.Foreground = "White"				
			}
		 
		If ($isLaptop -eq $true)
			{	
				$Batt_Status = $Win32_Battery.BatteryStatus	
				If ($Batt_Status -eq 2)
					{
						$Global:Battery = "OK"		
						$Battery_Status.Content = "Plugged-in"					
						$Battery_Status.Foreground = "White"
						$Battery_Status.Fontweight = "Bold"	   							
						$Battery_btn.BorderBrush = "#00A86B"			
						$Battery_Icon_Color.Fill = "#00A86B"	
						
						$Battery_btn.Background = "White"		
						$Battery_border.Background = "#00A86B"	
						$Battery_border.Foreground = "White"							
					}
				Else
					{
						$Global:Battery = "KO"		
						$Battery_Status.Content = "Not plugged-in"					
						$Battery_Status.Foreground = "White"
						$Battery_Status.Fontweight = "Bold"	   							
						$Battery_btn.BorderBrush = "#EA4335"			
						$Battery_Icon_Color.Fill = "#EA4335"	

						$Battery_btn.Background = "White"		
						$Battery_border.Background = "#EA4335"	
					}					
			}
			
		$timer_Battery.stop()			
		
		If (($RAM -eq "OK") -and ($Battery -eq "OK"))
			{
				$Line_RAM_Battery.Stroke = "#00A86B"						
			}			
		Else
			{
				$Line_RAM_Battery.Stroke = "#EA4335"					
			}				
			
	}	
	
Function Check_SecureBoot
	{	
		$REG_SG_Secure_Boot = get-itemproperty -path registry::"HKLM\SYSTEM\CurrentControlSet\Control\SecureBoot\State"	
		$Test_SecureBoot_Reg = test-path "HKLM:\SYSTEM\CurrentControlSet\Control\SecureBoot\State\" -erroraction 'Silentlycontinue'
		If ($Test_SecureBoot_Reg)
			{
				$Secure_Boot_State = $REG_SG_Secure_Boot.UEFISecureBootEnabled			
				If ($Secure_Boot_State -eq "0")
					{
						$Global:Secure_Boot = "KO"
						$SecureBoot_Status.Foreground = "#EA4335"
						$SecureBoot_Status.Fontweight = "Bold"	   							
						$SecureBoot_Status.Content = "Secure boot isn't enabled"	
						$SecureBoot_btn.BorderBrush = "#EA4335"			
						$SecureBoot_Icon_Color.Fill = "#EA4335"	
					}
				Else
					{
						$Global:Secure_Boot = "OK"					
						$SecureBoot_Status.Foreground = "White"
						$SecureBoot_Status.Fontweight = "Bold"	   							
						$SecureBoot_Status.Content = "Secure boot is enabled"	
						$SecureBoot_btn.BorderBrush = "#00A86B"			
						$SecureBoot_Icon_Color.Fill = "#00A86B"	
						
						$SecureBoot_btn.Background = "White"		
						$SecureBoot_border.Background = "#00A86B"	
					}	
			}
		Else
			{
				$Global:Secure_Boot = "KO"			
				$SecureBoot_Status.Foreground = "#EA4335"
				$SecureBoot_Status.Fontweight = "Bold"	   							
				$SecureBoot_Status.Content = "Secure boot isn't enabled"	
				$SecureBoot_btn.BorderBrush = "#EA4335"			
				$SecureBoot_Icon_Color.Fill = "#EA4335"	
			}	
			
		$timer_SecureBoot.stop()			
		
		If (($Battery -eq "OK") -and ($Secure_Boot -eq "OK"))
			{
				$Line_Battery_SecureBoot.Stroke = "#00A86B"						
			}			
		Else
			{
				$Line_Battery_SecureBoot.Stroke = "#EA4335"					
			}			
			
	}	

	
	
Function Final_Color
	{			
		If (($Model_Procure -eq "OK") -and ($DiskSize -eq "OK") -and ($RAM -eq "OK") -and ($Battery -eq "OK") -and ($Secure_Boot -eq "OK"))
			{
				$Border_Status.BorderBrush = "CornFlowerBlue"			
			}
		Else
			{
				$Border_Status.BorderBrush = "#EA4335"			
			
			}
			
	$timer_CheckColor.stop()
			
	}		
	
	
	

Function Set_Color
	{	
		If (($Model_Procure -eq "OK") -and ($DiskSize -eq "OK"))
			{
				$Line_Model_Disk.Stroke = "#00A86B"						
			}			
		Else
			{
				$Line_Model_Disk.Stroke = "#EA4335"					
			}		
	
	
	
		If (($DiskSize -eq "OK") -and ($RAM -eq "OK"))
			{
				$Line_Disk_RAM.Stroke = "#00A86B"						
			}			
		Else
			{
				$Line_Disk_RAM.Stroke = "#EA4335"					
			}		
	
	
		If (($RAM -eq "OK") -and ($Battery -eq "OK"))
			{
				$Line_RAM_Battery.Stroke = "#00A86B"						
			}			
		Else
			{
				$Line_RAM_Battery.Stroke = "#EA4335"					
			}		
	

		If (($Battery -eq "OK") -and ($Secure_Boot -eq "OK"))
			{
				$Line_Battery_SecureBoot.Stroke = "#00A86B"						
			}			
		Else
			{
				$Line_Battery_SecureBoot.Stroke = "#EA4335"					
			}	
	
	
	
		If (($Model_Procure -eq "OK") -and ($DiskSize -eq "OK") -and ($RAM -eq "OK") -and ($Battery -eq "OK") -and ($Secure_Boot -eq "OK"))
			{
				$Border_Status.BorderBrush = "CornFlowerBlue"			
			}
		Else
			{
				$Border_Status.BorderBrush = "#EA4335"			
			
			}
			
	$timer_CheckColor.stop()
			
	}	
	
	

$Refresh.Add_Click({
	First_Colors
	$timer_model.start()
	$timer_disksize.start()	
	$timer_RAM.start()
	$timer_Battery.start()
	$timer_SecureBoot.start()	
	$timer_CheckColor.start()
})	


$Refreshddd.Add_Click({
	First_Colors
	$timer_model.start()
	$timer_disksize.start()	
	$timer_RAM.start()
	$timer_Battery.start()
	$timer_SecureBoot.start()	
	$timer_CheckColor.start()
})	



First_Colors
$timer_model.start()
$timer_disksize.start()
$timer_RAM.start()
$timer_Battery.start()
$timer_SecureBoot.start()	
$timer_CheckColor.start()



$Form.ShowDialog() | Out-Null

