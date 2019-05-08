#chmod u+x hadoopSingleNodeInstaller.sh
#dos2unix hadoopSingleNodeInstaller.sh
echo "Hadoop Single Node Cluster Installation"

echo

read -p "Continue Installing (Y\N)?" isContinue

if [ $isContinue = "Y" ]
then
	echo "Installation will proceed"
	sudo apt-get update
	sudo apt install openjdk-8-jdk-headless
	echo "Java Development Kit Installed"
	java -version
	echo "Creating separate group for Hadoop Cluster Setup"
	addgroup hadoop
	sudo apt-get purge openssh-server -y
	sudo apt-get purge openssh-client -y
	sudo apt-get install openssh-client -y
	sudo apt-get install openssh-server -y
	#echo "Do you wish to create separate user for Hadoop Cluster Installation"
	#read -p "(Y\N)?" isNewUser
	#if [ $isNewUser = "Y" ]
	#then
	#	echo "Creating a new user to operate hadoop cluster"
	#	read -p "Enter username of new user to be created:" username
	#	adduser --ingroup test1 $username
	#	adduser $username sudo
	#fi
	#echo "Please Login Again"
	#read -p "Username:" username
	#su - $username
	#sudo -u $username ssh-keygen -t rsa -P ""
	#sudo -u $username cat $HOME/.ssh/id_rsa.pub >> $HOME/.ssh/authorized_keys
	#sudo -u $username ssh localhost
	ssh-keygen -t rsa -P ""  -f $HOME/.ssh/hadoop_key
	cat $HOME/.ssh/hadoop_key.pub >> $HOME/.ssh/authorized_keys
	#ssh localhost
	echo "SSH conenction has been set up"
	echo "Downloading Hadoop version 2.7"
	echo "Removing existing versions if exist"
	rm hadoop-2.7.3.tar.gz
	wget https://archive.apache.org/dist/hadoop/core/hadoop-2.7.3/hadoop-2.7.3.tar.gz
	echo "hadoop downloaded"
	tar -xvf hadoop-2.7.3.tar.gz
	echo "Adding environment variables to bashrc file"
	echo 'export HADOOP_HOME='$PWD'/hadoop-2.7.3' >> ~/.bashrc
	echo 'export HADOOP_CONF_DIR='$PWD'/hadoop-2.7.3/etc/hadoop' >> ~/.bashrc
	echo 'export HADOOP_MAPRED_HOME='$PWD'/hadoop-2.7.3' >> ~/.bashrc
	echo 'export HADOOP_COMMON_HOME='$PWD'/hadoop-2.7.3' >> ~/.bashrc
	echo 'export HADOOP_HDFS_HOME='$PWD'/hadoop-2.7.3' >> ~/.bashrc
	echo 'export YARN_HOME='$PWD'/hadoop-2.7.3' >> ~/.bashrc
	echo 'export PATH=$PATH:'$PWD'/hadoop-2.7.3/bin' >> ~/.bashrc
	echo 'export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64' >> ~/.bashrc
	echo 'export PATH=/usr/lib/jvm/java-8-openjdk-amd64/bin:$PATH' >> ~/.bashrc
	source ~/.bashrc
	echo "Bashrc Updated"
	echo "Adding jdk path to hadoop-env.sh"
	echo "export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64" >> $PWD/hadoop-2.7.3/etc/hadoop/hadoop-env.sh
	rm $PWD/hadoop-2.7.3/etc/hadoop/core-site.xml
	rm $PWD/hadoop-2.7.3/etc/hadoop/hdfs-site.xml
	rm $PWD/hadoop-2.7.3/etc/hadoop/mapred-site.xml
	rm $PWD/hadoop-2.7.3/etc/hadoop/yarn-site.xml
	mkdir $PWD/hadoopdata
	mkdir $PWD/hadoopdata/datanode
	mkdir $PWD/hadoopdata/namenode
	cp $PWD/xml_files/core-site.xml $PWD/hadoop-2.7.3/etc/hadoop/core-site.xml
	cp $PWD/xml_files/hdfs-site.xml $PWD/hadoop-2.7.3/etc/hadoop/hdfs-site.xml
	cp $PWD/xml_files/mapred-site.xml $PWD/hadoop-2.7.3/etc/hadoop/mapred-site.xml
	cp $PWD/xml_files/yarn-site.xml $PWD/hadoop-2.7.3/etc/hadoop/yarn-site.xml
	echo '<property>
 		<name>dfs.namenode.name.dir</name>
             			<value>'$PWD'/hadoopdata/namenode</value>
          			</property>' >> $PWD/hadoop-2.7.3/etc/hadoop/hdfs-site.xml
	
	 echo '<property>
	 		<name>dfs.datanode.name.dir</name>
             			<value>'$PWD'/hadoopdata/datanode</value>
          			</property>' >> $PWD/hadoop-2.7.3/etc/hadoop/hdfs-site.xml
	echo '</configuration>' >> $PWD/hadoop-2.7.3/etc/hadoop/hdfs-site.xml
	echo "Hadoop Configuration successfull"

	echo "Formatting Hadoop NameNode"
	$PWD/hadoop-2.7.3/bin/hadoop namenode -format
	$PWD/hadoop-2.7.3/sbin/./start-all.sh
	jps

else
	echo "Installation stopped"
fi
