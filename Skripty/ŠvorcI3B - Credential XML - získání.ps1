# Ziskani Credentials objektu a zasifrovani objektu do XML souboru
$credential = Get-Credential
$credential | Export-CliXml -Path 'E:\credentials.xml'