# Simon AI ML Model

Welcome to the Simon AI machine learning model

## Instructions


* Download the ASL alphabet dataset by running:

```bash
./download_asl_dataset.sh
```

* Build the docker container:

```bash
./build.sh
```

* Start the docker container with the Jupyter Notebook:

```bash
./start.sh
```

* Follow the instructions to access the notebook on your browser


## MLflow experiment tracking

To see results from the tracker run inside the container

```bash
cd /app/src
mlflow ui --host 0.0.0.0
```

Then visit http://localhost:5000


## TF Serving

Run this command to start TF Serving, which will start running on port 8501

```bash
docker run -p 8501:8501 -v $PWD/models/tf_model:/models/tf_model -e MODEL_NAME=tf_model -t tensorflow/serving
```