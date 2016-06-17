$prepare = <<SCRIPT
# repo for libgeoip
add-apt-repository -y ppa:maxmind/ppa
apt-get update
apt-get install -y git autoconf libncursesw5-dev libgeoip-dev libtokyocabinet-dev zlib1g-dev libbz2-dev
echo "cd /vagrant && autoreconf -fiv && ./configure --enable-tcb=btree --enable-geoip --enable-utf8 && make && make install" > /usr/local/bin/build-goaccess
chmod +x /usr/local/bin/build-goaccess
# create command to build goaccess
build-goaccess
goaccess --version
# PERSO AREA
wget https://bootstrap.pypa.io/get-pip.py -O /tmp/get-pip.py
python /tmp/get-pip.py
export LANGUAGE=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
locale-gen en_US.UTF-8
dpkg-reconfigure locales
pip install awscli
SCRIPT

Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/trusty64"

  config.vm.provision "shell", inline: $prepare

  config.vm.network "forwarded_port", guest: 80, host: 8888

  config.vm.provider "virtualbox" do |v|
    v.name   = "goaccess"
    v.memory = 4096
  end
end

# aws configure
#   eu-west-1
# aws s3 ls s3://cf-logs.gyg.io
# aws s3 cp s3://cf-logs.gyg.io/E32062QG6Q1PD3.2016-03-23-09.ecd1f26a.gz

#zcat -f ./*.gz | goaccess --keep-db-files --load-from-disk -a > /vagrant/report.html

#To preserve the data at all times, --keep-db-files must be used.
