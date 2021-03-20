# DockerName: Locust runner
# Usecase: With locust runtime dependentance tools and testsuites
# Update: 2021-03-14
# Dependents:  python3
# Arch: x86-64
# Version: v0.5.0
# Editor：thomas
# Build In China

FROM opensuse/leap:15.2
# ENV JAVA_HOME=/spark/java/jre1.8.0_181  JRE_HOME=/spark/java/jre1.8.0_181  CLASSPATH=$JAVA_HOME/lib/:$JRE_HOME/lib/
# ENV PATH $PATH:$JAVA_HOME/bin:/usr/local/python37/bin
ENV PYTHON_HOME  /usr/bin/python3

WORKDIR /tmp

# 同步测试库和工具
COPY PerfBoard docker-build/jdk-8u281-linux-x64.rpm  /home/perfboard/

RUN mkdir /etc/zypp/repos.d/repo_bak && mv /etc/zypp/repos.d/*.repo /etc/zypp/repos.d/repo_bak/  \
    && zypper ar -fcg https://mirrors.bfsu.edu.cn/opensuse/distribution/leap/15.2/repo/non-oss/     NON-OSS  \
    && zypper ar -fcg https://mirrors.bfsu.edu.cn/opensuse/distribution/leap/15.2/repo/oss/         OSS  \
    && zypper ar -fcg https://mirrors.bfsu.edu.cn/opensuse/update/leap/15.2/non-oss/                UPDATE-NON-OSS    \              
    && zypper ar -fcg https://mirrors.bfsu.edu.cn/opensuse/update/leap/15.2/oss/                    UPDATE-OSS  \
    && zypper ar -fcg https://mirrors.aliyun.com/opensuse/distribution/leap/15.2/repo/non-oss       openSUSE-Aliyun-NON-OSS  \
    && zypper ar -fcg https://mirrors.aliyun.com/opensuse/distribution/leap/15.2/repo/oss           openSUSE-Aliyun-OSS  \
    && zypper ar -fcg https://mirrors.aliyun.com/opensuse/update/leap/15.2/non-oss                  openSUSE-Aliyun-UPDATE-NON-OSS  \
    && zypper ar -fcg https://mirrors.aliyun.com/opensuse/update/leap/15.2/oss                      openSUSE-Aliyun-UPDATE-OSS  \
    && zypper -q ref   \  
    && zypper update -y && zypper install -y gcc cmake git sudo python3 vim htop iputils curl busybox wget tar gzip unzip curl python3-devel    \
    && rpm -ivh /home/perfboard/jdk-8u281-linux-x64.rpm   \
    && curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py  \
    && python3 get-pip.py   \
    && ln -s /usr/bin/python3 /usr/bin/python  \
    && pip config set global.index-url https://repo.huaweicloud.com/repository/pypi/simple   \
    && pip config set install.trusted-host https://repo.huaweicloud.com  \
    && pip install python-dev-tools  \
    && pip install -U -r /home/perfboard/requirements.ini \ 
    && bzt /home/perfboard/example/jmeter/trace_user_footprint.jmx  \
    && rm -rf /tmp/* 

WORKDIR /home/

# port
EXPOSE 1099 8088 8089

# ENTRYPOINT 
CMD ["nohup", " jupyter", " lab", " --NotebookApp.token=''", " --port 8088", " --no-browser", " --ip=\'0.0.0.0\'", " --allow-root", " --NotebookApp.iopub_msg_rate_limit=1000000.0", " --NotebookApp.iopub_data_rate_limit=100000000.0", " --NotebookApp.notebook_dir=perfboard", " &"]

# Build  example
# docker build -f PerfBoard/Dockerfile . -t  harbor.apulis.cn:8443/testops/perfboard:latest
# docker push harbor.apulis.cn:8443/testops/perfboard:latest:latest
# Run example
# docker run -it --rm -d --name perfboard-jupyter -p 8088:8088  harbor.apulis.cn:8443/testops/perfboard:latest bash