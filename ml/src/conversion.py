import tensorflow as tf
# import tensorflowjs as tfjs


class ModelConverter:

    def __init__(self, model):
        self.model = model

    def _save_model(self, model, filename: str):
        with open(filename, 'wb') as f:
            f.write(model)

    def to_tflite(self, filename: str):
        """ Export a TFLite model using FP32 precision """
        converter = tf.lite.TFLiteConverter.from_keras_model(self.model)
        tflite_model = converter.convert()

        self._save_model(tflite_model, filename)

    def to_tflite_fp16(self, filename: str):
        """ Export a TFLite model using FP16 precision """
        converter = tf.lite.TFLiteConverter.from_keras_model(self.model)
        converter.optimizations = [tf.lite.Optimize.DEFAULT]
        converter.target_spec.supported_types = [tf.float16]
        tflite_model_fp16 = converter.convert()

        self._save_model(tflite_model_fp16, filename)

    def to_tflite_quantized(self, filename: str, representative_dataset):
        """ Export a quantized TFLite model

            representative_dataset: A function that returns representative samples. For example:
            def representative_dataset():
                for data in tf.data.Dataset.from_generator(lambda: train_batches, (tf.float32, tf.float32)).batch(1).take(100):
                    yield [data[0][0]]
            (where train_batches is a batch generator)
        """
        converter = tf.lite.TFLiteConverter.from_keras_model(self.model)
        converter.optimizations = [tf.lite.Optimize.DEFAULT]
        converter.representative_dataset = representative_dataset
        tflite_quant_model = converter.convert()

        self._save_model(tflite_quant_model, filename)

    # def to_tfjs(self, folder_name):
    #     tfjs.converters.save_keras_model(self.model, folder_name)
