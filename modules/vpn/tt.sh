
## init-vpn 후 들어가서 직접 실행해야하는 부분

OVPN_DATA="/home/ubuntu/ovpn-data"

sudo docker run -v $OVPN_DATA:/etc/openvpn --log-driver=none --rm kylemanna/openvpn ovpn_genconfig -u udp://vpn.test.com:10068 

# 여기서 비밀번호 입력 요구, 비밀번호 잘 기억할것
sudo docker run -v $OVPN_DATA:/etc/openvpn --log-driver=none --rm -it kylemanna/openvpn ovpn_initpki

sudo docker run -v $OVPN_DATA:/etc/openvpn --log-driver=none --rm -it kylemanna/openvpn easyrsa build-client-full hwanseok nopass
sudo docker run -v $OVPN_DATA:/etc/openvpn --log-driver=none --rm kylemanna/openvpn ovpn_getclient hwanseok > hwanseok.ovpn

sudo docker run -v $OVPN_DATA:/etc/openvpn --name=vpn -d -p 10068:1194/udp --cap-add=NET_ADMIN kylemanna/openvpn
sudo docker update --restart=always vpn

scp -i vpn-key.pem ubuntu@서버주소:/home/ubuntu/vpn파일 C:\Users\82106\vpn파일
