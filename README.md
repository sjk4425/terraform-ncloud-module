# ncloud_terraform
* Naver Cloud Platform의 서비스 구현을 자동화하기 위한 Terraform 모듈입니다.
* Naver Cloud Platform 민간존의 한국 리전의 VPC 기준으로 Terraform 모듈을 생성하였습니다.


# 버전 기록
## V1.1
* initscript 모듈 추가
* 서버 생성에 관련된 모듈(server, server_img, asg) init script 적용가능하도록 기능 추가

## V1.0
* 최초 업로드


# 모듈 기능
| 모듈 이름 | 기능 설명 |
|--|--|
| vpc | VPC 생성 |
| subnet | Subnet 생성, NACL 생성, natgw 모듈에서 생성한 Route Table 부착(일반용 Private Subnet 한정) |
| natgw | Nat Gateway 생성, Route Table 생성 및 Nat Gateway 라우팅 설정 |
| loginkey | Server 로그인 시 필요한 인증키 생성 및 저장  |
| acg | ACG 생성 |
| initscript | init script 생성 |
| server | Network Interface 생성, Server 생성, Block Storage 생성 및 부착(default는 생성 안함), Public IP 생성 및 부착(default는 생성 안함) |
| server_img | Network Interface 생성, 내 서버 이미지를 이용한 Server 생성, Block Storage 생성 및 부착(default는 생성 안함), Public IP 생성 및 부착(default는 생성 안함) |
| acgrule | ACG InBound Rule 설정, OutBound Port 모두 Open |
| lb | LB 생성(ALB, NPLB, NLB) |
| targetgroup| Target Group 생성 및 할당할 서버 지정 |
| asg | Auto Scaling Group 생성, Auto Scaling Group 정책 or 일정 설정 |
| nas | NAS 생성 및 접근제어 설정 |
| kubernetes | Naver Kubernetes Service Cluster 생성, Node Pool 설정 |

# main 사용 변수
| 변수이름 | 설명 |
|--|--|
| access_key | API Access Key 입력 |
| secret_key | API Secret Key 입력 |
| region | 사용할 Region 지정(KR..) |
| site | 사용할 Site 지정(pub, gov, fin) |
* region : 사용할 Region 설정
* site
  * pub : 민간존
  * gov : 공공존
  * fin : 금융존

# 모듈 내 사용 변수
## vpc
| 변수이름 | 설명 |
|--|--|
| name | VPC 이름 설정 |
| ipv4_cidr_block | 생성할 VPC의 IP대역(10.0.0.0/24, 172.16.0.0/24, 192.168.0.0/24) |

## subnet
| 변수이름 | 설명 |
|--|--|
| vpc_no | VPC ID 값 입력 |
| zone | Subnet 생성할 Zone 선택(민간존 예시:KR-1,KR-2...) |
| subnet_CIDR | Subnet IP 대역 |
| subnet_type | Subnet 타입 설정(Public, Private) |
| subnet_name | Subnet 이름 정의 |
| usage_type | Subnet 종류 선택_일반,LB용(GEN, LOADB) |
| route_table_no | Subnet에 정의할 Route Table ID 정의 |
* usage_type
  * 일반 서버용 Subnet: GEN
  * Load Balancer용 Subnet : LOADB

## natgw
| 변수이름 | 설명 |
|--|--|
| vpc_no | Nat Gateway를 생성할 VPC ID 입력 |
| natgw_name | Nat Gateway 이름 설정 |
| zone | Nat Gateway를 생성할 Zone 설정(예시 : KR-1, KR-2) |

## loginkey
| 변수이름 | 설명 |
|--|--|
| key_name | 인증키 이름 설정 |

## acg
| 변수이름 | 설명 |
|--|--|
| acg_name | ACG 이름 설정 |
| vpc_no | ACG를 생성할 VPC ID 입력 |
| acg_description | ACG 메모 입력 |

## initscript
| 변수이름 | 설명 |
|--|--|
| init_name | Script 이름 설정 |
| file_name | Script 내용이 있는 파일 지정(Terraform 루트 디렉터리에 저장) |

