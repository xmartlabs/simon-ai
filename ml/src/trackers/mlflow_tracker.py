from tensorflow import keras
import mlflow
from .tracker import Tracker


class MLFlowTracker(Tracker):

    def __init__(self, project_name, experiment_name):
        super().__init__(project_name, experiment_name)
        mlflow.set_experiment(experiment_name)
        mlflow.start_run()
        self._callback = MLFlowTrainTrackingCallback()

    def track_config(self, configs):
        mlflow.log_params(configs)

    def track_artifacts(self, filepath):
        mlflow.log_artifact(filepath)

    def log_scalar_metric(self, metric, series, iteration, value):
        mlflow.log_metric(metric, value, iteration)

    def finish_run(self):
        mlflow.end_run()

    def get_callback(self):
        return self._callback


class MLFlowTrainTrackingCallback(keras.callbacks.Callback):

    def on_epoch_end(self, epoch, logs=None):
        res = {}
        for k in logs.keys():
            res[k] = logs[k]
        mlflow.log_metrics(res, step=epoch)
