$StartIP = "10.0.0.1"
$EndIP = "10.0.0.50"

# Function to convert an IP address to its decimal representation
function ConvertToDecimalIP([string]$ipAddress) {
    $ipBytes = $ipAddress.Split('.')
    $decimalIP = 0
    for ($i = 0; $i -lt 4; $i++) {
        $decimalIP += [int]$ipBytes[$i] * [math]::Pow(256, 3 - $i)
    }
    return $decimalIP
}

# Convert the start and end IP addresses to decimal representation
$StartIPDecimal = ConvertToDecimalIP $StartIP
$EndIPDecimal = ConvertToDecimalIP $EndIP

# Loop through the IP range and check if each IP is occupied
for ($i = $StartIPDecimal; $i -le $EndIPDecimal; $i++) {
    $currentIP = ""
    for ($j = 3; $j -ge 0; $j--) {
        $currentIP += ($i -shr ($j * 8)) -band 255
        if ($j -gt 0) {
            $currentIP += "."
        }
    }

    # Check if the current IP is occupied
    $result = Test-Connection -ComputerName $currentIP -Count 1 -Quiet
    if ($result) {
        Write-Host "IP address $currentIP is occupied."
    } else {
        Write-Host "IP address $currentIP is available."
    }
}
