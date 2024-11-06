import tensorflow as tf


class TfliteHelper:
    def __init__(self, model_path):
        self.model = tf.lite.Interpreter(model_path)
        self.model.allocate_tensors()
        print(self.model.get_input_details())
        print(self.model.get_output_details())

    def predict(self, image):
        input_details = self.model.get_input_details()
        self.model.resize_tensor_input(input_details[0]['index'], (1, image.shape[1], image.shape[2], 3), strict=True)
        self.model.allocate_tensors()
        self.model.set_tensor(self.model.get_input_details()[0]["index"], image)
        print(self.model.get_input_details())
        print(self.model.get_output_details())

        self.model.invoke()
        return self.model.get_tensor(self.model.get_output_details()[0]["index"])
