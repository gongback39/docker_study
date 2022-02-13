docker에서는 인프라의 구성 관리를 dockerfile로 구성<br/>
dockerfile에는 베이스가 되는 이미지에 각종 미들웨어를 설치 및 설정하고 개발한 애플리케이켠의 실행모둘을 전개하기 위한 애플리케이션의 실행 기반의 모든 구성 정보를 기술

## dockerfile을 사용한 구성 관리
#### dockerfile이란
dockerfile은 docker상에서 작동시킬 컨테이너의 구성 정보를 기술하기 위한 파일
> 작동 시킬 컨테이너의 구성 정보
* 베이스가 될 docker이미지
* docker 컨테이너 안에서 수행한 조작(명령)
* 환경변수 등의 설정
* docker컨테이너 안에서 작동 시켜둘 데몬 실행

#### docker의 기본 구문

dockerfile은 텍스트 형식의 파일로, 에디터 등을 사용하여 작성.<br/>
확장자가 필요없으며, 'dockerfile'이라는 이름의 파일에 인프라의 구성 정보를 기술.<br/>
dockerfile 이외의 파일명에서도 작동하지만 이때는 dockerfile에서 이미지를 빌드할 때 파일명을 명시적으로 지정해야함.

>  dockerfile의 명령

명령|설명
:---:|:---:
FROM|배이스 이미지 지정
RUN|명령 실행
CMD|컨톄이너 실행명령
LABEL|라벨 설정
EXPOSE|포트 익스포트
ENV|환경변수
ADD|파일/디렉토리 추가
COPY|파일 복사
ENTRYPOINT|컨테이너 실행 명령
VOLUME|볼륨 마운트
USER|사용자 지정
USER|사용자 지정
WORKDIR|작업 디렉토리
ARG|docker 안의 변수
ONBUILD|빌드 완료 후 실행되는 명령
STOPSIGNAL|시스템 콜 시그널 설정
HEALTHCHECK|컨톄이너의 혤스 체크
SHELL|기본 쉘 설정

주석의 경우 줄 맨 앞에 #을 붙임

#### dockerfile 작성
dockerfile에는 'docker컨테이너를 어떤 docker이미지로부터 생성해야할지'라는 정보를 반드시 기술해야함<br/>
이 이미지를 베이스 이미지라고 함
<pre><code>FROM [이미지명]
FROM [이미지명]:[태크명]
FROM [이미지명]@[다이제스트]</code></pre>

## docker의 빌드와 이미지 레이어
#### dockerfile로부터 docker 이미지 만들기
<pre><code>docekr build -t [생성할 이미지명]:[태그명] [dockerfile의 위치]</code></pre>
>예시
<pre><code>$ touch Dockerfile
$ ls
Dockerfile</code></pre>
<pre><code>FROM centos:centos7</code></pre>
<pre><code>$ docker build -t sample:1.0 ~/sample
Sending build context to Docker daemon  2.048kB
Step 1/1 : From centos:centos7
centos7: Pulling from library/centos
Digest: sha256:9d4bcbbb213dfd745b58be38b13b996ebb5ac315fe75711bd618426a630e0987
Status: Downloaded newer image for centos:centos7
 ---> eeb6ee3f44bd
Successfully built eeb6ee3f44bd
Successfully tagged sample:1.0

$ docker image ls
REPOSITORY             TAG       IMAGE ID       CREATED        SIZE
centos                 centos7   eeb6ee3f44bd   4 months ago   204MB
sample                 1.0       eeb6ee3f44bd   4 months ago   204MB</code></pre>

위와 같이 베이스 이미지인 centos:centos7과 sampel:1.0가 만들어져있으며, imageID가 모두 같으므로 모두 같은 동일한 이미지 라는 것을 알 수 있음

#### docker 이미지의 레이어 구조
dockerfile을 빌드하여 docker이미지를 작성하면 dockerfile의 명령별로 이미지를 작성 이에 작성된 여러개의 이미지는 레이어 구조로 되어 있음
<pre><code>From ubuntu:latest

RUN apt-get update && apt-get install -y -q nginx

