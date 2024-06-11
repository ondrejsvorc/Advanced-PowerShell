$students = Import-Csv -Path "E:\students.csv"

$students | % {
    Write-Host $_.Jmeno 
    Write-Host $_.Prijmeni
    Write-Host $_.Vek
}