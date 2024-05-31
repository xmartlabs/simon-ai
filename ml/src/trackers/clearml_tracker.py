import queue
from clearml import Task, Logger
from .tracker import Tracker


class ClearMLTracker(Tracker):

    def __init__(self, project_name=None, experiment_name=None):
        self.task = Task.current_task() or Task.init(project_name=project_name, task_name=experiment_name)
        self.logger = Logger.current_logger()

    def execute_remotely(self, queue_name):
        self.task.execute_remotely(queue_name=queue_name)

    def log_scalar_metric(self, metric, series, iteration, value):
        self.logger.report_scalar(metric, series, iteration=iteration, value=value)

    def log_chart(self, title, series, iteration, figure):
        self.logger.report_plotly(title=title, series=series, iteration=iteration, figure=figure)
    
    def track_artifacts(self, artifact_name, artifact):
        self.logger.register_artifact(name=artifact_name, artifact=artifact)

    def finish_run(self):
        self.task.mark_completed()
        self.task.close()