COPY index.html /usr/share/nginx/html/

CMD ["nginx", "-g", "daemon off;"}</code></pre>

<pre><code>$ docker build -t webap ~/sample
Sending build context to Docker daemon   2.56kB
Step 1/4 : From ubuntu:latest
 ---> d13c942271d6
Step 2/4 : RUN apt-get update && apt-get install -y -q nginx
~
 ---> 3ada74815bb7
Step 3/4 : COPY index.html /usr/share/nginx/html/
 ---> 833d6ece48fd
Step 4/4 : CMD ["nginx", "-g", "daemon off;"}
 ---> Running in eeddf68a8fdb
Removing intermediate container eeddf68a8fdb
 ---> b14a8627004b
Successfully built b14a8627004b
Successfully tagged webap:latest</code></pre>

공통의 베이스 이미지를 바탕으로 여러개의 이미지를 작성한 경우, 베이스 이미지의 레이어가 공유되므로써 디스크의 용량을 효율적으로 이용할 수 있음

## 멀티스테이지 빌드를 사용한 애플리케이션 개발
제품환경에는 애플리케이션을 실행하기 위해 최소한으로 필요한 실행 모듈만 배치하는 것이 컴퓨팅 리소스를 효율적으로 활용할 수 있고 보안 과점에서 바람직함

<img src="./img/docker multistage.png">

> 학습을 위한 샘플코드 복제
<pre><code>$ git clone https://github.com/asashiho/dockertext2
$ cd dockertext2/chap05/multi-stage</code></pre>

>Dockerfile
<pre><code># 1. Build Image
FROM golang:1.13 AS builder

# Install dependencies
WORKDIR /go/src/github.com/asashiho/dockertext-greet
RUN go get -d -v github.com/urfave/cli

# Build modules
COPY main.go .
RUN GOOS=linux go build -a -o greet .

# ------------------------------
# 2. Production Image
FROM busybox
WORKDIR /opt/greet/bin

# Deploy modules
COPY --from=builder /go/src/github.com/asashiho/dockertext-greet/ .
ENTRYPOINT ["./greet"]</code></pre>

이 dockerfile은 두개의 부분으로 나뉘어있음

1. 개발환경용 Docker 이미지<br/><br/>
해당 이미지에서는 golang을 베이스 이미지로 작성하고 builder라는 별병을 붙임<br/>
그래고 개발에 필요한 버전을 설치하여 로컬 환경에 있는 소스코드를 컨테이너 안으로 복사<br/>
이 소스코들를 go build 명령으로 빌드하여 'greet'이라는 이름의 실행가능 바이너리 파일을 작성

2. 제품환경용 Docker 이미지<br/><br/>
busybox를 제품환경용 docker 이미지의 베이스 이미지로 사용함.<br/><br/>
busybox는 기본적인 linux명령을 하나의 파일로 모은 것으로 최소한으로 필요한 Linux쉘 환경을 제송하는 경우 이용<br/><br/>
그 다음 개발용 환경의 docker이미지로 빌드한 greet라는 이름의 실행가능 바이너리 파일을 제품 환경용 docker 이미지로 복사.<br/>
이때 --from 옵션을 사용하여  builder라는 이름의 이미지로부터 복사한다는 것을 선언<br/>
마지막으로 복사란 실행 가능 바이너리 파일을 실행하는 명령을 적음<br/>
그러므로 2개의 docker이미지를 생성할 수 있는 dockerfile이 생성

#### docker 이미지의 빌드
<pre><code>~/dockertext2/chap05/multi-stage$ docker build -t greet ./</code></pre>

#### docker 컨테이너의 시작
<pre><code>~/dockertext2/chap05/multi-stage$ docker container run -it --rm greet asa
Hello asa
~/dockertext2/chap05/multi-stage$ docker container run -it --rm greet --lang=es asa
Hola asa</code></pre>

