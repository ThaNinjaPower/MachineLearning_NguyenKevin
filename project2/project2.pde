Table dataset;

int rowCount;


/* Input variables */
int[] labelInput;
String[] labelString;

float[] widthInput, heightInput;

/* Training variables */
float[] widthTraining, heightTraining;

/* Test variables */
float[] widthTest, heightTest;

float[][] distance;
float[] minimumDistance;

int[] predictedTestType, testType, trainingType;
int testCount = 0;
int trainingCount = 0;

void readInput() {

  rowCount = dataset.getRowCount();
  labelInput = new int[rowCount];
  labelString = new String[rowCount];
  widthInput = new float[rowCount];
  heightInput = new float[rowCount];

  for (int row = 1; row < rowCount; row++) {
    labelInput[row] = dataset.getInt(row, 0);
    labelString[row] = dataset.getString(row, 1);

    widthInput[row] = dataset.getFloat(row, 4);
    heightInput[row] = dataset.getFloat(row, 5);
  }

  for ( int row =0; row < rowCount; row++ ) {
    print( "(" + widthInput[row] + " , " + heightInput[row] + ") " );
  }
}

void identifyValues() {
  int modulusCount = 0;

  // Count number of rows for test data and training data
  for (int row = 0; row < rowCount; row++) {
    int category = modulusCount++ % 4;
    if (category == 0) {
      // Test data
      testCount++;
    } else {
      // Training data
      trainingCount++;
    }
  }

  // Assigning test data
  modulusCount = 0;
  testType = new int[testCount];
  widthTest = new float[testCount];
  heightTest = new float[testCount];
  for (int rowTest = 0; rowTest < testCount; rowTest++) {
      widthTest[rowTest] = widthInput[rowTest * 4 + 3]; //<>//
      heightTest[rowTest] = heightInput[rowTest * 4 + 3];
      testType[rowTest] = labelInput[rowTest * 4 + 3];
  }

  // Assigning training data
  int inputNum = 0;
  modulusCount = 0;
  trainingType = new int[trainingCount];
  widthTraining = new float[trainingCount];
  heightTraining = new float[trainingCount];
  for (int rowTrain = 0; rowTrain < trainingCount; rowTrain++) {
    int category = modulusCount++ % 4; //<>//
    if (category == 0) {
      inputNum++;
    }
    widthTraining[rowTrain] = widthInput[inputNum + 1]; //<>//
    heightTraining[rowTrain] = heightInput[inputNum + 1];
    trainingType[rowTrain] = labelInput[inputNum + 1];
    inputNum++;
  }
}

void predictTestType() {
  distance = new float[testCount][trainingCount];
  minimumDistance = new float[testCount];
  predictedTestType = new int[testCount];

  // For each training value, find Euclidean distance between the current test and the training value
  for (int rowTest = 0; rowTest < testCount; rowTest++) {
    float tempMinimum = Float.MAX_VALUE;
    int closestTrainRow = 0;
    for (int rowTrain = 0; rowTrain < trainingCount; rowTrain++) {
      distance[rowTest][rowTrain] = sqrt(pow(widthTest[rowTest] - widthTraining[rowTrain], 2) + pow(heightTest[rowTest] - heightTraining[rowTrain], 2));

      // If distance is lower than the minimum distance, make the new distance the minimum
      if (distance[rowTest][rowTrain] < tempMinimum) {
        closestTrainRow = rowTrain;
        tempMinimum = distance[rowTest][rowTrain];
      }
    }

    minimumDistance[rowTest] = tempMinimum;

    // Set predicted type for that training set to be the same type for that training data
    predictedTestType[rowTest] = trainingType[closestTrainRow];
  }
}

