import tensorflow as tf


class TfliteHelper:
    def __init__(self, model_path):
        self.model = tf.lite.Interpreter(model_path)
        self.model.allocate_tensors()
        print(self.model.get_input_details())
        print(self.model.get_output_details())

    def predict(self, image):
        self.model.set_tensor(self.model.get_input_details()[0]["index"], image)
        self.model.invoke()
        return self.model.get_tensor(self.model.get_output_details()[0]["index"])
