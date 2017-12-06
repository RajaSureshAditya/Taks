#Takeing the Centos6 as Base Image
FROM centos:6

#Pre requisites for Python installation
RUN yum update -y && yum groupinstall -y "development tools" && yum install -y zlib-devel bzip2-devel openssl-devel ncurses-devel sqlite-devel readline-devel tk-devel gdbm-devel db4-devel libpcap-devel xz-devel expat-devel && yum install -y wget

WORKDIR /opt/

#Downloading the python tar file  in /opt/ and Installing Python2.7
ARG Version=2.7.14
RUN wget http://python.org/ftp/python/${Version}/Python-${Version}.tar.xz && tar xf Python-${Version}.tar.xz && rm -rf Python-${Version}.tar.xz
RUN cd Python-${Version} && ./configure --prefix=/usr/local --enable-unicode=ucs4 --enable-shared LDFLAGS="-Wl,-rpath /usr/local/lib" && make && make altinstall 

#Setting the Environment Variables
ENV JAVA_HOME /opt/jdk1.8.0_151
ENV PATH PATH=$PATH:/opt/jdk1.8.0_151/bin

#Installing JAVA 

COPY Scrpt.sh /opt/
RUN sh /opt/Scrpt.sh && rm -rf jdk-8u151-linux-x64.tar.gz

#Createing the repo file and copying the MongoDB Repository to it
RUN touch /etc/yum.repos.d/mongodb.repo
RUN echo $'[mongodb]\n\
name=MongoDB Repository\n\
baseurl=http://downloads-distro.mongodb.org/repo/redhat/os/x86_64/\n\
gpgcheck=0\n\
enabled=1\n'\
>> /etc/yum.repos.d/mongodb.repo

#Installing the mongoDb using yum repo
RUN yum -y install mongodb-org-server mongodb-org-shell mongodb-org-tools && yum clean all && mkdir -p /data/db
RUN service mongod start
EXPOSE 27017

#Downloading Tomcat 7 tar file to /opt/
ARG TOMCAT_MAJOR=v7.0.82
ARG TOMCAT_MINOR=7.0.82
ADD http://www-us.apache.org/dist/tomcat/tomcat-7/${TOMCAT_MAJOR}/bin/apache-tomcat-${TOMCAT_MINOR}.tar.gz /opt/
RUN mkdir tomcat7 && tar -xzf /opt/apache-tomcat-${TOMCAT_MINOR}.tar.gz -C /opt/tomcat7  && rm -rf apache-tomcat-${TOMCAT_MINOR}.tar.gz

#Startting the tomcat server
RUN sh /opt/tomcat7/apache-tomcat-${TOMCAT_MINOR}/bin/startup.sh
#Expose the port 8080
EXPOSE 8080

#To maintin the container in running state
CMD ["/opt/tomcat7/apache-tomcat-7.0.82/bin/catalina.sh"]