## 명령 및 데몬 실행 
Docker 이미지를 만들려면 핑요한 미들웨어를 설치하고 사용자 계정이나 디렉토리를 작성하는 드으이 명령을 실행할 필요가 있음.<br/>
또한 이미지로부터 컨테이너를 생성했을 때 ㅓ버 프로세스 등을 데몬으로서 작동시킬 필요도 있음

#### 명령 실헹
컨테이너에서 FROM명령에서 지정한 베이스 이미지에 대해 명령을 실행할때 RUN명령을 사용
<pre><code>RUN[실행하고 싶은 명령]</code></pre>

> 1. Shell 형식으로 기술

명령의 지정을 쉘에서 실행하는 형식으로 기술하는 방법
<pre><code>RUN apt-get install -y nginx</code></pre>
docker 컨테이너 안에서 /bin/sh -c를 사용하여 명령을 실행했을때와 똑같이 작동

실행할 기본 쉘을 변경하고 싶을때는 SHELL명령을 사용
> 2. Exec 형식으로 기술

Exec 형식으로 기술하면 쉘을 경유하지 않고 직접실행.<br/>
따라서 명령 인수에 $HOME과 같은 환경변수를 지정할 수 없음.<br/>
Exec형식에서는 실행하고 싶은 명령을 JSON배열로 지정.<br/>
다른 쉘을 사용하고 싶을 때는 RUN명령에 쉘의 경로를 지정한 후 실행하고 싶은 명령 지정

<pre><code> RUN ["/bin/bash","-c", "apt-get install -y nginx"] </code></pre>

#### 데몬 실행
Run명령은 이미지를 작성하기 위해 실행하는 명령을 기술하지만, 이미지를 바탕으로 생성된 컨테이너 안에서 명령을 실행하려면 CMD명령을 사용.<br/>
예를 들어 웹서버를 가동시키기 위해 Nginx를 설치하는 명령은 RUN명령을, 설치한 Nginx를 데몬으로서 컨테이너 안에서 상시 작동기키기 위해서는 CMD명령을 사용
<pre><code> CMD [실행하고 싶은 명령] </code></pre>
> 1. Exec형식으로 기술

RUN 명령과 같이 JSON배열로 지정
> 2. shell형식으로 기술 

RUN명령의 구문과 같음.

쉘을 통해 실행하고 싶을 때 사용.
> 3. ENTRYPOINT명령의 파라미터로 기술

나중에 설명할 ENTRYPOINT 명령의 인수로 CMD명령을 사용할 수 있음.

#### 데몬 실행 (ENTRYPOINT 명령)
ENTRYPOINT명령에서 지정한 명령은 dockerfile에서 빌드한 이미지로부터 Docker컨테이너를 시작하기 때문에 docker container run 명령을 실행했을 때 실행
<pre><code> ENTRYPOINT [실행하고 싶은 명령] </code></pre>

> 1. Exec 형식으로 기술
RUN 명령과 같음
<pre><code> ENTRYPOINT ["nginx", "-g", "daemon off;"] </code></pre>

> 2. Shell형식으로 기술
RUN 명령과 같음
<pre><code> ENTRYPOINT nginx -g 'daemon off;' </code></pre>
ENTRYPOINT 명령과 CMD명령의 차이는 docker container run 명령 실행 시의 동작에 있음.<br/><br/>
CMD의 경우: 컨테이너 시작 시에 길행하고 싶은 명령을 정의해도 docker container run 명령실행 시에 인수로 새로운 명령을 지정한 경우 이것을 우선 실행<br/>
ENTRYPOINT 명령에서 지정한 명령은 반드시 컨테이너에서 실행.<br/>
ENTRYPOINT 명령으로는 실행하고 싶은 명령 자체를 지정하고 CMD명령으로는 그 명령의 인수를 지정하면 컨테이너를 실행했을때의 기본 작동을 결정할 수 있음.<br/>

<pre><code>ENTRYPOINT ["top"]
CMD ["-d", "10"] </code></pre>

ENTRYPOINT명령으로 top명령을 실행하고 CMD명령으로 갱신간격인 -d 옵션을 10초로 지정합니다.<br/>
이때 CMD에서 지정한 옵션을 사용하여 실행 시의 인수를 임의로 docker contianer run 명령 실행 시로 지정할 수 있음<br/>
위의 dockerfile을 바탕으로 sample이라는 이미지를 작성하고 docker container run 명령을 실행해보면<br/>

