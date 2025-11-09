# Image de base avec R et Shiny
FROM rocker/shiny:latest

# Installer les packages nécessaires
RUN R -e "install.packages(c('shiny', 'shinythemes', 'randomForest', 'dplyr'), repos='https://cloud.r-project.org')"

# Copier l'app et le modèle dans le conteneur
COPY app.R /srv/shiny-server/app.R
#COPY rf_model_test3_local.rds /srv/shiny-server/rf_model_test3_local.rds

# Donner les bons droits
RUN chown -R shiny:shiny /srv/shiny-server

# Exposer le port Shiny
EXPOSE 3838

# Lancer le serveur
CMD ["/usr/bin/shiny-server"]