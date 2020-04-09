FROM dddlab/python-rstudio-notebook:v20200405-b8822c1-94fdd01b492f
 
LABEL maintainer="Patrick Windmiller <windmiller@pstat.ucsb.edu>"

USER root

RUN apt-get update && \
	apt-get install -y openjdk-8-jdk && \
	apt-get install -y ant && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/* && \
	rm -rf /var/cache/oracle-jdk8-installer;

RUN apt-get update && \
	apt-get install -y ca-certificates-java && \
	apt-get clean && \
	update-ca-certificates -f && \
	rm -rf /var/lib/apt/lists/* && \
	rm -rf /var/cache/oracle-jdk8-installer;

ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64/
RUN export JAVA_HOME

USER $NB_USER

RUN pip install pyspark
RUN R -e "install.packages(c('biglm'), repos = 'http://cran.us.r-project.org')"