> CMD에서 지정한 10초 간격으로 갱신하는 경우
<pre><code>$ docker container run -it sample </code></pre>
> 2초 간격으로 갱신하는 경우
<pre><code>$ docker container run -it smaple -d 2 </code></pre>

#### 빌드완료 후에 실행되는 명령(ONBUILD 명령)
ONBUILD명령은 그 다음 빌드에서 실행할 명령을 이미지 안에 설정하기 위한 명령<br/>
<pre><code> ONBUILD [실행하고 싶은 명령] </code></pre>
ONBUILD명령은 자신의 Dockerfile로부터 생성한 이미지를 베이스 이미지로 한 다른 Dockerfile을 빌드할 때 실행하고 싶은 명령을 기술

<img src="./img/docker onbuild.jpg" width="600" height="300">

#### 시스템 콜 시그널의 설정(STOPSIGNAL 명령)
컨테이너를 종료할때 송신하는 시그널을 설정함.<br/>
<pre><code> STOPSIGNAL [시그널] </code></pre>
STOPSIGNAL 명령에는 시그널 번호 또는 시그널명을 지정할 수 있음

#### 컨테이너 헬스 체크 명령(HEALTHCHECK 명령)
컨테이너 안의 프로세스가 정상적으로 작동하고 있는지를 체크.<br/>
<pre><code> HEALTHCHECK [옵션] CMD 실행할 명령 </code></pre>
지정할 수 있는 옵션 
옵션|설명|기본값
:---:|:---:|:---:
--interval=n|헬스 체크 간격|30s
--timeout=n|헬스 체크 타임 아웃|30s
--retries=N|타임아웃 횟수|3

HEALTHCHECK 명령에서는 Docker에 대해 컨테이너의 상태를 어떻게 확인할지를 설정<br/>
헬스 체크의 결과는 docker containerinspect명령으로 확인할 수 있음

## 환경 및 네트워크 
dockerfile 안에서 이용할 수 있는 환경변수나 컨테이너 안에서의 작업 디렉토리를 지정할 수 있음.<br/>
이를 구현하는 명령에 대해 설명

