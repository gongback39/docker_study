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


<pre><code> </code></pre>
옵션|설명
:---:|:---:
