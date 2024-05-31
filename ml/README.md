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

## ClearML experiment tracking

To create a SSH port forwarding to the ClearML instance running on XL servers, run:

```bash
ssh -L 8008:0.0.0.0:8008 -L 8080:0.0.0.0:8080 -L 8081:0.0.0.0:8081  local.xmartlabs.com
```

Then visit http://localhost:8080

## TF Serving

Run this command to start TF Serving, which will start running on port 8501

```bash
docker run -p 8501:8501 -v $PWD/models/tf_model:/models/tf_model -e MODEL_NAME=tf_model -t tensorflow/serving
```

## TO DO:

- At the moment there is a bug in the keypoint classification model that we have to fix. There is a problem in the format of the data expected by the model, we have to convert the data before the model trains.
- Once the bug is fixed, we have to find a network architecture that fits. The current architecture was not tested, and you have to iterate on it.
- Add imageID to the CSV that is generated for debugging purposes.