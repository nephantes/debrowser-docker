FROM r-base:latest

MAINTAINER Alper Kucukural "alper.kucukural@umassmed.edu"

# Install dependencies and Download and install shiny server
RUN apt-get update && apt-get install -y -t unstable \
    sudo \
    gdebi-core \
    pandoc \
    pandoc-citeproc \
    libcurl4-gnutls-dev \
    libcairo2-dev/unstable \
    libxt-dev && \
    wget --no-verbose https://s3.amazonaws.com/rstudio-shiny-server-os-build/ubuntu-12.04/x86_64/VERSION -O "version.txt" && \
    VERSION=$(cat version.txt)  && \
    wget --no-verbose "https://s3.amazonaws.com/rstudio-shiny-server-os-build/ubuntu-12.04/x86_64/shiny-server-$VERSION-amd64.deb" -O ss-latest.deb && \
    gdebi -n ss-latest.deb && \
    rm -f version.txt ss-latest.deb && \
    R -e "install.packages(c('shiny', 'rmarkdown'), repos='https://cran.rstudio.com/')" && \
    cp -R /usr/local/lib/R/site-library/shiny/examples/* /srv/shiny-server/ && \
    rm -rf /var/lib/apt/lists/*

EXPOSE 3838

RUN echo "r <- getOption('repos'); r['CRAN'] <- 'http://cran.us.r-project.org'; options(repos = r);" > ~/.Rprofile
RUN R -e 'install.packages(c("ggvis", "ggplot2", "RColorBrewer", "DT", "gplots", "data.table", "devtools", "V8", "nnls", "devtools"), dependencies = TRUE )'
RUN apt-get update && apt-get install -y -t unstable git vim wget libssl-dev libv8-dev libxml2-dev 
RUN R -e 'source("http://bioconductor.org/biocLite.R"); biocLite(c("debrowser", "Biostrings", "sangerseqR"));'

RUN git clone https://github.com/UMMS-Biocore/debrowser.git /srv/shiny-server/debrowser

RUN sed -i "s/debrowser::loadpacks()/library(debrowser)/" /srv/shiny-server/debrowser/R/server.R
RUN R -e 'library(debrowser);debrowser::loadpacks()'
RUN chown shiny:shiny /srv/shiny-server/debrowser -R
RUN sed -i "s/debrowser::loadpack(debrowser)//" /srv/shiny-server/debrowser/R/server.R


COPY shiny-server.sh /usr/bin/shiny-server.sh

CMD ["/usr/bin/shiny-server.sh"]


