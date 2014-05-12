I ran this little study to answer the question:

## Where do developers work in France?

You can jump straight to the [results](data/github_users_per_hubs.csv).

### Methodology

1. I used `french_hubs.rb` to gather City Hubs (*Intercommunalités*) and population. It was a semi-auto chore as Wikipedia pages are not consistent between hubs. Results are in [french_hubs.yml](data/french_hubs.yml)
1. I then perform searches on Github API to count users for each city in every hub. Look at the `github_users_per_city.rb` script and the results in [github_users_per_city.yml](data/github_users_per_city.yml)
1. Finally I ran a map/reduce on both yaml files and compute the ratio "github user count per 1000 inhabitants"

### Top 10

1. Paris
1. Nantes Métropole
1. Grenoble Alpes Métropole
1. Toulouse Métropole
1. Montpellier Agglomération
1. Rennes Métropole
1. Grand Lyon
1. Bordeaux Métropole
1. Strasbourg (Communauté urbaine)

Article to be written.