#### 환경변수 설정(ENV 명령)
dockerfile안에서 환경변수를 설정하고 싶을떄는 ENV명령을 사용. 
<pre><code>ENV [key] [value]</code></pre>
<pre><code>ENV [key[=[value]</code></pre>

1. key value형으로 지정하는 경우
단일 환경 변수에 하나의 값을 설정.

첫 공백 앞을 key로 설정하면 그 이후는 공백이나 따옴표와 같은 문자가 포함되어도 모두 문자열로서 취급
<pre><code>ENV myName "shiho ASA"
ENV myOrder Gin Whisky calvados
ENV myNickName miya
</code></pre>

2. key=value로 지정하는 경우
한번에 여러개의 값을 설정하때
<pre><code>ENV myName="shiho ASA"
 myorder=Gin\ whiskey\ Calvados\
 myNickName=miya</code></pre>
 
여기서 하나의 ENV명령으로 여러개의 값을 설정하므로 만들어지는 Docker이미지는 변수 앞에 \를 추가하면 이스케이프 처리를 할 수 있음.<br/>
ENV명령으로 지정한 환경변수는 컨테이너 실행 시의 dockercontainer run명령의 --env 옵션을 사용하면 변경 가능.

#### 작업 디렉토리 지정(WORKDIR 명령)
dockerfile에서 정의한 명령을 실행하기 위한 작업용 디렉토리를 지정
<pre><code> WORKDIR [작업 디렉토리 경로]</code></pre>
WORKDIR명령은 DOckerfile에 쓰여있는 다음과 같은 명령을 실행하기 위한 작업용 디렉토리를 지정
 - RUN 명령
 - CMD 명령
 - ENTRYPOINT 명령
 - COPY 명령
 - ADD 명령
 
만일 지정한 디렉토리가 존재하지 않으면 새로 작성.

#### 사용자 지정(USER명령)
이미지 실행이나 Dockerfile의 다음과 같은 명령을 실행하기 위한 사용자를 지정할 때는 USER명령을 사용
 - RUN 명령
 - CMD 명령
 - ENTRYPOINT명령
<pre><code> USER [사용자명/UID] </code></pre>

USER 명령에서 지정하는 사용자는 RUN 명령으로 미리 작성해 놓을 필요가 있다는 점에 주의
*  USER명령의 예
<pre><code>RUN ["adduser", "asa"]
RUN ["whoami"]
USER asa
RUN ["whoami"]</code></pre>

#### 라벨 지정 (LABEL 명령)
이미지에 버전 정보나 작성자 정보, 코멘트 등과 같은 정보를 제공할때 사용.
<pre><code> LABEL <키 명>=<값></code></pre>

#### 포트 설정(EXPOSE 명령)
컨테이너의 공개 포트 번호를 지저할 떄 사용
<pre><code>EXPOSE <포트번호> </code></pre>
EXPOSE명령은 Docker에게 실행 중인 컨테이너가 listen하고 있는 네트워크를 알려줌.

#### Dockerfile 내 변수의 설정<APG 명령>
Dockerfile 안에서 사용할 변수를 정의할 때는 사용.<br/>
이 명령을 사용하면 변수의 값에 따라 생성 도는 이미지의 내용을 바꿀 수 있음.
<pre><code>ARG <이름>[=기본값]</code></pre>
<br/>
>ARG 명령의 예
<pre><code>#변수의 정의: ARG명령으로 YOURNAME이라는 변수를 정의한 Dockerfile작성
ARG YOURNAME="asa"
RUN echo $YOURNAME</code></pre>
또한 Dockerfile을 빌드 할때 <code>--build-arg</code>옵션을 붙여 ARG명령에서 지정한 YOURNAME에 새로운 값을 지정 가능

#### 기본 쉘 설정(SHELL 명령)
쉘 형식으로 명령을 실행할때 기본 쉘을 설정하는데 사용.
<pre><code> SHELL ["쉘의 경로", "파라미터"]</code></pre><br/>
* 예시
<pre><code># 기본 쉘을 /bin/bash로 변경
SHELL ["/bin/bash", "-c"]</code></pre>
> linux의 기본 쉘은 ["/bin/bash","-c"]

SHELL 명령을 지정하면 그 쉘은 그 이후에 Docekrfile안에서 SHELL형식으로 지정한 RUN, CMD, ENTRYPOINT명령에서 유효.

## 파일 설정
Dockerfile에서 파일을 다룰 떄 사용한는 명령
#### 파일 및 디렉토리 추가 (ADD명령)
이미지에 호스트사으이 파일이나 디텍토리를 추가할떄 사용
<pre><code> ADD <호스트의 파일 경로> <Docker 이미지의 파일 경로></code></pre>
<pre><code> ADD ["<호스트 파일 경로>" "<Docker 이미지의 파일 경로>"] </code></pre>
ADD명령은 호스트상의 팡리이나 디렉토리, 원격 파일을 Docker이미지 안으로 복사.
* ADD명령에 사용하는 패턴 예
<pre><code>#[hos]로 시작하는 모든 파일을 추가
ADD hos* /docker_dir/
# [hos]+임의의 한 문자 룰에 해당하는 파일을 추가
ADD hos?.txt /docker_dir/</code></pre>
<br />
이미지에 추가하고 싶은 파일이 원격파일 URL인 경우 URL을 다운로드하여 DOCKER이미지 안의파일 경로로 퍼미션이 600인 파일이 추가됨

#### 파일 복사(COPY 명령)
이미지에 호스트 상의 파일이나 디렉토리를 복사할때 사용
<pre><code>COPY <호스트의 파일 경로> <Dockeer 이미지의 파일 경로></code></pre>
<pre><code>COPY ["<호스트의 파일 경로>" "<Docker 이미지의 파일 경로>"]</code></pre>

