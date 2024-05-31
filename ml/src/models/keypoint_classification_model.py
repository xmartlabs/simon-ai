import tensorflow as tf


class KeypointClassificationModel:
    val_split = 0.1
    img_size = (160, 160)

    def __init__(self, batch_size, tracker):
        self.batch_size = batch_size
        self.tracker = tracker
        self.train_batches = None
        self.valid_batches = None
        self.model = None

    def load_dataset(self, dataset_path):
        CSV_COLUMN_DEFAULTS = [tf.float64] * 63 + [tf.string]
        columns = [f'x_{i}' for i in range(63)] + ['class']
        keypoints_dataset = tf.data.experimental.make_csv_dataset(
            dataset_path,
            batch_size=self.batch_size,
            column_defaults=CSV_COLUMN_DEFAULTS,
            label_name='class',
            num_epochs=1,
            select_columns=columns)
        dataset_size = int(tf.data.experimental.cardinality(keypoints_dataset))
        self.train_batches = keypoints_dataset.take(int(dataset_size * 0.8))
        self.valid_batches = keypoints_dataset.skip(int(dataset_size * 0.8))


    def build_model(self):
        input_shape = (63,)

        self.model = tf.keras.Sequential([
            tf.keras.Input(shape=input_shape),
            tf.keras.layers.Dense(10, activation='relu'),
            tf.keras.layers.Dense(4, activation='softmax', name='class')
        ])

    def compile(self, learning_rate=0.0001, loss='sparse_categorical_crossentropy', min_lr=0.00001, decrease_factor=0.2, patience=5,):
        self.model.compile(optimizer='adam',
              loss=[loss],
              metrics=['accuracy'])

    def fit(self, epochs=10):
        return self.model.fit(self.train_batches,
                              epochs=epochs,
                              validation_data=self.valid_batches)

    def predict(self, batch_generator):
        return self.model.predict(batch_generator)
    
    def evaluate(self, batch_generator):
        return self.model.evaluate(batch_generator)
