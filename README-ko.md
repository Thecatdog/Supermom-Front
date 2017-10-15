
SUPER MoM ~ TAKE CARE OF OUR MoM ~
[![Build Status](https://travis-ci.org/Thecatdog/Supermom-Front.png?branch=master)](https://travis-ci.org/Thecatdog/Supermom-Front)
=========
[![image.png](https://s1.postimg.org/53zo00l4wv/image.png)](https://postimg.org/image/1kdqa7if4r/)

* README:       https://github.com/Thecatdog/Supermom-Front
* Bug Reports:  https://github.com/Thecatdog/Supermom-Front/issues

## Ruby version 

ruby 2.4.1

## :star2: Description
" **SUPER MoM** " 은 미숙한 검색 능력과 트렌드 추적에 능숙하지 않은, 정보를 수집하는 데에 있어서 어려움을 겪고 있는 어머니들을 위한 웹 애플리케이션입니다.

* “SuperMoM" 웹 사이트는 사용자(어머니들)로부터 인적 정보를 받아 저장하는 것뿐만 아니라, 사용자의 자녀 정보 역시 입력받아 저장합니다.
* 서버는 입력받은 **사용자와 사용자의 자녀 정보**를 바탕으로 네이버 블로그 포스팅을 추출합니다. (추출 요소 : 제목, 본문 요약문, 블로그 URL) 서버는 그중 사용자가 원하는, 사용자의 관심사에 가장 적합한 정보를 view에 출력합니다.
* 서버는 사용자가 많은 양의 정보에 매몰되는 것을 방지하기 위해 자체 알고리즘을 사용하여 가장 관심사에 적합한 키워드를 블로그 포스팅에서 추출합니다.
* 서버는 자체 알고리즘을 통해 추출된 키워드를 다시 한번 데이터베이스에 저장된 포스팅 정보에 대입합니다.
* 이를 통하여, 서버는 키워드 빈도수를 추출한 뒤, 해당 값을 바탕으로 내림차순 정렬하여 사용자에게 키워드 랭킹을 보여줍니다.
* 사용자는 서버가 view에 출력해준 정보를 활용하여 자녀에게 **더 나은 성장 환경**을 제공해줄 수 있습니다.

## :pencil2: Features
- [x] 반응형 웹 
- [x] 사용자 자녀 연령대에 해당하는 예방 접종 리스트
- [x] 사용자 자녀의 현재 성장 척도
- [x] 네이버 블로그 스크래핑과 추출 정보 가공
- [x] "twitter-korean-text" ruby gem 라이브러리를 이용한 형태소 분석
- [ ] “Daum"을 포함한 타 포털 사이트 블로그 포스팅 스크래핑 및 분석
- [ ] 사용자 정의 선호 카테고리 지정
- [x] 네이버에서 제공하는 축제 및 베이비 페어 정보 추출 후 내장 calendar에 삽입
- [ ] Readablility 한 웹사이트 추출 방식을 통하여 형태소 분석 단순화
- [x] Batch 스케쥴러를 통한 크롤링 자동화 ( 매일 자정 5분 뒤)


## :computer: Overview
[![image.png](https://s1.postimg.org/4r89tu4kv3/image.png)](https://postimg.org/image/96qoz3gz2z/)

## Demo

![demo](https://github.com/Thecatdog/Supermom-Front/blob/master/supermom_demo.gif)

## User menual

<img src='https://s1.postimg.org/6e5iu4b4ct/menual_en.png' border='0' alt='menual_en'/>

## 📎Deploy with Docker
사용자는 이 “SuperMoM" 프로젝트를 Dockerfile을 통하여 쉽고 간편하게 자신의 로컬 환경에서 가동할 수 있습니다.

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

첫째, Docker 폴더에 진입합니다.  
둘째, Dockerfile을 이용하여 Docker image를 생성합니다.
```
 docker build --tag=<your new image name> .
```
셋째, 생성된 Docker image를 가동합니다.
```
docker run -i -t --privileged --name <your container name> --publish <your rails server port number> --user root <image id or name> /bin/bash

ex. ) docker run -i -t --privileged --name rubyprojectSupermom --publish 3000:3000 --user root supermomimage /bin/bash
```
만약 Docekr image를 성공적으로 가동했다면, 사용자는 ls 명령어를 통하여 “Supermom-Front“ 디렉토리를 확인할 수 있습니다.  
마지막으로, 사용자는 "Supermom-Front" 디렉토리 안으로 진입하여 서버를 가동하기 위한 루비 기본 명령어를 입력합니다.
```
bundle install
rake db:migrate
rake db:seed
```
사용자는 성공적으로 프로젝트를 로컬 환경에서 운용하는 데에 성공했습니다!
```
rails s -b 0.0.0.0 -p3000
```
웹 애플리케이션에 진입하기 전, 사용자는 자신의 ip 주소를 필수로 확인해야 합니다. (docker vm ip address(windows / max) or linux ip address)  
사용자는 그 후, <해당 ip address>:3000 으로 웹 애플리케이션에 진입할 수 있습니다.  
(만약 웹 애플리케이션에 진입하는 것을 실패하였을 경우, 3000번 포트 진입을 허용하였는지 / 방화벽을 해제하였는지 확인하십시오.)



## API Reference

* [Naver_Crawler](https://github.com/Thecatdog/naver_crawler)
* [Twitter-Korean-Text-Ruby](https://github.com/twitter/twitter-korean-text)
* [Rufus-Scheduler](https://github.com/jmettraux/rufus-scheduler)

## License
[GNU](https://github.com/Thecatdog/Supermom-Front/blob/master/LICENSE)
