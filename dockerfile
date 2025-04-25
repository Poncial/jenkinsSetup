# On part de l'image officielle Jenkins avec support LTS (Long Term Support)
FROM jenkins/jenkins:latest

# On passe temporairement à l'utilisateur root pour pouvoir installer des logiciels
USER root

# Installer R (4.5.)
RUN apt-get update && \
# On installe les outils nécessaires pour ajouter des dépôts sécurisés (HTTPS, GPG, etc.)
    apt-get install -y dirmngr gnupg wget ca-certificates libcurl4-openssl-dev libssl-dev libxml2-dev libpq-dev git apt-transport-https ca-certificates software-properties-common && \
# On ajoute la clé publique utilisée pour vérifier l’authenticité des paquets CRAN
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 'E298A3A825C0D65DFD57CBB651716619E084DAB9' && \
# On ajoute le dépôt officiel CRAN pour Debian 12 (bookworm) à la liste des sources APT
    add-apt-repository 'deb https://cloud.r-project.org/bin/linux/debian bookworm-cran40/' && \
# On met à jour la liste des paquets en incluant le nouveau dépôt CRAN
    apt-get update && \
# On installe le paquet principal de R (inclut R et Rscript)
    apt-get install -y r-base

# Installer renv
RUN R -e "install.packages('renv', repos = 'https://cloud.r-project.org')"
RUN Rscript -e "renv::consent(provided = TRUE)"

# On repasse à l'utilisateur jenkins pour exécuter Jenkins en conditions normales (sécurité)
USER jenkins

EXPOSE 8080
