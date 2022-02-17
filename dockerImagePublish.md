Docker 이미지를 개발자끼리 서로 공유하면 라이브러리의 번전 차이나 미들웨어의 구성 등과 같은 환경에 의존하는 일 없이 똑같은 환경에서 애플리케이션을 개발 가능.<br/>
이와 같이 Docker이미지를 공유하는 장치를 제공하는 것이 Docker레지스트리임.

## Docker 이미지의 자동 생성 및 공개 
#### Automated Build의 흐름
Docker Hub에서는 버전 관리 툴인 GitHub 및 Bitbusket과 연결하여 Dockerfile로부터 Docker이미지를 자동 생성하는 Automated Build 기능이 있음.<br/>
또는 Bitbusket에서 관리되는 Dockerfile을 바탕으로 Docker이미지를 자동으로 빌드하는 기능이 있음.

#### GitHub에 공개하기
작성한 Dockerfile을 github에 공개. 애플리케이션의 소스코드 관리와 똑같은 철차로 리포지토리를 만들어 Dockerfile을 공개.

#### Docker Hub의 링크 설정
Docker Hub에 로그인, DockerHub와 GitHub를 연결하기 위해 Docker Hub의 메인화면에서 계정 버튼을 클릭하고 settings -> Linked Accounts & services를 클릭, link github 버튼 클릭.<br/>
그 다음 GitHub계정과의 연결방법을 물어보므로 public and private (recommended)를 선택, 이것을 선택하면 GItHub의 프라이빗 리포지토리에서도 자동으로 빌드할 수 있음.<br />
또한 limited access를 선택한 경우는 퍼블릭 리보지토리 외에서는 수동으로 빌드<br />
select 버튼을 클릭하면 GitHub 계정과 연결.

#### Dockerfile의 빌드 
GitHub상의 Dockerfile을 바탕으로 하여 DockerHub에서 이미지를 생성.<br/>
먼저 Docker Hub에 로그인한 상태에서 create 버튼을 클릭, 리스트 메뉴에서 create automarted build를 클릭, 그다음 Dockerfile이 공개되어 있는 GitHub 계정을 선택.<br/>
계정을 선택하면 공개되어 있는 소스토드의 리포지토리가 표시되므로 리포지토리를 선택.<br/>

그 다음 만들 Docker 이미지의 정보를 등록하는 화면이 나오므로 다음과 같이 필요한 정보를 등록<br /><br />
1. Repository Namespace & Name(필수)<br />
Docker 이미지의 이름공간이 됨. 요기서는 로그인 계정을 선택<br />
Docker Hub에서 이미지를 공개할 때의 이름.
<br /><br />
2. Visibility(필수)<br />
Public으로 설정하면 Docker 이미지가 공개되어 누구나 이용할 수 있음.<br />
Private으로 설정하면 한정된 멤버만 이용할 수 있음
<br /><br />
3. Short Description(필수)<br />
이미지에 대한 간단한 설명을 기술
<br /> <br />

설정이 끝나면 create버튼을 클릭함. 리포지토리 화면으로 이동하므로 거기서 Build Settings를 클릭.<br/>
여기서 Docker이미지의 태그를 설정하고 Trigger버튼을 클릭하면 빌드가 시작됨.<br/>
빌드의 진척 상황은 Build Details탭에서 확인할 수 있음
<br/> <br/>
이로써 GitHub상의 DOckerfile을 바탕으로 Docker이미지가 만들어지고, Docker Hub상에 공개됨. <br/>
빌드가 완료되면 DockerHub리보지토리에 이미지가 추가됨.<br/>
또한 DockerHub리보지토리의 Dockerfile탭을 확인하면 빌드한 Dockerfile을 확인할 수 있음.<br />
또한 DockerHub의 Build Settings에서 When active, builds will happen automatically on pushes에 선택 표시를 하면 Dockerfile을 저장하고 있는 GitHub의 내용이 갱신된 경우 Docker 이미지의 빌드가 자동으로 일어남.<br/>
이것으로 DockerHub의 Automated Build기능을 사용하여 dockertext-cavityflow라는 이름의 이미지가 생성되고 인터넷 상에서 공유됨.

#### Docker 이미지 확인
먼저 DockerHub에서 이미지를 다운로드함. 
<pre><code> docker image pull [docker ID]/[container name]-[tag]</code></pre>
<br/>
DockerHub에서 다운로드한 파일을 <code> docker image ls</code> 명령을 사용하여 확인<br/>
상세정보를 확인하려면 <code> docker image inspect</code>명령을 실행.<br/>
<br/>

## Docker Registry를 사용한 프라이빗 레지스트리 구축
Docker 이미지에는 인터넷상에 공개하고 싶지 않은 정보가 포함되는 경우도 있음.<br/>
Docker이미지를 일원관리하기 위한 레지스틔를ㄹ 로컬 화ㄴ경에 구축하여 관리하는 방법에 대해 살펴볼거임.

#### 로컬 환경에 Docker 레지스트리 구축
Docker 레지스트리를 프라이빗 네트워크 안에서 구축하기 위해 Docker Store에 공개되어 있는 이미지인 registry를 사용.<br/>

*registry는 Version 0계열과 Version 2계열이 있으며, Version 0계열은 Python으로 2는 Go언어로 구축되어 있으며, 둘이 호환되지 않으므로 특졀한 요구 사랑이 없는경우 Version 2를 사용<br/>
<br/>
registry를 <code>docker image pull</code> 명령을 사용하여 로컬 환경에 다운로드함.<br/>
그 다음 다운로드한 registry이미지를 바탕으로 레지스트리용 컨테이너를 시작함(<code>docker container rum</code>).<br/>
<code>docker container ls</code>명령을 사용하여 컨테이너의 시작을 확인하므로써 프라이빗 레지스트리가 구축됨.

#### Docker 이미지 업로드
업로드하기 위한 이미지를 만들려면 다음과 같은 Dockerfile을 만듦.<br />
다음 샘플에서는 Jupyter Notebook의 베이스 이미지에 Numpy/Scipy/Matplotlib라는 4개의 라이브러리를 설치
<pre><code>FROM jupyter/base-notebook

ENV CONDA_DIR=/opt/conda

RUN conda install --quiet --yes \
        'numpy=1.13.*'\...
</code></pre>
<br/>
Dcokerfile을 <code> docekr build</code>명령으로 빌드하여 도커 이미지를 만듦.<br/>
프라이빗 네트워크 안의 Docker레지스트리에 업로드하려면 다음 규칙을 사용하여 이미지에 태그를 붙여야함.
<pre><code> docker image tag [로컬의 이미지명] [업로드할 레지스트리의 주소:포트번호]/[이미지명]</code></pre>
이것으로 이미지 업로드가 완료되었으므로 로컬에 저장되어 있는 이미지를 <code>docker image rm</code>를 사용해 삭제.<br/>
localhost의 포트에서 작동하는 레지스트리에 이미지가 등록됨.

#### Dcoker 이미지의 다운로드와 작동 확인
프라이빗 레지스트리상에 있는 이미지를 로컬 환경으로 다운로드하려면 <code>docker image pull</code> 명령을 실행
