[CmdletBinding()]
Param(
    [Parameter(Mandatory=$true)]
    [ValidateSet('PowerOn', 'PowerOff', 'Connect', 'Disconnect')]
    [string]$status
)

$macPrimary = "0005A60C9391" #10.113.91.108
$deviceId = "e27bcdc0-ec0f-4a7a-8c35-7acf97455b7f" #emulated canon projecter
$sequenceNo = 0
$sequence = ""
$gveSvrIp = "172.18.11.27"
#$devices = Get-Content devices.txt
$udpPort = 5555
$isFur = '1'


function SendAbstractCommandStatus ($abstractcommand)
{
    $sequenceNo++
    $sequence = $sequenceNo.ToString("000")
    $udpPacket = "[" + "$deviceId" + "$abstractcommand" + "]"
    
    Write-Host "SETR$macPrimary$sequence$isFur$udpPacket\03"
    ..\Tools\PacketSender\PacketSender.com -a -w 0 -b 42000 -u $gveServerIp $udpPort "SETR$macPrimary$sequence$isFur$udpPacket\03"
}

switch ($status)
{
    'PowerOn' {
        $abstractcommand = "~17=1"
    }
    'PowerOff' {
        $abstractcommand = "~17=0"
    }
    'Connect' {
        $abstractcommand = "~19=1"
    }
    'Disconnect' {
        $abstractcommand = "~19=0"
    }
    Default {}
}

SendAbstractCommandStatus ($abstractcommand)