
float sigmoid(float x) {
  return 1/(1+exp(-x));
}

//float dsigmoid(float x) {
//  return sigmoid(x)*(1-sigmoid(x));
//}

// y = sigmoid(x);
float dsigmoid(float y) {
  return y*(1-y);
}
class NeuralNetwork {

  int input_nodes;
  int hidden_nodes;
  int output_nodes;

  float lr;

  Matrix weights_ih;
  Matrix weights_ho;

  Matrix bias_h;
  Matrix bias_o;

  NeuralNetwork(int input_nodes, int hidden_nodes, int output_nodes) {
    this.input_nodes = input_nodes;
    this.hidden_nodes = hidden_nodes;
    this.output_nodes = output_nodes;

    this.weights_ih = new Matrix(this.hidden_nodes, this.input_nodes);
    this.weights_ho = new Matrix(this.output_nodes, this.hidden_nodes);
    this.weights_ih.InitRand();
    this.weights_ho.InitRand();

    this.bias_h = new Matrix(this.hidden_nodes, 1);
    this.bias_o = new Matrix(this.output_nodes, 1);
    this.bias_h.InitRand();
    this.bias_o.InitRand();

    this.lr = 0.1;
  }


  float[] feedforward(float[] input_array) {    

    //From Input to Hidden
    Matrix input = new Matrix(input_array.length, 1);
    input.fromArray(input_array);

    Matrix hidden = this.weights_ih.Mult(input);
    hidden = hidden.Add(this.bias_h);

    for (int i=0; i<hidden.rows; i++) {
      for (int j=0; j<hidden.cols; j++) {
        hidden.matrix[i][j] = sigmoid(hidden.matrix[i][j]);
      }
    }

    //From Hidden to Output
    Matrix output = this.weights_ho.Mult(hidden);
    output = output.Add(this.bias_o);

    for (int i=0; i<output.rows; i++) {
      for (int j=0; j<output.cols; j++) {
        output.matrix[i][j] = sigmoid(output.matrix[i][j]);
      }
    }

    //Make it an Array
    float[] guess = output.toArray(output);

    return guess;
  }



  void train(float[] inputs_array, float[] answers_array) {

    //Feedforward 
    //From Input to Hidden
    Matrix input = new Matrix(inputs_array.length, 1);
    input.fromArray(inputs_array);

    Matrix hidden = this.weights_ih.Mult(input);
    hidden = hidden.Add(this.bias_h);

    for (int i=0; i<hidden.rows; i++) {
      for (int j=0; j<hidden.cols; j++) {
        hidden.matrix[i][j] = sigmoid(hidden.matrix[i][j]);
      }
    }

    //From Hidden to Output
    Matrix outputs = this.weights_ho.Mult(hidden);
    outputs = outputs.Add(this.bias_o);

    for (int i=0; i<outputs.rows; i++) {
      for (int j=0; j<outputs.cols; j++) {
        outputs.matrix[i][j] = sigmoid(outputs.matrix[i][j]);
      }
    }

    //End of Feedforward  



    //Convert arguments from Arrays to Matrix
    Matrix A = new Matrix(answers_array.length, 1);
    A = A.fromArray(answers_array);

    //Compute the Error
    Matrix E_O = A.Sub(outputs);

    //Compute the Gradient
    Matrix gradients = new Matrix(outputs.rows, outputs.cols);
    for (int i=0; i<outputs.rows; i++) {
      for (int j=0; j<outputs.cols; j++) {
        gradients.matrix[i][j] = dsigmoid(outputs.matrix[i][j]);
      }
    }

    //Compute delta weights
    gradients = gradients.Hadamard(E_O);
    gradients = gradients.Scale(this.lr);

    Matrix hidden_T = hidden.Transpose();

    Matrix weights_HO_Deltas = gradients.Mult(hidden_T);


    // Tune Weights and Bias
    //gradients.Print();
    //weights_HO_Deltas.Print();

    this.weights_ho = this.weights_ho.Add(weights_HO_Deltas);
    this.bias_o = this.bias_o.Add(gradients);



    //Hidden layers error

    Matrix wHO_T = this.weights_ho.Transpose();   
    Matrix E_H = wHO_T.Mult(E_O);


    //Calculate hidden gradient
    Matrix hidden_gradients = new Matrix(hidden.rows, hidden.cols);
    for (int i=0; i<hidden.rows; i++) {
      for (int j=0; j<hidden.cols; j++) {
        hidden_gradients.matrix[i][j] = dsigmoid(hidden.matrix[i][j]);
      }
    }
    hidden_gradients = hidden_gradients.Hadamard(E_H);
    hidden_gradients = hidden_gradients.Scale(this.lr);

    //Calculate I->H deltas
    Matrix Inputs_T = input.Transpose();

    Matrix weights_IH_Deltas = hidden_gradients.Mult(Inputs_T);

    //hidden_gradients.Print();
    //weights_IH_Deltas.Print();
    this.weights_ih = this.weights_ih.Add(weights_IH_Deltas);
    this.bias_h = this.bias_h.Add(hidden_gradients);
  }


  NeuralNetwork Copy() {
    NeuralNetwork copy = new NeuralNetwork(this.input_nodes, this.hidden_nodes, this.output_nodes);
    copy.weights_ih = this.weights_ih;
    copy.weights_ho = this.weights_ho;
    copy.bias_h = this.bias_h;
    copy.bias_o = this.bias_o;
    return copy;
  }
  
  
  //JSONObject serialize() {
  //  return saveJSONObject(this, "bird");  
  //}

  void Mutate(float rate) {
    this.weights_ih = mutate(this.weights_ih, rate);
    this.weights_ho = mutate(this.weights_ho, rate);
    this.bias_h = mutate(this.bias_h, rate);
    this.bias_o = mutate(this.bias_o, rate);
  }

  Matrix mutate(Matrix m, float rate) {
    Matrix n = new Matrix(m.rows,m.cols);
    for (int i = 0; i < m.rows; i++) {
      for (int j = 0; j < m.cols; j++) {
         n.matrix[i][j] = mutatex(m.matrix[i][j], rate);//gaussian(random(-100,100), 0, 0.1);//randomGaussian()*0.5;//  
      }
    }
    return n;
  }

  float mutatex(float x, float rate) {
    if (random(1) < rate) {
      float offset = randomGaussian()*0.5;
      float x_ = x + offset;
      return x_;
    } else {
      return x;
    }
  }



  float gaussian(float x, float mean, float dev) {
    return exp((-1/2)*pow(((x-mean)/dev), 2)) /(dev*sqrt(2*PI));
  }
}
