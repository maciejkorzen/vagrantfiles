#!/usr/bin/env bash

apt-get update
aptitude install -y python-pip gunicorn
pip install httpbin
useradd -m httpbin-app
# Set password to random value.
echo "httpbin-app:$(dmesg | shuf | tr -d '\n' | cut -b 30-60)" | chpasswd

cat << EOF > /etc/gunicorn.d/httpbin
CONFIG = {
    'mode': 'wsgi',
    'working_dir': '/home/httpbin-app',
    'user': 'httpbin-app',
    'group': 'httpbin-app',
    'args': (
        '--bind=0.0.0.0:8000',
        '--workers=4',
        'httpbin:app',
    ),
}
EOF
service gunicorn restart
