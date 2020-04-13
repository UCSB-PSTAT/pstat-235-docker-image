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

RUN pip install pyspark && \
	pip install sparkmagic && \
        jupyter nbextension enable --py --sys-prefix widgetsnbextension

USER root
RUN cd /opt/conda/lib/python3.7/site-packages && \
	jupyter-kernelspec install sparkmagic/kernels/sparkkernel && \
	jupyter-kernelspec install sparkmagic/kernels/pysparkkernel && \
	jupyter-kernelspec install sparkmagic/kernels/sparkrkernel && \
	jupyter serverextension enable --py --sys-prefix sparkmagic

USER $NB_USER

RUN mkdir ~/.sparkmagic

ADD config.json ~/.sparkmagic/config.json

RUN R -e "install.packages(c('biglm'), repos = 'http://cran.us.r-project.org')"
