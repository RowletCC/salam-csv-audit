FROM basemax/salam:0.4.4

WORKDIR /work
COPY --chown=10001:10001 src/ ./src/
COPY --chown=10001:10001 examples/ ./examples/
RUN salam build src/main.salam --output=csv-audit

ENV CSV_AUDIT_FILE=/work/examples/expenses.csv
ENTRYPOINT ["/work/csv-audit"]
