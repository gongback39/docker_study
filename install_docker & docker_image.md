# docker_study

# 1. docker 시작
## docker 설치
>apt 업데이트
<pre><code> sudo apt-get update </code></pre>
>페키지 설치
<pre><code> sudo apt-get install -y \
apt-transport-https \
ca-certificates \
curl \
sotware-properties-common
</code></pre>
>GPG 키 추가
<pre><code> curl -faSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - </code></pre>
>GPG 키 확인
<pre><code> sudo apt-key fingerprint OEBFCD88 </code></pre> 
>repository 등록
<pre><code> sudo add-apt-repository \
"deb {arch=amd64] https://download.docker.com/linux/ubuntu \
$(lsb-release -cs) \
stable"</code></pre>
<pre><code> sudo apt-get update</code></pre>
>docker 설치
<pre><code> sudo apt-get install docekr-ce</code></pre>

## docker 컨테이너 작성 및 실행
<pre><code> docker container run <도커 이미지명> <실행할 명령> </code></pre>

## docker system
>docker 실행 환경 확인
<pre><code> docker system info</code></pre>
>docker 디스크 이용 상황
<pre><code> docker system df </code></pre>

## (ERROR) docker 권한 문제 (Got permisson denied issue in linux)
> docker grouup 생성
<pre><code> sudo groupadd docker </code></pre>
> docker group에 해당 유저를 추가
<pre><code> sudo usermod -aG docker $USER </code></pre>
> 적용
<pre><code>newgrp docker</code></pre>


# 2. Docker 이미지 조작
## docker 이미지 다운로드
<pre><code> docker image pull [옵션] 이미지명[:태그명] </code></pre>
*옵션

|옵션|설명|
|:-----:|:----------:|
|-all, -a|모든 이미지를 표시|
>URL을 지정하여 다운로드
<pre><code> docker image pull [URL] </code></pre>

## docker 이미지 목록 표시
<pre><code> docker image ls [옵션] [repository name] </code></pre>
* 옵션

|옵션|설명|
|:-----:|:----------:|
|-all, -a|모든 이미지를 표시|
|--digests|다이제스트를 표시|
|--no-trunc|결과를 모두 표시|
|--quiet.- q|docker 이미지 iD만 표시|

* 결과 항목

|항목|설명|
|:-----:|:----------:|
|REEPOSITORY|이미지 이름|
|TAG|이미지 태그명|
|IMAGE ID|이미지 ID|
|CREATED|작성일|
|SIZE|이미지 크기|

## 이미지 상세 정보 확인 
<pre><code> docker image inspect </code></pre>
>예시 
<pre><code>$ docker image inspect nginx 
[
    {
        "Id": "sha256:605c77e624ddb75e6110f997c58876baa13f8754486b461117934b24a9dc3a85",
        "RepoTags": [
            "nginx:latest"
        ],
        "RepoDigests": [
            "nginx@sha256:0d17b565c37bcbd895e9d92315a05c1c3c9a29f762b011a10c54a66cd53c9b31"
        ],
        ~중략~
        "Metadata": {
            "LastTagTime": "0001-01-01T00:00:00Z"
        }
    }
]
</code></pre>
결과는 JSON(JavaScript Object Notation, 텍스트 기반 데이터 포멧)형식으로 표시된다. 

>--format
* os 정보 취득
<pre><code>$ docker image inspect --format="{{ .os}}" centos:7
inux</code></pre>
* image  정보 취득
<pre><code>$ docker image inspect --format="{{ .containerConfig.Image}}" centos:7
sha256:5a28642a68c5af8083107fca9ffbc025179211209961eae9b1f40f928331fa90</code></pre>

## 이미지 태그 설정
이미지 태그에는 식병하기 쉬운 버전 명을 붙이는 것이 일반적, 

또한 Ducker Hub에 작성한 이미지를 등록하려면 이미지에 사용자명을 붙여야함
<pre><code> docker image tag 소스_이미지명[:태그명] <도커 허브 사용자명>/타겟_이미지명[:태그명] </code></pre>
*예시
<pre><code>$ docker image ls
REPOSITORY    TAG       IMAGE ID       CREATED        SIZE
ubuntu        latest    d13c942271d6   6 days ago     72.8MB
nginx         latest    605c77e624dd   2 weeks ago    141MB
hello-world   latest    feb5d9fea6a5   3 months ago   13.3kB

$ docker image tag nginx  gongback39/webserver:1.0

$ docker image ls
REPOSITORY             TAG       IMAGE ID       CREATED        SIZE
ubuntu                 latest    d13c942271d6   6 days ago     72.8MB
nginx                  latest    605c77e624dd   2 weeks ago    141MB
gongback39/webserver   1.0       605c77e624dd   2 weeks ago    141MB
hello-world            latest    feb5d9fea6a5   3 months ago   13.3kB
</code></pre>
*태그된 이미지와 원래 이미지의 IMAGE ID가 같음

즉 실체가 똑같다.

## 이미지 검색
Docker hub에 공개되어 있는 이미지 검색
<pre><code> docker search [옵션] <검색 키워드> </code></pre>
*옵션

옵션|설명
:--------:|:----------:
--no-trunc|결과를 모두 표시
--limit|n건의 검색 결과를 표시
--filter=stars=n|즐겨찾기의 수를 지정

*결과 항목

항목|설명
:-------:|:-----------:
NAME|이미지 이름
DESCRIPTION| 이미지 설명 
STARS|즐겨찾기 수
OFFICIAL|공식 이미지인지 아닌지
AUTOMATED|dockerfile을 바탕으로 자동생성된 이미지인지 아닌지

docker hub에 공개되어 있는 이미지가 모두 안전한 것은 아님, 

그러므로 공식이미지 이거나 dockerfile이 제대로 공개되어있는 것을 선택해야함

## 이미지 삭제
> 작성한 이미지 삭제
<pre><code> docker image rm [옵션] 이미지명 </code></pre>
*옵션
옵션|설명
:-----:|:---------:
--force, -f|이미지를 강제로 삭제
--no-prune|중간 이미지를 삭제하지 않음

이미지명 = REPOSITORY or IMAGE ID

> 사용하지 않는 docker 이미지를 삭제
<pre><code> docker image prune [옵션] </code></pre>
옵션|설명
:------:|:----------:
--all, -a|사용하지 않은 이미지를 모두 삭제
--force, -f|이미지를 강제로 삭제

## Docker Hub에 로그인
<pre><code> docker login [옵션] [서버] </code></pre>
옵션|설명
:-----:|:---------:
--password, -p|비밀번호
--username, -u|사용자명

옵션을 지정하지 않으면 사용자명과 비밀번호를 물어봄

서버명을 지정하지 않을시 Docker Hub에 엑서스

다른 황경에 docker repository가 있는 경우 서버명 지정

## 이미지 업로드
<pre><code> docker image push 이미지명[:태그명] </code></pre>
이때 이미지명도 사용자명과 같이 표기
<pre><code> <도커 허브 사용자명>/이미지명[:태그명} </code></pre>

## Docker Hub에서 로그아웃
<pre><code> docker logout [서버명] </code></pre>
서버명을 지정하지 않았을 떄는 Ducker Hub에 억세스함

다른 황경에 docker repository가 있는 경우 서버명 지정