## server
| 변수이름 | 설명 |
|--|--|
| access_control_groups | Server에 사용할 ACG 목록 |
| server_name | Server 이름 설정 |
| loginkeyname | Server에 사용할 인증키 이름 |
| image_name | Server에 생성할 Image 설정 |
| create_num | Server 생성 갯수 설정 |
| subnet_id | Server를 생성할 Subnet 지정 |
| product_type | Server 타입 지정(HICPU, HIMEM, STAND, GPU, CPU) |
| product_code | Server의 Storage 타입 설정(HDD, SSD, 기본값 = SSD) |
| cpu_count | CPU 갯수 지정 |
| memory_size | Memory 크기 지정(GB 단위) |
| server_description | Server 메모 입력 |
| is_protect_server_termination | Server 반납보호 설정(true, false, 기본값 = false) |
| init_script_no | init script 사용시 해당 init script ID 입력(기본은 사용안함) |
| pubip | Public IP 사용 여부 설정(true,false) |
| size | Block Storage 크기(GB 단위, 기본값 = 0) |
| disk_detail_type | Block Storage 타입 지정(HDD, SSD, 기본값 = SSD) |
* product_type
  * Server를 생성할 타입 지정
  * 지정 가능한 Type는 5개이며, 해당 변수는 다음과 같음
    * HICPU : High CPU
    * STAND : Standard
    * HIMEM : High-Memory
    * GPU : GPU
    * CPU : CPU Intensive


## server_img
| 변수이름 | 설명 |
|--|--|
| access_control_groups | Server에 사용할 ACG 목록 |
| server_name | Server 이름 설정 |
| loginkeyname | Server에 사용할 인증키 이름 |
| image_name | Server에 생성에 사용할 내 서버 이미지 이름 입력 |
| create_num | Server 생성 갯수 설정 |
| subnet_id | Server를 생성할 Subnet 지정 |
| product_type | Server 타입 지정(HICPU, HIMEM, STAND, GPU, CPU) |
| product_code | Server의 Storage 타입 설정(HDD, SSD, 기본값 = SSD) |
| cpu_count | CPU 갯수 지정 |
| memory_size | Memory 크기 지정(GB 단위) |
| server_description | Server 메모 입력 |
| is_protect_server_termination | Server 반납보호 설정(true, false, 기본값 = false) |
| init_script_no | init script 사용시 해당 init script ID 입력(기본은 사용안함) |
| pubip | Public IP 사용 여부 설정(true,false) |
| size | Block Storage 크기(GB 단위, 기본값 = 0) |
| disk_detail_type | Block Storage 타입 지정(HDD, SSD, 기본값 = SSD) |
* product_type
  * Server를 생성할 타입 지정
  * 지정 가능한 Type는 5개이며, 해당 변수는 다음과 같음
    * HICPU : High CPU
    * STAND : Standard
    * HIMEM : High-Memory
    * GPU : GPU
    * CPU : CPU Intensive
	

## acgrule
| 변수이름 | 설명 |
|--|--|
| access_control_group_no | ACG Rule을 설정할 ACG 지정 |
| acg_rule_inbound | ACG Rule 설정(InBound) |
| ipblock_chk | ACG Rule 설정 시 Source가 'IP주소' 인지 'ACG'인지 체크 용도(true=IP주소, false=ACG) |
* OutBound의 경우, 모든 Port Open


## targetgroup
| 변수이름 | 설명 |
|--|--|
| vpc_no | Target Group를 생성할 VPC ID 입력 |
| protocol | Target Group 프로토콜 지정(HTTP, HTTPS, NPLB, NLB) |
| port | Target이 서비스 중인 포트 번호 설정 |
| tg_name | Target Group 이름 지정 |
| tg_description | Target Group 메모 입력 |
| health_check_protocol | Health Check에 사용할 Protocol 지정(HTTP, HTTPS, TCP) |
| health_check_port | Health Check에 사용할 Port 설정 |
| algorithm_type | LB 알고리즘 설정(RR, SIPHS, LC)|
| http_method | ALB에서 Health Check에 사용할 Method 설정(GET, HEAD) |
| url_path | ALB에서 Health Check에 사용할 경로 설정 |
| cycle | Health Check 주기 설정 |
| up_threshold | Health Check 정상 임계값 설정 |
| down_threshold | Health Check 실패 임계값 설정 |
| target_no_list_chk | Target Group에 Target Server 할당 여부(ture=할당, false=비할당) |
| target_no_list | Target Group에 할당할 Target Server 목록 설정 |

* Protocol
  * Appllication LoadBalancer 용 Target Group : HTTP, HTTPS
  * Network Proxy LoadBalancer 용 Target Group : NPLB
  * Network LoadBalancer 용 Target Group : NLB
