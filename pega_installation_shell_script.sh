

##  Install oracle jdk 

cd /opt/software
yum install -y wget expect 
chmod a+x jdk-11.0.19_linux-x64_bin.rpm
rpm -ivh jdk-11.0.19_linux-x64_bin.rpm
# The biggest difference in jdk is that the JAVA_HOME would have /usr/java/jdk-11 instead of /usr/java/jdk-11-19 , so keep that in mind and change all
echo "export JAVA_HOME=/usr/java/jdk-11" >> ~/.bash_profile
source ~/.bash_profile




### Install postgresql database  

systemctl stop postgresql-11
systemctl disable postgresql-11
yum remove -y postgresql
yum -qy module disable postgresql
yum clean all
rm -rf /var/lib/pgsql/11/data
#yum -y install https://download.postgresql.org/pub/repos/yum/reporpms/EL-8-x86_64/pgdg-redhat-repo-latest.noarch.rpm
cd /opt/software
wget  https://download.postgresql.org/pub/repos/yum/reporpms/EL-8-x86_64/pgdg-redhat-repo-latest.noarch.rpm
rpm -ivh /opt/software/pgdg-redhat-repo-latest.noarch.rpm


rpm -ivh /opt/software/pljava-12-1.5.5-1.rhel8.x86_64.rpm
yum -y install  postgresql11 postgresql11-server postgresql11-contrib 
yum install -y pljava-11
#cat  /opt/software/postgresql-11-setup >  /usr/pgsql-11/bin/postgresql-11-setup
sudo /usr/pgsql-11/bin/postgresql-11-setup initdb


#mkdir -p /data/pgsql
#chown -R postgres:postgres /data/pgsql
#chmod 700 /data/pgsql

cd /opt/software
cp /var/lib/pgsql/11/data/pg_hba.conf /var/lib/pgsql/11/data/pg_hba.conf.bak
cp /var/lib/pgsql/11/data/postgresql.conf  /var/lib/pgsql/11/data/postgresql.conf.bak
cat /opt/software/pg_hba.conf > /var/lib/pgsql/11/data/pg_hba.conf 
cat /opt/software/postgresql.conf > /var/lib/pgsql/11/data/postgresql.conf

echo "pgadmin2023!" | passwd --stdin postgres
# The biggest difference in jdk is that the JAVA_HOME would have /usr/java/jdk-11 instead of /usr/java/jdk-11-19 , so keep that in mind and change all
echo "export JAVA_HOME=/usr/java/jdk-11" >> /var/lib/pgsql/.bash_profile
source /var/lib/pgsql/.bash_profile

systemctl start postgresql-11
systemctl enable postgresql-11



rm /lib/libjvm.so
# The biggest difference in jdk is that the JAVA_HOME would have /usr/java/jdk-11 instead of /usr/java/jdk-11-19 , so keep that in mind and change all
ln -s /usr/java/jdk-11/lib/server/libjvm.so /lib/libjvm.so

mkdir /usr/pgsql-11/lib64
mkdir /var/lib/pgsql/11/lib64




chmod 755 /usr/pgsql-11/lib64/*
chmod 755 /var/lib/pgsql/11/lib64/*
chmod 755 /usr/pgsql-11/lib64/pljava.jar
chmod 755 /var/lib/pgsql/11/lib64/pljava.so


systemctl restart postgresql-11


## now we need to create database schemas, roles, rules etc.


cd /var/lib/pgsql

sudo -u postgres psql -U postgres -d postgres -c "create user pegarole with password 'welcome';"
sudo -u postgres psql -U postgres -d postgres -c "alter user pegarole with password 'pgadmin2023!';"
sudo -u postgres psql -U postgres -d postgres -c "alter user postgres with password 'pgadmin2023!';"

sudo -u postgres psql -U postgres -d postgres -c "create database pegadb;"
sudo -u postgres psql -U postgres -d postgres -c "GRANT ALL PRIVILEGES ON DATABASE pegadb to pegarole;"
sudo -u postgres psql -U postgres -d postgres -c "GRANT ALL PRIVILEGES ON DATABASE pegadb to postgres;"
sudo -u postgres psql -U postgres -d pegadb -c "CREATE SCHEMA IF NOT EXISTS PEGARULES AUTHORIZATION pegarole;"
sudo -u postgres psql -U postgres -d pegadb -c "CREATE SCHEMA IF NOT EXISTS PEGADATA AUTHORIZATION pegarole;"




systemctl start firewalld 
systemctl enable firewalld

firewall-cmd --permanent --add-service=ssh
firewall-cmd --permanent --add-service=postgresql
firewall-cmd --permanent --add-port=8089/tcp
firewall-cmd --permanent --add-port=25/tcp

firewall-cmd --reload

# to show all rules 
firewall-cmd --list-all







