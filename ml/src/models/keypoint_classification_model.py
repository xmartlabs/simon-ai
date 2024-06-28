import tensorflow as tf


class KeypointClassificationModel:
    val_split = 0.1
    img_size = (160, 160)

    def __init__(self, batch_size):
        self.batch_size = batch_size
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

        dataset_size = keypoints_dataset.reduce(0, lambda x, _: x + 1).numpy()
        self.train_batches = keypoints_dataset.take(int(dataset_size * 0.8))
        self.valid_batches = keypoints_dataset.skip(int(dataset_size * 0.8))

    def load_dataset_new(self, dataset_path):
        CSV_COLUMN_DEFAULTS = [tf.float64] * 63 + [tf.string]
        columns = [f'x_{i}' for i in range(63)] + ['class']
        keypoints_dataset = tf.data.experimental.make_csv_dataset(
            dataset_path,
            batch_size=self.batch_size,
            column_defaults=CSV_COLUMN_DEFAULTS,
            label_name='class',
            num_epochs=1,
            select_columns=columns,
            shuffle=True)

        keypoints_dataset = keypoints_dataset.map(self.preprocess).cache().prefetch(buffer_size=tf.data.experimental.AUTOTUNE)
        # dataset_size = keypoints_dataset.reduce(0, lambda x, _: x + 1).numpy()
        dataset_size = 309
        self.train_batches = keypoints_dataset.take(int(dataset_size * 0.8))
        self.valid_batches = keypoints_dataset.skip(int(dataset_size * 0.8))

    def safe_convert(self, value):
        try:
            return tf.strings.to_number(value, out_type=tf.float32)
        except:
            return tf.constant(0.0, dtype=tf.float32)

    def preprocess(self, features, label):
        label = tf.strings.to_number(label, out_type=tf.int32)
        features = {key: self.safe_convert(value) for key, value in features.items()}
        #features = tf.stack(list(features.values()), axis=-1)
        #features = {key: features[key] for key in features}
        #features = tf.stack(list(features.values()), axis=-1)
    
        return features, label

    def build_model(self):
        input_shape = (63,)

        self.model = tf.keras.Sequential([
            tf.keras.Input(shape=input_shape),
            tf.keras.layers.Dense(10, activation='relu'),
            tf.keras.layers.Dense(4, activation='softmax', name='class')
        ])

        self.model.summary()
        print('MODEL-input_shape', self.model.input_shape)

    def compile(self, learning_rate=0.0001, loss='sparse_categorical_crossentropy', min_lr=0.00001, decrease_factor=0.2, patience=5,):
        self.model.compile(optimizer='adam', loss=[loss], metrics=['accuracy'])

    def fit(self, epochs=10):
        return self.model.fit(self.train_batches,
                              epochs=epochs,
                              validation_data=self.valid_batches)

    def predict(self, batch_generator):
        return self.model.predict(batch_generator)

    def evaluate(self, batch_generator):
        return self.model.evaluate(batch_generator)
