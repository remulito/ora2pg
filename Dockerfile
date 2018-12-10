FROM centos
 
MAINTAINER remulito <remulito@yandex.ru>

RUN yum update -y && yum install make gcc unzip perl-DBI perl-CPAN tar perl-DBD-Pg postgresql-devel -y && yum clean all \
    && mkdir /usr/lib/oracle/12.1/client64/network/admin -p
 
# From http://www.oracle.com/technetwork/topics/linuxx86-64soft-092277.html
#  Download the following three RPMs:
#    - oracle-instantclient12.1-basic-12.1.0.2.0-1.x86_64.rpm
#    - oracle-instantclient12.1-devel-12.1.0.2.0-1.x86_64.rpm
#    - oracle-instantclient12.1-sqlplus-12.1.0.2.0-1.x86_64.rpm 
ADD oracle-instantclient*.rpm /tmp/
 
RUN  yum -y localinstall /tmp/oracle-instantclient*.rpm && \
     rm -rf /var/cache/yum && \
     rm -f /tmp/oracle-instantclient*.rpm && \
     echo /usr/lib/oracle/12.1/client64/lib > /etc/ld.so.conf.d/oracle-instantclient12.1.conf && \
     ldconfig

ENV ORACLE_HOME=/usr/lib/oracle/12.1/client64
ENV TNS_ADMIN=/usr/lib/oracle/12.1/client64/network/admin
ENV LD_LIBRARY_PATH=/usr/lib/oracle/12.1/client64/lib
ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/lib/oracle/12.1/client64/bin
 
RUN curl -L https://cpan.metacpan.org/authors/id/Z/ZA/ZARQUON/DBD-Oracle-1.76.tar.gz | (cd /tmp && tar -zxvf -) && mv /tmp/DBD-Ora* /tmp/DBD-Oracle \
    && cd /tmp/DBD-Oracle && perl Makefile.PL -l && make && make install \
    && mkdir /data
 
VOLUME /data
 
RUN curl -L -o /tmp/ora2pg.zip https://github.com/darold/ora2pg/archive/v19.1.zip && (cd /tmp && unzip ora2pg.zip && rm -f ora2pg.zip) && mv /tmp/ora2pg* /tmp/ora2pg && (cd /tmp/ora2pg && perl Makefile.PL && make && make install)