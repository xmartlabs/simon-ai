FROM tensorflow/tensorflow:2.4.1-jupyter
# uncomment for gpu use
# FROM tensorflow/tensorflow:2.4.1-gpu-jupyter

WORKDIR /app
COPY requirements.txt /app
RUN pip install --ignore-installed -r  requirements.txt

ENTRYPOINT cd src && jupyter notebook --ip=0.0.0.0
