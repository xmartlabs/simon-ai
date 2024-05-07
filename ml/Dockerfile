FROM tensorflow/tensorflow:2.15.0-jupyter
# uncomment for gpu use
# FROM tensorflow/tensorflow:2.15.0-gpu-jupyter

WORKDIR /app
COPY requirements.txt /app
RUN pip install --ignore-installed -r  requirements.txt

ENTRYPOINT cd src && jupyter notebook --ip=0.0.0.0
