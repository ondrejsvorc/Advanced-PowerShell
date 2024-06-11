[string[]] $headers = @("Jmeno", "Prijmeni", "Vek")

$students = Import-Csv -Path "E:\studentsNoHeaders.csv" -Header $headers | Select-Object -Unique $headers

$students | % {
    Write-Host $_.Jmeno 
    Write-Host $_.Prijmeni
    Write-Host $_.Vek
}
