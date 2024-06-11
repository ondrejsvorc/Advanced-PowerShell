# Maximalni pocet procesu (=maximalni pocet vyuzivanych jader)
$maxJobsCount = 4;

# Ziska pocet vsech bezicich procesu, ktere bezi
# Pokud je pocet nizsi nez maximalni pocet procesu, povoli spusteni dalsiho
while ((Get-Job -State 'Running').Count -lt $maxConcurrentJobs) {
	
}