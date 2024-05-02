import tensorflow as tf


class AslClassification:
    val_split = 0.1
    img_size = (160, 160)

    def __init__(self, class_names, batch_size, tracker):
        self.class_names = class_names
        self.batch_size = batch_size
        self.tracker = tracker
        self.train_batches = None
        self.valid_batches = None
        self.test_batches = None
        self.base_model = None
        self.model = None

    def load_dataset(self, train_path, validation_path):
        self._get_train_test_validation_batches(train_path, validation_path)
        self._prefetch_data()

    def build_model(self, hidden1_size=512, hidden2_size=128, l2_param=0.002, dropout_factor=0.2, bias_regularizer='l1'):
        img_shape = self.img_size + (3,)
        self.base_model = tf.keras.applications.MobileNetV2(input_shape=img_shape,
                                                            include_top=False,
                                                            weights='imagenet')
        global_average_layer = tf.keras.layers.GlobalAveragePooling2D()
        prediction_layer = tf.keras.layers.Dense(len(self.class_names), activation='softmax')
        preprocess_input = tf.keras.applications.mobilenet_v2.preprocess_input
        inputs = tf.keras.Input(shape=(160, 160, 3))
        x = preprocess_input(inputs)
        x = self.base_model(x, training=False)
        x = global_average_layer(x)
        x = tf.keras.layers.Dropout(dropout_factor)(x)
        outputs = prediction_layer(x)
        self.model = tf.keras.Model(inputs, outputs)

    def compile(self, learning_rate=0.0001, loss='sparse_categorical_crossentropy', min_lr=0.00001, decrease_factor=0.2, patience=5,):
        self.model.compile(optimizer=tf.keras.optimizers.RMSprop(learning_rate=learning_rate),
                           loss=tf.keras.losses.SparseCategoricalCrossentropy(),
                           metrics=[tf.keras.metrics.SparseCategoricalAccuracy()])

    def fit(self, epochs=10):
        return self.model.fit(self.train_batches,
                              epochs=epochs,
                              validation_data=self.valid_batches)

    def predict(self, batch_generator):
        return self.model.predict(batch_generator)
    
    def evaluate(self, batch_generator):
        return self.model.evaluate(batch_generator)

    def _get_train_test_validation_batches(self, train_path, validation_path):
        dataset = tf.keras.preprocessing.image_dataset_from_directory(
            train_path,
            shuffle=True,
            batch_size=self.batch_size,
            image_size=self.img_size,
            validation_split=self.val_split,
            seed=2345,
            subset="training"
        )

        self.valid_batches = tf.keras.preprocessing.image_dataset_from_directory(
            validation_path,
            shuffle=True,
            batch_size=self.batch_size,
            image_size=self.img_size,
            validation_split=self.val_split,
            seed=2345,
            subset="validation"
        )
        dataset_size = int(tf.data.experimental.cardinality(dataset))
        train_dataset_size = int(0.9 * dataset_size)

        self.train_batches = dataset.take(train_dataset_size)
        self.test_batches = dataset.skip(train_dataset_size)

    def _prefetch_data(self):
        autotune = tf.data.AUTOTUNE
        self.train_batches = self.train_batches.prefetch(buffer_size=autotune)
        self.valid_batches = self.valid_batches.prefetch(buffer_size=autotune)
        self.test_batches = self.test_batches.prefetch(buffer_size=autotune)
