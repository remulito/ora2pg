FROM remulito/oracle-instantclient:12.2.0.1
 
LABEL maintainer="remulito@yandex.ru"

RUN yum install make gcc gzip perl-DBI perl-CPAN tar perl-DBD-Pg postgresql-devel -y \
    && rm -rf /var/cache/yum \
    && mkdir /usr/lib/oracle/12.2/client64/network/admin -p
 
ENV ORACLE_HOME=/usr/lib/oracle/12.2/client64
ENV TNS_ADMIN=/usr/lib/oracle/12.2/client64/network/admin
ENV LD_LIBRARY_PATH=/usr/lib/oracle/12.2/client64/lib
ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/lib/oracle/12.2/client64/bin
 
RUN curl -L https://cpan.metacpan.org/authors/id/Z/ZA/ZARQUON/DBD-Oracle-1.76.tar.gz | (cd /tmp && tar -zxvf -) && mv /tmp/DBD-Ora* /tmp/DBD-Oracle \
    && cd /tmp/DBD-Oracle && perl Makefile.PL -l && make && make install \
    && mkdir /data \
    && curl -L /tmp/ora2pg.tar.gz https://github.com/darold/ora2pg/archive/v20.0.tar.gz | (cd /tmp && tar -zxvf -) && mv /tmp/ora2pg* /tmp/ora2pg \
    && cd /tmp/ora2pg && perl Makefile.PL && make && make install \
    && rm -rf /tmp/DBD-Oracle && rm -rf /tmp/ora2pg
VOLUME /data
 
