SUPER MoM ~ TAKE CARE OF OUR MoM ~
SUPER MoM ~ TAKE CARE OF OUR MoM ~
=========
[![image.png](https://s1.postimg.org/53zo00l4wv/image.png)](https://postimg.org/image/1kdqa7if4r/)

* README:       https://github.com/Thecatdog/Supermom-Front
* Bug Reports:  https://github.com/Thecatdog/Supermom-Front/issues

## Ruby version 

ruby 2.4.1

## :star2: Description
" **SUPER MoM** " is a web service for mothers who are not so familiar for searching because of inexperienced search skills and trends.

* The website receives information from the **user (mothers)**, as well as the input of the **child's** information.
* The server extracts the postings of the **Naver blog post based on the user's information**. The server outputs the most appropriate search results to the user's view.
* The server helps prevent users from being buried in a lot of information.
* The keywords that appear as a search result are calculated by using their own algorithm.
* The server then checks the frequency of the observed keyword and arranges it in descending order.
* Users can be provided **a better growth environment for their children** by using the information that the server has printed on the screen.

## :pencil2: Features

- [x] Responsive Web Design
- [x] List of vaccination for user's child.
- [x] Measuring a child's growth.
- [x] Naver Blog scrapping and Information cleanup work.
- [x] Using ruby gem "twitter-korean-text" to Morphological analysis. 
- [ ] Extracting "Daum" and other various sites of blog posts.
- [ ] User-defiend preference category.
- [x] Show festivals and fairs at Calendar automatically.
- [ ] Extract website with readability that help us more than easy Morphological analysis.
- [x] Batch Job Scheduler for Crawler (Crawler will be active every midnight.)


## :computer: Overview
[![image.png](https://s1.postimg.org/4r89tu4kv3/image.png)](https://postimg.org/image/96qoz3gz2z/)

## Demo

![demo](https://github.com/Thecatdog/Supermom-Front/blob/master/supermom_demo.gif)

## User menual

<img src='https://s1.postimg.org/6e5iu4b4ct/menual_en.png' border='0' alt='menual_en'/>

## 📎Deploy with Docker
Users can easily receive this project through Dockerfile.


```

FROM centos/ror-42-centos7
MAINTAINER Thecatdog

USER root

#jdk 8 setting
RUN yum install -y java-1.8.0-openjdk-devel.x86_64
ENV JAVA_HOME /usr/lib/jvm/java-1.8.0-openjdk-1.8.0.144-0.b01.el7_4.x86_64
RUN source /etc/profile

#project clone
RUN git clone https://github.com/Thecatdog/Supermom-Front

```

First, the user enters Docker folder.  
Second, build the image via Dockerfile.
```
 docker build --tag=<your new image name> .
```
Third, start the generated image.
```
docker run -i -t --privileged --name <your container name> --publish <your rails server port number> --user root <image id or name> /bin/bash

ex. ) docker run -i -t --privileged --name rubyprojectSupermom --publish 3000:3000 --user root supermomimage /bin/bash
```
If the user successfully started the Docker image, the user can immediately check the " Supermom - Front " directory via "ls" command.  
Finally, the user enters the " Supermom-Front " directory and enters the Ruby default command.
```
bundle install
rake db:migrate
rake db:seed
```
Since then, users can operate this project normally.
```
rails s -b 0.0.0.0 -p3000
```
Before accessing the web application, the user must check the ip address(docker vm(windows / mac) or linux os).  
And user can access web application at that ip address.  
(If the user fails to connect to the web application, they should check whether or not to open 3000 port.)
## API Reference

* [Naver_Crawler](https://github.com/Thecatdog/naver_crawler)
* [Twitter-Korean-Text-Ruby](https://github.com/twitter/twitter-korean-text)
* [Rufus-Scheduler](https://github.com/jmettraux/rufus-scheduler)

## License
[GNU](https://github.com/Thecatdog/Supermom-Front/blob/master/LICENSE)