* Application LoadBalnacer용 Target Group 에서만 설정 가능한 변수 : http_method, url_path
* algorithm_type
  * RR : Round Robin
  * SIPHS : Source Ip Hash
  * LC : Least Connection

## lb
| 변수이름 | 설명 |
|--|--|
| lb_name | LB 이름 지정 |
| lb_network_type | LB 네트워크 타입 지정(PUBLIC, PRIVATE) |
| lb_type | LB 종류 지정(APPLICATION, NETWORK_PROXY, NETWORK) |
| throughput_type | LB 부하처리 성능 선택(SMALL, MEDIUM, LARGE) |
| subnet_no_list | LB를 생성할 Subnet 목록 설정 |
| lb_description | LB 메모 입력 |
| listener_protocol | LB Listener의 Protocol 지정(HTTP, HTTPS, TCP, TLS)  |
| listener_port | LB Listener의 Port 지정  |
| certificate_no | Certificate Manager에 등록한 SSL 인증서 ID |
| tls_min_version_type | TLS 최소 지원버전 선택(TLS10, TLS11, TLS12) |
| target_group_no | LB에 할당할 Target Group ID |
* lb_network_type
  * PUBLIC : 공인
  * PRIVATE : 사설
* listener_protocol
  * Application Load Balancer : HTTP, HTTPS(SSL 사용시)
  * Network Proxy Load Balancer : TCP, TLS(SSL 사용시)
  * Network Load Balancer : TCP
* HTTPS 또는 TLS를 사용할 경우, Console에서 Certificate Manager에 먼저 SSL 인증서 등록 필수
  * Certificate Manager에서 SSL 인증서 등록의 경우, NCloud_Terraform에서 지원 X


## asg
### Launch Configuration 생성 및 설정
| 변수이름 | 설명 |
|--|--|
| asg_conf_name | Launch Configuration 이름 설정 |
| image_name | Auto Scaling Group에 사용할 Server Image 지정 |
| login_key_name | Server에 사용할 인증키 이름 |
| init_script_no | init script 사용시 해당 init script ID 입력(기본은 사용안함) |
| product_type | Server 타입 지정(HICPU, HIMEM, STAND, GPU, CPU) |
| product_code | Server의 Storage 타입 설정(HDD, SSD, 기본값 = SSD) |
| cpu_count | CPU 갯수 지정 |
| memory_size | Memory 크기 지정(GB 단위) |


### Auto Scaling Group 생성 및 설정
| 변수이름 | 설명 |
|--|--|
| asg_name | Auto Scaling Group 이름 설정 |
| subnet_no | Auto Scaling Group으로 생성되는 Server의 Subnet 설정 |
| access_control_groups | Auto Scaling Group으로 생성되는 Server에 할당할 ACG 목록  |
| health_check_type_code | Auto Scaling Group의 Health Check 방법(SVR=서버, LOADB=로드밸런서) |
| health_check_grace_period | Health Check 보류 기간 설정 |
| min_size | Auto Scaling 그룹의 최소 서버 수 |
| max_size | Auto Scaling 그룹의 최대 서버 수 |
| desired_capacity | Auto Scaling 그룹의 기대 서버 수 |
| server_name_prefix | Auto Scaling 서버에 붙는 접두사 |
| target_group_list | Auto Scaling Group을 할당할 Target Group 목록 지정 |

### Auto Scaling Group 정책 설정
| 변수이름 | 설명 |
|--|--|
| policy_chk | 정책 or 일정 사용 여부(true=정책, false=일정) |
| policy_name | 정책 이름 설정 |
| adjustment_type_code | Scaling 설정(CHANG=증감변경, EXACT=고정값, PRCNT=비율변경) |
| scaling_adjustment | Scaling 조정값 설정 |
* policy_chk : 정책 또는 일정 선택
  * true = 정책 설정
  * false = 일정 설정 
* policy_name : 정책 또는 일정 이름 설정(공통으로 사용)

### Auto Scaling Group 일정 설정
| 변수이름 | 설명 |
|--|--|
| policy_chk | 정책 or 일정 사용 여부(true=정책, false=일정) |
| policy_name | 정책 이름 설정 |
| schdule_min_size | Scaling 실행할 최소 용량 |
| schdule_max_size | Scaling 실행할 최대 용량 |
| schdule_desired_capacity | Scaling 실행할 기대 용량 |
| start_time | 일정을 시작할 날짜 및 시간 입력 |
| end_time | 반복을 종료할 날짜 및 시간 입력 |
| recurrence | 반복설정(Linux Cronjob 값과 동일한 규칙으로 설정) |
* policy_chk : 정책 또는 일정 선택
  * true = 정책 설정
  * false = 일정 설정 
