Docker 이미지를 개발자끼리 서로 공유하면 라이브러리의 번전 차이나 미들웨어의 구성 등과 같은 환경에 의존하는 일 없이 똑같은 환경에서 애플리케이션을 개발 가능.<br/>
이와 같이 Docker이미지를 공유하는 장치를 제공하는 것이 Docker레지스트리임.

## Docker 이미지의 자동 생성 및 공개 
#### Automated Build의 흐름
Docker Hub에서는 버전 관리 툴인 GitHub 및 Bitbusket과 연결하여 Dockerfile로부터 Docker이미지를 자동 생성하는 Automated Build 기능이 있음.<br/>
또는 Bitbusket에서 관리되는 Dockerfile을 바탕으로 Docker이미지를 자동으로 빌드하는 기능이 있음.

#### GitHub에 공개하기
작성한 Dockerfile을 github에 공개. 애플리케이션의 소스코드 관리와 똑같은 철차로 리포지토리를 만들어 Dockerfile을 공개.

#### Docker Hub의 링크 설정
Docker Hub에 로그인, DockerHub와 GitHub를 연결하기 위해 Docker Hub의 메인화면에서 계정 버튼을 클릭하고 settings -> Linked Accounts & services를 클릭, link github 버튼 클릭.
