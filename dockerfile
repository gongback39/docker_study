docker에서는 인프라의 구성 관리를 dockerfile로 구성
dockerfile에는 베이스가 되는 이미지에 각종 미들웨어를 설치 및 설정하고 개발한 애플리케이켠의 실행모둘을 전개하기 위한 애플리케이션의 실행 기반의 모든 구성 정보를 기술

## dockerfile을 사용한 구성 관리
####dockerfile이란
dockerfile은 docker상에서 작동시킬 컨테이너의 구성 정보를 기술하기 위한 파일
> 작동 시킬 컨테이너의 구성 정보
* 베이스가 될 docker이미지
* docker 컨테ㅣ너 안에서 수행한 조작(명령)
* 환경변수 등의 설정
* docker컨테이너 안에서 작동 시켜둘 데몬 실행

#### docker의 기본 구문

dockerfile은 텍스트 형식의 파일로, 에디터 등을 사용하여 작성.

확장자가 필요없으며, 'dockerfile'이라는 이름의 파일에 인프라의 구성 정보를 기술.

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

####dockerfile 작성
dockerfile에는 'docker컨테이너를 어떤 docker이미지로부터 생성해야할지'라는 정보를 반드시 기술해야함

이 이미지를 베이스 이미지라고 함

<pre><code>
FROM [이미지명]
FROM [이미지명]:[태크명]
FROM [이미지명]@[다이제스트]
</code></pre>

## docker의 빌드와 이미지 레이어
####dockerfile로부터 docker 이미지 만들기
<pre><code>
docekr build -t [생성할 이미지명]:[태그명] [dockerfile의 위치]
</code></pre>

>예시
<pre><code>
$ touch Dockerfile
$ ls
Dockerfile
</code></pre>

<pre><code>
FROM centos:centos7
</code></pre>

<pre><code>
$ docker build -t sample:1.0 ~/sample
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
sample                 1.0       eeb6ee3f44bd   4 months ago   204MB
</code></pre>

위와 같이 베이스 이미지인 centos:centos7과 sampel:1.0가 만들어져있으며, imageID가 모두 같으므로 모두 같은 동일한 이미지 라는 것을 알 수 있음

#### docker 이미지의 레이어 구조
dockerfile을 빌드하여 docker이미지를 작성하면 dockerfile의 명령별로 이미지를 작성 이에 작성된 여러개의 이미지는 레이어 구조로 되어 있음




