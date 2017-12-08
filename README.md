# Taks


COmmand to run the Docker file is 
for build the docker image 
docker build -t tomcat7 .
to run the docker container

docker run -it --name tomcat -p 7081:8080 -p 27017:27017 tomcat7


