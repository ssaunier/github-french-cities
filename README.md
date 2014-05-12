I ran this little study to answer the question:

## Where do developers work in France?

You can jump straight to the [results](data/github_users_per_hubs.csv).

### Methodology

1. I used `french_hubs.rb` to gather City Hubs (*Intercommunalités*) and population. It was a semi-auto chore as Wikipedia pages are not consistent between hubs. Results are in [french_hubs.yml](data/french_hubs.yml)
1. I then perform searches on Github API to count users for each city in every hub. Look at the `github_users_per_city.rb` script and the results in [github_users_per_city.yml](data/github_users_per_city.yml)
1. Finally I ran a map/reduce on both yaml files and compute the ratio "github user count per 1000 inhabitants"

### Top 10

1. [Paris](http://fr.wikipedia.org/wiki/Paris)
1. [Nantes Métropole](http://fr.wikipedia.org/wiki/Nantes_M%C3%A9tropole)
1. [Grenoble Alpes Métropole](http://fr.wikipedia.org/wiki/Communaut%C3%A9_d%27agglom%C3%A9ration_Grenoble_Alpes_M%C3%A9tropole)
1. [Toulouse Métropole](http://fr.wikipedia.org/wiki/Communaut%C3%A9_urbaine_de_Toulouse_M%C3%A9tropole)
1. [Montpellier Agglomération](http://fr.wikipedia.org/wiki/Montpellier_Agglom%C3%A9ration)
1. [Rennes Métropole](http://fr.wikipedia.org/wiki/Rennes_M%C3%A9tropole)
1. [Grand Lyon](http://fr.wikipedia.org/wiki/Grand_Lyon)
1. [Bordeaux Métropole](http://fr.wikipedia.org/wiki/Communaut%C3%A9_urbaine_de_Bordeaux)
1. [Strasbourg (Communauté urbaine)](http://fr.wikipedia.org/wiki/Communaut%C3%A9_urbaine_de_Strasbourg)

Article to be written.