 ## 4. Docker 컨테이너 네트워크

Docker 네트워크를 통해 docker 컨테이너를 통신함

#### 1) 네트워크 목록 표시

> 네트워크의 구성 정보 목록 확인
<pre><code> docker network ls [옵션] </code></pre>
옵션|설명
:---:|:---:
-f, --filter=[]|출력을 필터링
--no-turunx|상세 정보를 출력
-q,-quiet|네트워크 ID만 표시

* 필터링에서 이용할 수 있는 키

값|설명
:---:|:---:
driver|드라이버 지정
id|네트워크 ID
label|네트워크에 설정된 라벨(label=<"key"> 혹은 label=<"key">=<"value">로 지정)
name|네트워크명
scope|네트워크의 스코프(swarm/global/local)
type|네트워크의 타입(사용자 정의 네트워크 custom/정의 완료 네트워크 builtin)

Docker는 기본값으로 bridge, host, none의 네트워크를 만듦

Docker container에 소속된 네트워크를 확인할떄는
<pre><code> docker container inspect [컨테이너명] </code></pre>
이라는 명령어를 사용.

<pre><code>$ docker container run -itd --name=sample ubuntu:latest
6718d95873a55e051f7503645f3497e5622bc788d2f3e596a00284868210c6c1

$ docker container inspect sample
[
    {
        "Id": "6718d95873a55e051f7503645f3497e5622bc788d2f3e596a00284868210c6c1",
        "Created": "2022-01-16T04:40:24.235136812Z",
        "Path": "bash",
        "Args": [],
        "State": {
            "Status": "running",
            "Running": true,
            "Paused": false,
            "Restarting": false,
            "OOMKilled": false,
            "Dead": false,
            "Pid": 5926,
            "ExitCode": 0,
            "Error": "",
        ~
    }
]
</code></pre>

#### 2) 네트워크 작성

>새로운 네트워크 작성

<pre><code> dockernetwork create [옵션] 네트워크 </code></pre>
옵션|설명
:---:|:---:
--driver, -d|네트워크 브리지 또는 오버레이(기본값: bridge)
--ip-range|컨테이너에 할당하는 IP주소의 범위설정
--subnet|서브넷을 CIDR 형식으로 지정
--ipv6|IPv6 네트워크를 유효화할지 말지(true/false)
-label|네트워크에 설정하는 라벨

#### 3) 네트워크 연결

Docker 컨테이너를 Docker 네트워크에 연결

<pre><code> docker network connet [옵션] 네트워크 컨테이너 </code></pre>
옵션|설명
:---:|:---:
--ip|IPv4주소
--ip6|IPv6 주소
--alias|앨리어스명
--link|다른 컨테이너에 대한 링크

<pre><code> docker network connect web-network webfront </code></pre>

* 네트워크에 대한 연결은 컨테이너 시작 시에 할 수도 있음
>베이스 이미지가 nginx고 webap라는 이름의 컨테이너를 web-network에 만듦
<pre><code> docker container run -itd --name=webap --net=web-network nginx </code></pre>

#### 4) 네트워크 상세 정보 확인

<pre><code> docker network inspect [옵션] 네트워크 </code></pre>

#### 5) 네트워크 삭제 

<pre><code> docker network rm [옵션] 네트워크 </code></pre>
단, 네트워크를 삭제하려면 docker network disconnect명령을 사용하여 연결중인 모든 컨테이너와의 연결을 해제해야함

## 5. 가동중인 Docker 컨테이너 조작

#### 가동 컨테이너 연결
가동중인  컨테이너에 연결할 때
<pre><code> docker container attach </code></pre>
명령을 사용

#### 가동 컨테이너에서 프로세스 실행
웹서버와 같이 백그라운드에서 실행되고 있는 컨테이너에 액세스하고 싶을 떄 docker container attach명령으로 연결해도 쉘이 작동하지 않는 경우 명령을 접수할 수 없는데 이때 docker container exec 명령을 사용하여 임의의 명령을 실행 가능.
<pre><code> docker container exec [옴션] <컨테이너 식별자> <실행할 명령> [인수] </code></pre>
옵션|설명
:---:|:---:
--detech, -d|명령을 백그라운드에서 실행
--interactive, -i|컨테이너의 표준 입력을 염
--tty, -t|tty(단말 디바이스)를 사용
--user, -u|사용자명 지정

<pre><code>$ docker container exec -it webserver /bin/bash
root@4da054c05e5e:/#
</code></pre>
> 명령 직접 실행
<pre><code>
$ docker container exec -it webserver bin/echo "hello world"
hello world
</code></pre>

#### 가동 컨테이너의 프로세스 확인
<pre><code> docker container top </code></pre>

#### 가동 컨테이너의 포트 전송 확인



<pre><code> </code></pre>
옵션|설명
:---:|:---:
