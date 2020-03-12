FROM python:3.5
EXPOSE 5000
COPY . /app
WORKDIR /app
COPY requirements.txt /app/
ENV FLASK_RUN_HOST 0.0.0.0
RUN echo "start to install requirements.txt"
RUN cat requirements.txt
RUN pip install --no-cache-dir pymongo[srv]
RUN pip install -r requirements.txt
RUN pip install dnspython
ENTRYPOINT ["python"]
CMD ["manage.py", "run"]