float testAccuracy() {
  int correctPrediction = 0;
  int incorrectPrediction = 0;
  
  String[] fruitType = new String[5];
  fruitType[0] = "unknown";
  fruitType[1] = "apple";
  fruitType[2] = "mandarin";
  fruitType[3] = "orange";
  fruitType[4] = "lemon";
  
  // Gather all test data whose type is the correct type
  println();
  for (int rowTest = 0; rowTest < testCount; rowTest++) {
    if (predictedTestType[rowTest] == testType[rowTest]) {
      correctPrediction++;
      println("Fruit " + (rowTest * 4 + 3) + " prediction is correct. The type is " + labelString[rowTest * 4 + 3] + ".");
    }
    else {
      incorrectPrediction++;
      println("Fruit " + (rowTest * 4 + 3) + " prediction of " + fruitType[predictedTestType[rowTest]] + " is incorrect. The type is " + labelString[rowTest * 4 + 3]);
    }
  }
  
  // Return result
  println("Correct guesses: " + correctPrediction);
  println("Incorrect guesses: " + incorrectPrediction);
  print("\nThe accuracy/microaverage is ");
  return (float)correctPrediction / (float)(correctPrediction + incorrectPrediction);
}

void testMacroAveraging() {
  int appleCount = 0;
  int appleTP = 0;
  
  int mandarinCount = 0;
  int mandarinTP = 0;
  
  int orangeCount = 0;
  int orangeTP = 0;
  
  int lemonCount = 0;
  int lemonTP = 0;
  
  for (int rowTest = 0; rowTest < testCount; rowTest++) {
    if (predictedTestType[rowTest] == 1) {
      appleCount++;
      if (predictedTestType[rowTest] == testType[rowTest]) {
        appleTP++;
      }
    }
    else if (predictedTestType[rowTest] == 2) {
      mandarinCount++;
      if (predictedTestType[rowTest] == testType[rowTest]) {
        mandarinTP++;
      }
    }
    else if (predictedTestType[rowTest] == 3) {
      orangeCount++;
      if (predictedTestType[rowTest] == testType[rowTest]) {
        orangeTP++;
      }
    }
    else if (predictedTestType[rowTest] == 4) {
      lemonCount++;
      if (predictedTestType[rowTest] == testType[rowTest]) {
        lemonTP++;
      }
    }
  }
  
  // Independent averages of fruit types
  float appleAvg = (float)appleTP / (float)appleCount;
  float mandarinAvg = (float)mandarinTP / (float)mandarinCount;
  float orangeAvg = (float)orangeTP / (float)orangeCount;
  float lemonAvg = (float)lemonTP / (float)lemonCount;
  
  // Average the average of fruits
  float macroAverage = (float)(appleAvg + mandarinAvg + orangeAvg + lemonAvg) / (float)4;
  
  println("The macroaverage is " + macroAverage * 100 + " %");
}

void setup() {

  size(1400, 1400);
  dataset = new Table("fruit_data_with_colors.txt");  
  readInput();
  identifyValues();
  predictTestType();
  println(testAccuracy() * 100 + " %");
  testMacroAveraging();

  /* Show all the test points as circles */
}

void drawTrainingData() {
  // Five different colors
  color[] colorValues = new color[5];

  colorValues[0] = #FFFFFF; // white
  colorValues[1] = #FF0000; // red
  colorValues[2] = #FFFF00; // yellow
  colorValues[3] = #FFA500; // orange
  colorValues[4] = #000000; // black

  int modulusCount = 0;

  for (int row = 0; row < rowCount; row++) {
    int category = modulusCount++ % 4;
    if (category == 0) {
      // Test data
      fill(colorValues[0]);
    } else {
      // Training data

      // Color training data the type
      if (labelInput[row] == 1) {
        // Red for apple
        fill(colorValues[1]);
      } else if (labelInput[row] == 2) {
        // Black for mandarin
        fill(colorValues[4]);
      } else if (labelInput[row] == 3) {
        // Orange for orange
        fill(colorValues[3]);
      } else if (labelInput[row] == 4) {
        // Yellow for lemon
        fill(colorValues[2]);
      }
    }
    ellipse(widthInput[row] * 50, heightInput[row] * 50, 5, 5);
  }
}

void draw() {

  // This is where the visualization is. 
  drawTrainingData();
}