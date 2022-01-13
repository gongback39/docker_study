# 3. Docker 컨테이너 
>컨테이너의 라이프 사이클

컨테이너는 다음과 같은 상태로 변화
<img src="./img/docker container.jpg">

## 컨테이너 생성
<pre><code> docker container create </code></pre>
이미지로부터 컨테이너를 생성

이미지는 'doker에서 서버 기능을 작동시키기 위해 피료한 디렉토리 및 파일들이다.

docker container create 명령은 이미지에 포함될 linux의 디렉토리와 파일들의 스냅샷(스토리지내 파일과 디렉토리를 특정 타이밍에 추출)을 취한다.

컨테이너를 작성할뿐 시작하지 않음

## 컨테이너 생성 및 시작
<pre><code> docker container run [옵션] 이미지명[:태그명] [인수] </code></pre>
옵션|설명
:-----:|:---------:
--attach, -a|표준입력(STDIN), 표준출력(STDOUT), 표준 오류 출력(STDERR)에 어테치
--cidfile|컨테이너 ID를 파일로 출력
--detach, -d|컨테이너를 생성하고 백그라운드에서 실행
--interactive, -i|컨테이너의 표준 입력을 연다.
--tty, -t|단말기 디바이스를 사용한다.

### 대화식 실행
<pre><code> docker container run [옵션] <컨테이너명> 이미지명 명령 </code></pre>
* 예시
<pre><code>$ docker container run -it --name "test1" centos /bin/cal
    January 2022    
Su Mo Tu We Th Fr Sa
                   1
 2  3  4  5  6  7  8
 9 10 11 12 13 14 15
16 17 18 19 20 21 22
23 24 25 26 27 28 29
30 31               
</code></pre>
centos라는 이름의 이미지를 바탕으로 test1이라는 이름의 컨테이너를 생성 및 실행, 커넽이너 내에서 /bin/cal 실행

이때 --name을 통해 컨테이너명 지정, /bin/cal은 Linux 표준 명령

### 백그라운드 실행 (디태치 모드)
* 옵션

옵션|설명
:-----:|:---------:
--detach, -d|백그라운드 실행
--user, -u|사용자명을 지정
--rm|명령 실행 완료후에 컨테이너를 자동으로 삭제
----restart=[옵션]| 명령 실행 결과ㅔ에 따라 재시작을 하는 옵션

* --restart 옵션

옵션|설명
:-----:|:---------:
no|재시작하지 않는다
on-failure|종료 스테이터스가 0이 아닐때 재시작
on-failure:횟수|종료 스테이 터스가 0이 아닐떄 횟수번 재시작
always|항상 재시작
unless-stopped|최근 컨테이너가 정지 상태가 아니라면 항상 재시작

<pre><code> docker container run -d 이미지명 명령 </code></pre>
* 예시
<pre><code>$ docker container run -d centos /bin/ping localhost
9490570e7791e87ea2719242185d3c4864c89bb01167196af675f403053a5414
</code></pre>
centos라는 이름의 이미지를 바탕으로 컨테이너를 생성, localhost에 대해 ping명령을 실행 

백그라운드 실행의 경우 결과 대신 시작된 컨테이너의 컨테이너ID가 표시

백그라운드에서 실행되고 있는지 아닌지를 확인할때는 
<pre><code> docker container log </code></pre>
를 사용함

* 예시
<pre><code>$ docker container logs -t 9490570e7791
2022-01-13T08:38:42.439279451Z PING localhost (127.0.0.1) 56(84) bytes of data.
2022-01-13T08:38:42.439327609Z 64 bytes from localhost (127.0.0.1): icmp_seq=1 ttl=64 time=0.028 ms
2022-01-13T08:38:43.440819276Z 64 bytes from localhost (127.0.0.1): icmp_seq=2 ttl=64 time=0.030 ms
2022-01-13T08:38:44.465250093Z 64 bytes from localhost (127.0.0.1): icmp_seq=3 ttl=64 time=0.071 ms
~
</code></pre>





<pre><code> </code></pre>
옵션|설명
:-----:|:---------:
