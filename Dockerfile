FROM python:3-alpine

WORKDIR /opt/poifier

COPY . .

RUN pip3 install --upgrade pip

RUN pip3 install -r requirements.txt

CMD [ "/bin/sh", "/opt/poifier/run-poifier.sh" ]
