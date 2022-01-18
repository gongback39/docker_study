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
<pre><code> docker container port </code></pre>
*예시
<pre><code> $ docker container port webserver
80/tcp -> 0.0.0.0:80
80/tcp -> :::80
</code></pre>

#### 컨테이너 이름 변경
<pre><code> docker container rename </code></pre>

#### 컨테이너 안의 파일 복사
<pre><code> docker container cp <컨테이너 식별자>:<컨테이너 안의 파일 경로> <호스트 디렉토리의 경로> </code></pre>
<pre><code> docker container cp <호스트 파일> <컨테이너 식별자>:<컨테이너 안의 파일 경로> </code></pre>

* 예시
webserver안의 /etc/nginx/nginx.conf 파일을 호스트의 /tmp/etc에 복사
<pre><code>$ docker container cp webserver:/etc/nginx/nginx.conf /tmp/nginx.conf
$ ls -la /tmp/nginx.conf
-rw-r--r-- 1 nizejr docker 648 12월 29 00:40 /tmp/nginx.conf </code></pre>

#### 컨테이너 조작의 차분 확인
컨테이너 안에서 어떤 조작을 하여 컨테이너가 이미지로부터 생성되었을때와 달라진 점(차분)을 확인

<pre><code> docker container diff <컨테이너 식별자> </code></pre>

* 변경 구분
구분|설명
:---:|:---:
A|파일 추가
D|파일 삭제
C|파일 수정

<pre><code>
$ docker container diff webserver
C /var
C /var/cache
~
C /etc/nginx/conf.d
C /etc/nginx/conf.d/default.conf
</code></pre>

## 6) Docker 이미지 생성
Docker 컨테이너는 Docker 이미지를 바탕으로 작성하지만 반대로 Docker컨테이너를 바탕으로 Docker 이미지를 작성할 수 있음

#### 컨테이너로부터 이미지 작성
<pre><code> docker container commit [옵션] <컨테이너 식별자> [이미지명[:태그명]] </code></pre>
옵션|설명
:---:|:---:
--auther, -a|작성자를 지정
--message, -m|메시지를 지정
--change, -c|커미트 시 dockerfile 명령을 지정
--pause, -p|컨테이너를 일시 정지하고 커미트

<pre><code>$ docker container commit -a "gongback39" webserver gongback39/webfront:1.0
sha256:aba793aa8056bfc8d8279b108302d4ba6d335fcb1d8cb470f0197462e2286817
$ docker image inspect gongback39/webfront:1.0 | grep Author
        "Author": "gongback39",
</code></pre>

#### 컨톄이너를 tar파일로 출력
Docker에서는 가동중인 컨테이너의 디렉터리/파일을 모아서 tar파일을 만들 수 있음

tar파일을 바탕으로 하여 다른 서버에서 컨테이너를 가동할 수 있음

<pre><code> docker container export <컨테이너 식별자> </code></pre>
<pre><code>$ docker container export webserver > latest.tar 
$ ls -la | grep .tar
-rw-rw-r--  1 nizejr docker 144025600  1월 17 14:34 latest.tar
</code></pre>

#### tar파일로부터 이미지 작성
다음 명령을 사용하면 linuxos 이미지의 디렉토리/파일로 부터 Docker이미지를 만들 수 있음
<pre><code> docker image import <파일 또는 URL> | - [이미지명[:태그명]] </code></pre>
압축된 디렉토리나 파일도 취급.

docker image import 명령으로 지정하 수 있는 파일은 하나이므로 tar명령등으로 파일과 디렉토리를 모아두어야 하며 root권한으로 실행해야 하는 파일은 포함되지 않으므로 주의

docker image import 명령으로 지정할 수 있는 아카이브 파일
* tar
* tar.gz
* tgz
* bzip
* tar.xz
* txz

<pre><code>
$ cat latest.tar | docker image import - gongback39/webfront:1.1
sha256:35e1dd31ca0e61d780691ec8d4c68466b95db0bc9b87c89d7cefe94f31a64b17
$ docker image ls
REPOSITORY             TAG       IMAGE ID       CREATED         SIZE
gongback39/webfront    1.1       35e1dd31ca0e   9 seconds ago   140MB
</pre></code>

#### 이미지 저장
<pre><code> docker image save [옴션] <저장 파일명> [이미지명] </code></pre>
저장할 파일명은 -o옵션으로 지정

#### 이미지 읽어 들이기
<pre><code> docker image load [옵션] </code></pre>
-i 옵션을 이용해 읽어들일 파일명을 지정할 수 있음

####불필요한 이미지/컨테이너를 일괄 삭제
사용하지 않는 이미지, 컨테이너, 볼륨, 네트워크를 일괄적으로 삭제
<pre><code> docker system prune [옵션] </code></pre>
옵션|설명
:---:|:---:
--all, -a|사용하지 않는 리소스를 모두 삭제
--force, -f|강제적으로 삭제


