FROM postgres:18

COPY check.sh /check.sh
RUN chmod +x /check.sh

ENTRYPOINT ["/check.sh"]