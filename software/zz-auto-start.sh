#!/bin/sh

work_dir=~/zz-auto-start
core_dir=$work_dir/core
core_bin=$core_dir/start.sh
mkdir -p $core_dir

myname=`whoami`

sudo tee /lib/systemd/system/zz-auto-start.service <<EOF
[Unit]
Description=zz auto start service

[Service]
Type=idle
ExecStart=$core_bin
User=$myname

[Install]
WantedBy=multi-user.target
EOF

tee $core_bin <<EOF
#!/bin/sh
sleep 5
cd $work_dir
for file in ./*; do
  if [ ! -d "\$file" ]; then
    echo \$file
    \$file &
    sleep 1
  fi
done
sleep 3650d
EOF

chmod +x $core_bin

sudo systemctl enable zz-auto-start.service
sudo systemctl daemon-reload