* policy_name : 정책 또는 일정 이름 설정(공통으로 사용)
* start_time 및 end_time 시간 입력 포맷 형식
  * 타입 : yyyy-MM-ddTHH:mm:ssZ
  * 예시 : 2023-03-22T15:00:00+0900
* recurrence : 반복 설정으로 Cronjob 과 동일한 규칙으로 입력
  * 예시 : 0 18 * * 1-5

## nas
| 변수이름 | 설명 |
|--|--|
| volume_name_postfix | NAS 볼륨 이름 설정 |
| volume_size | NAS 볼륨 크기 지정(GB단위) |
| volume_allotment_protocol_type | NAS 볼륨 타입 지정(NFS,CIFS) |
| server_instance_no_list | NAS 볼륨 접근제어 설정(허용할 서버 목록 입력) |

## kubernetes
### Naver Kubernetes Service Cluster 생성
| 변수이름 | 설명 |
|--|--|
| k8s_version | 생성할 Kubernetes Service 버전 선택(1.22.9, 1.23.9) |
| vpc_no | Kubernetes Service를 생성할 VPC ID 지정 |
| subnet_no_list | Kubernetes Service를 생성할 Subnet 지정 |
| lb_private_subnet_id | Kubernetes Service에 사용할 LB용 Subnet 지정 |
| loginkeyname | Kubernetes Service Node에 사용할 인증키 지정 |
| zone | Kubernetes Service를 생성할 Zone 설정(예시 : KR-1, KR-2..) |
| k8s_name | Kubernetes Service 이름 설정 |
| audit | CLA에서 Audit Log 사용 여부 설정(true, false) |
| cluster_type | Kubernetes Service의 최대 Node 수 지정 |
| cluster_type_map | 위의 cluster_type의 변수를 편하게 하기 위한 Custom 설정(10, 50) |
* cluster_type
  * 10ea = SVR.VNKS.STAND.C002.M008.NET.SSD.B050.G002
  * 50ea = SVR.VNKS.STAND.C004.M016.NET.SSD.B050.G002
* cluster_type_map
  * 10 입력 시, 'SVR.VNKS.STAND.C002.M008.NET.SSD.B050.G002' 로 변경되게끔 설정
  * 50 입력 시, 'SVR.VNKS.STAND.C004.M016.NET.SSD.B050.G002' 로 변경되게끔 설정

### Naver Kubernetes Service Node Pool 생성 및 설정
| 변수이름 | 설명 |
|--|--|
| node_count | 생성할 Node 갯수 설정 |
| subnet_id | Node 들이 생성될 Subnet ID 지정 |
| auto_scaling_enabled | Node Pool에서 Auto Scaling 사용 여부(true, false) |
| min | Auto Scaling 사용 시, 최소 Node 갯수 |
| max | Auto Scaling 사용 시, 최대 Node 갯수 |
| image_name | Node 생성 시, 사용할 Server Image 지정(Ubuntu Server 16.04 (64-bit), Ubuntu Server 18.04 (64-bit), Ubuntu Server 20.04 (64-bit)) |
| cpu_count | Node의 CPU 갯수 설정 |
| memory_size | Node의 Memory 크기 설정(GB 단위) |
| product_type | Node의 Server 타입 지정(HICPU, HIMEM, STAND, GPU, CPU) |
* image_name
  * Kubernetes Service의 Node Pool 생성 시 사용 가능한 OS Image는 Ubuntu Server
  * Naver Kubernetes Service에 사용가능한 OS는 다음과 같음
    * Ubuntu Server 16.04 (64-bit)
    * Ubuntu Server 18.04 (64-bit)
    * Ubuntu Server 20.04 (64-bit)
* product_type
  * Node Pool에 생성할 Node 들의 서버 타입 지정
  * 지정 가능한 Type는 5개이며, 해당 변수는 다음과 같음
    * HICPU : High CPU
    * STAND : Standard
    * HIMEM : High-Memory
    * GPU : GPU
    * CPU : CPU Intensive


# 외부 참조
* [Ncloud Terraform](https://registry.terraform.io/providers/NaverCloudPlatform/ncloud/latest/docs)