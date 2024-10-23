# THREDDS Data Server (TDS) installation

Create main directory and change ownership to current user. It's much safer to run Tomcat (and TDS) as a regular user, instead of root.

```
sudo mkdir /usr/local/tds
sudo chown $USER:$USER /usr/local/tds
```

## Download Java

Download [OpenJDK Java 17](https://adoptium.net/temurin/releases/?os=linux&arch=x64&package=jdk&version=17)

Note: at the moment the latest OpenJDK 17 LTS version is 17.0.13+11

Move the JDK source to the main directory, extract and create a soft link

```
cd /usr/local/tds
mv ~/Downloads/OpenJDK17U-jdk_x64_linux_hotspot_17.0.13_11.tar.gz .
tar -xzvf OpenJDK17U-jdk_x64_linux_hotspot_17.0.13_11.tar.gz
ln -s jdk-17.0.13+11/ jdk
```

## Download Tomcat

Download [Tomcat 10](https://tomcat.apache.org/download-10.cgi)

Note: at the moment the latest Tomcat 10 version is 10.1.31

Note: the correct file is under `Core: tar.gz`

```
cd /usr/local/tds
mv ~/Downloads/apache-tomcat-10.1.31.tar.gz .
tar -xzvf apache-tomcat-10.1.31.tar.gz
ln -s apache-tomcat-10.1.31 tomcat
```

## Download TDS

Download the TDS war file from the [Unidata download page](https://downloads.unidata.ucar.edu/tds/)

Note: at the moment the latest TDS compatible with OpenJDK 17 and Tomcat 10 is the TDS Beta-Test Release 5.6.

Note: the file needs to be renamed to thredds##XXX.war to follow a Tomcat convention when creating the application URL. Everything after the ## will not be show in the URL.

```
cd /usr/local/tds
mv ~/Downloads/thredds-5.6-SNAPSHOT.war .
mv thredds-5.6-SNAPSHOT.war thredds##5.6.war
```

## Make some needed adjustments to run TDS

Copy the `setenv.sh` to `/usr/local/tds/tomcat/bin` and make it executable

```
cp ~/tds_installation/setenv.sh /usr/local/tds/tomcat/bin
chmod +x /usr/local/tds/tomcat/bin/setenv.sh
```

Note: by default, all the TDS content will be stored in `/usr/local/tds/content`. You can change this editing the `CONTENT_ROOT` variable in `setenv.sh`

Note: by default, the maximum allocated memory for TDS is only 4GB. You can change this editing the `-Xmx` flag in `setenv.sh`

Copy the `tomcat-users.xml` file to `/usr/local/tds/tomcat/conf`. This file defines the manager role, so the user can access the [Manager Application](http://localhost:8080/manager/html/) after Tomcat is started.

```
cp ~/tds_installation/tomcat-users.xml /usr/local/tds/tomcat/conf/
```

Note: by default, the username and password for the Tomcat Manager Application is `admin` and `admin123`, respectively. You can change this editing the `tomcat-users.xml` file.

Create some CLI shortcuts to make it easier to start and stop Tomcat. Edit the `~/.bashrc` file and add the following lines.

```
alias tomcat_start='/usr/local/tds/tomcat/bin/startup.sh'
alias tomcat_stop='/usr/local/tds/tomcat/bin/shutdown.sh'
```

After, reload the `~/.bashrc` file

```
source ~/.bashrc
```

## Start Tomcat

```
tomcat_start
```

Check if Tomcat is running [here](http://localhost:8080/) or with `ps aux | grep tomcat`.

Now check if the [Manager Application](http://localhost:8080/manager/html/) is accessible.  The application will request the username and password defined in `/usr/local/tds/tomcat/conf/tomcat-users.xml`.

## Deploy TDS

```
cd /usr/local/tds
cp thredds##5.6.war tomcat/webapps/
```

Note: it should also be possible to deploy TDS under the "WAR file to deploy" section in the [Manager Application](http://localhost:8080/manager/html/). Nonetheless, this fails with error

```
23-Oct-2024 17:26:52.275 SEVERE [http-nio-8080-exec-3] org.apache.catalina.core.ApplicationContext.log HTMLManager: FAIL - Deploy Upload Failed, Exception: [org.apache.tomcat.util.http.fileupload.impl.SizeLimitExceededException: the request was rejected because its size (97816974) exceeds the configured maximum (52428800)]
	java.lang.IllegalStateException: org.apache.tomcat.util.http.fileupload.impl.SizeLimitExceededException: the request was rejected because its size (97816974) exceeds the configured maximum (52428800)
```

being logged to `/usr/local/tds/tomcat/logs/manager.YYYY-mm-dd.log`, due to the size of the WAR file. So, the "CLI way" should be used instead.















