# Image de base avec R et Shiny
FROM rocker/shiny:latest

# Installer les packages nécessaires
RUN R -e "install.packages(c('shiny', 'shinythemes', 'randomForest', 'dplyr'), repos='https://cloud.r-project.org')"

# Copier uniquement l'application
COPY app.R /srv/shiny-server/app.R

# Donner les bons droits
RUN chown -R shiny:shiny /srv/shiny-server

# Exposer le port Shiny
EXPOSE 3838

# Lancer le serveur
CMD ["/usr/bin/shiny-server"]