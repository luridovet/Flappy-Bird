class Matrix {

  int rows;
  int cols;
  float[][] matrix;

  Matrix(int rows, int cols) {
    this.rows = rows;
    this.cols = cols;
    this.matrix = new float[this.rows][this.cols]; 


    for (int i = 0; i<this.rows; i++) {
      this.matrix[i] = new float[this.cols];
      for (int j = 0; j<this.cols; j++) {
        this.matrix[i][j] = 1;
      }
    }
  }


  Matrix fromArray(float[] arr) {
    //Matrix m = new Matrix(arr.length, 1);
    for (int i=0; i<arr.length; i++) {
      this.matrix[i][0] = arr[i];
    }
    return this;
  }

  float[] toArray(Matrix m) {
    float[] guess = new float[m.rows];
    for (int i=0; i<m.rows; i++) {
      guess[i] = m.matrix[i][0];
    }
    return guess;
  }

  //Initialze the values of a matrix randomly
  Matrix InitRand() {
    Matrix result = new Matrix(this.rows, this.cols);
    for (int i = 0; i<this.rows; i++) {
      for (int j = 0; j<this.cols; j++) {
        this.matrix[i][j] = random(-1, 1);
      }
    }

    return result;
  }  

  //Multiply matrix m by a scalar n 
  Matrix Scale(float n) {
    Matrix result = new Matrix(this.rows, this.cols);

    for (int i = 0; i<this.rows; i++) {
      for (int j = 0; j<this.cols; j++) {
        result.matrix[i][j] = this.matrix[i][j]*n;
      }
    }
    return result;
  }


  //Add a matrix n to matrix m
  Matrix Add(Matrix n) {
    Matrix result = new Matrix(this.rows, this.cols);
    if (this.cols == n.cols && this.rows == n.rows) {
      for (int i = 0; i<this.rows; i++) {
        for (int j = 0; j<this.cols; j++) {
          result.matrix[i][j] = this.matrix[i][j]+n.matrix[i][j];
        }
      }
      return result;
    } else {
      println("Sum is Undefined");
      return null;
    }
  }

  Matrix Sub(Matrix n) {
    Matrix result = new Matrix(this.rows, this.cols);
    for (int i = 0; i<this.rows; i++) {
      for (int j = 0; j<this.cols; j++) {
        result.matrix[i][j] = this.matrix[i][j] - n.matrix[i][j];
      }
    }
    return result;
  }


  //Multiply matrix m by a matrix n
  Matrix Mult(Matrix n) {
    if (this.cols != n.rows) {
      println("Prod is Undefined");
      return null;
    } else {

      //Rename for tideness
      Matrix a = this;
      Matrix b = n;
      Matrix result = new Matrix(a.rows, b.cols);

      for (int i = 0; i< result.rows; i++) {
        for (int j = 0; j<result.cols; j++) {
          //dot product
          float sum = 0;
          for (int k = 0; k<a.cols; k++) {
            sum += a.matrix[i][k] * b.matrix[k][j];
          }
          result.matrix[i][j] = sum;
        }
      }
      return result;
    }
  }

  Matrix Hadamard(Matrix n) {
    Matrix result = new Matrix(this.rows, this.cols);
    if (this.cols == n.cols && this.rows == n.rows) {
      for (int i = 0; i<this.rows; i++) {
        for (int j = 0; j<this.cols; j++) {
          result.matrix[i][j] = this.matrix[i][j] * n.matrix[i][j];
        }
      }
      return result;
    } else {
      println("Hadamard is Undefined");
      return null;
    }      

  }

  //Transpose matrix m
  Matrix Transpose() {
    Matrix transposed = new Matrix(this.cols, this.rows);
    for (int i=0; i<this.rows; i++) {
      for (int j=0; j<this.cols; j++) {
        transposed.matrix[j][i] = this.matrix[i][j];
      }
    }
    return transposed;
  }


  Matrix reduce(int delI, int delJ) {
    Matrix inter = new Matrix(this.rows-1, this.cols-1);

    int i2 = 0;
    int j2 = 0;

    for (int i=0; i<this.rows; i++) {
      for (int j=0; j<this.cols; j++) {
        if (delJ != j) {
          inter.matrix[i2][j2] = this.matrix[i][j];
          j2++;
        }
      }
      if (delI != i) {
        i2++;
      }
      j2 = 0;
      if (i2 == this.rows - 1) {
        break;
      }
    }
    return inter;
  }

  float det(Matrix A) {
    float det = 0;
    if (A.rows == 2 && A.cols == 2) {
      det = A.matrix[0][0]*A.matrix[1][1] - A.matrix[0][1]*A.matrix[1][0];
    } else {
      for (int i = 0; i<A.cols; i++) {
        det += pow(-1, i)*A.matrix[0][i]*det(A.reduce(0, i));
      }
    }
    return det;
  }

  Matrix Com() {
    Matrix Com = new Matrix(this.rows, this.cols);

    for (int i=0; i<this.rows; i++) {
      for (int j=0; j<this.cols; j++) {
        Com.matrix[i][j] = pow(-1, i+j)*det(this.reduce(i, j));
      }
    }
    return Com;
  }

  Matrix Inv() {
    Matrix Inv = new Matrix(this.rows, this.cols);

    float invDet = 1/det(this);
    println(det(this), " ", invDet);
    Matrix Com = new Matrix(this.rows, this.cols);

    for (int i=0; i<this.rows; i++) {
      for (int j=0; j<this.cols; j++) {
        Com.matrix[i][j] = pow(-1, i+j)*det(this.reduce(i, j));
      }
    }
    Com.Print();
    Inv = Com.Transpose();

    Inv = Inv.Scale(invDet);

    return Inv;
  }


  //Print matrix m
  void Print() {
    for (int i = 0; i<this.rows; i++) {
      for (int j = 0; j<this.cols; j++) {
        if (this.matrix[i][j] < 0) {
          print(this.matrix[i][j]);
          print("|");
        } else {
          print(" ");
          print(this.matrix[i][j]);
          print("|");
        }
      }
      println();
    }
    println();
  }
}
