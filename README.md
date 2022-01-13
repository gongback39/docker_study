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

## docker 권한 문제 (Got permisson denied issue in linux)
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
*옵션

|옵션|설명|
|:-----:|:----------:|
|-all, -a|모든 이미지를 표시|
|--digests|다이제스트를 표시|
|--no-trunc|결과를 모두 표시|
|--quiet.- q|docker 이미지 iD만 표시|

>결과

결과 화면에 나오는 항목
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

## 이미지 태그 성정
<pre><code>  </code></pre>


# docker를 이용한 웹서버 구축 (Nginx)
리버스 프록시나 로드 밸런서와 같은 기능을 갖음
## docker 이미지 다운로드 


<pre><code> </code></pre>
