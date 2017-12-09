import java.util.Random;
import java.util.*;

Table dataset;

int rowCount;
float xMin = MAX_FLOAT;
float xMax = MIN_FLOAT;
float yMin = MAX_FLOAT;
float yMax = MIN_FLOAT;
boolean drawOnce = true;
color[] colorValues = { #000000, #FF0000, #FFFF00, #0000FF};
float sValue;

/* Input variables */
ArrayList<DataObject> dataList ;
int numCategories = 3;
ArrayList<CentroidObject> centroidList;
boolean objectMoved;

void readInput() {

  rowCount = dataset.getRowCount();
  dataList = new ArrayList<DataObject>();
  centroidList =  new ArrayList<CentroidObject>();

  int socialSecurityNumber;
  float x;
  float y;
  for ( int i = 0; i < rowCount; i++ ) {
    if ( i == 0 ) continue;  // The header
    socialSecurityNumber = dataset.getInt(i, 0);
    x = dataset.getFloat(i, 1);
    y = dataset.getFloat(i, 2);
    DataObject dataObject = new DataObject(x, y);
    dataList.add(dataObject);
  }
  applyScaleToDataObjects();
}

void applyScaleToDataObjects() {

  // x  -- distance,  y -- speed 



  findMinMax();
  // print("new" + xMin + "," + xMax + "," + yMin + "," + yMax);
  for ( DataObject d : dataList) {
    d.applyScale(xMin, xMax, yMin, yMax);
  }
}

void findMinMax() {

  // Iterate over the dataList and update the xMin and yMin variables
  calculateCentroidAvg();

  //Find Mininum value
  for ( DataObject d : dataList) {
    if ( d.xPos < xMin ) {
      xMin = d.xPos;
    }
    if (d.xPos > xMax) {
      xMax = d.xPos;
    }

    if ( d.yPos < yMin ) {
      yMin = d.yPos;
    }

    if (d.yPos > yMax) {
      yMax = d.yPos;
    }
  }
}



float randomFunc(float xVal, float yVal) {
  // In this function given the boundary points xVal and yVal, return a randomized number inbetween 
  float randomVal = 0;
  // Implement here 
  return randomVal;
}

void applyClusteringAlgorithm() {

  // Generate a random number of size numCategory starting points
  HashSet<DataObject> mapObject; 
  for ( int i = 0; i < numCategories; i++ ) {
    // Randomly apply centroid coordinate between 0 and 1 for each feature
    Random randInst = new Random();
    CentroidObject dataObject = new CentroidObject(randInst.nextFloat(), randInst.nextFloat(), i);
    centroidList.add(dataObject);
  }


  // WE iterate over all the data objects for each centroid value marking the data object to the closest centroid
  objectMoved = true;

  while ( objectMoved == true ) {
    objectMoved = false;
    calculateCentroidAvg();
    /*for (CentroidObject cList : centroidList) {
     cList.clearAccum(); 
     
     }*/

    // Update centroids coordinates through median
    for (CentroidObject c : centroidList ) {
      c.xPoint = c.xAccum / c.count;
      c.yPoint = c.yAccum / c.count;
    }
  }
}

void calculateCentroidAvg() {
  for ( DataObject d : dataList ) {
    // d.minDistance = MAX_FLOAT;
    // Calculate centroid average
    for ( CentroidObject centroidObjects : centroidList) {
      // Calculate the distance from the centroid object to the data object element d
      // If the calculate distance is smaller , and the centroid id is different 
      // then change d.mindistance and centroid id to the centroid object id
      
      double value1 = centroidObjects.xPoint - d.scaledX;
      double value2 = centroidObjects.yPoint - d.scaledY;
      float dataToObjectDist = (float) ((Math.pow(value1, 2.0)) +  Math.pow(value2, 2.0));
      
      if (dataToObjectDist < d.minDistance) {
        d.minDistance = dataToObjectDist;
        if ( d.centroidId != centroidObjects.centroidId) {
          d.centroidId = centroidObjects.centroidId;
          objectMoved = true;
        }
      }

      if ( d.centroidId == centroidObjects.centroidId) {
        centroidObjects.xAccum += d.scaledX;
        centroidObjects.yAccum += d.scaledY;
        centroidObjects.count += 1;
      }
    }
  }
}

void calculateMedians() {
  for ( DataObject d : dataList ) {
    // d.minDistance = MAX_FLOAT;
    // Calculate centroid average
    for ( CentroidObject centroidObject : centroidList) {
      // Calculate the distance from the centroid object to the data object element d
      // If the calculate distance is smaller , and the centroid id is different 
      // then change d.mindistance and centroid id to the centroid object id
      
      double value1 = centroidObject.xPoint - d.scaledX;
      double value2 = centroidObject.yPoint - d.scaledY;
      float dataToObjectDist = (float) ((Math.pow(value1, 2.0)) +  Math.pow(value2, 2.0));
      
      if (dataToObjectDist < d.minDistance) {
        d.minDistance = dataToObjectDist;
        if ( d.centroidId != centroidObject.centroidId) {
          d.centroidId = centroidObject.centroidId;
          
          objectMoved = true;
        }
      }

      if ( d.centroidId == centroidObject.centroidId) {
        // When adding a new data object to the centroid, sort the centroid
        centroidObject.addDataObject(d);
      }
    }
  }
}

// This is more involved
void calculateMediod() {
  // Calls calculateSSE for every swapped dataObject
  for (DataObject a : dataList) {
    if (a.isSwappedItem == true) {
        calculateSSE();
    }
  }
}

void setup() {

  size(1000, 1000);
  dataset = new Table("locations.tsv");  
  readInput();   /// Read input , scaled each of the data object features (distance,speed) between 0 and 1
  applyClusteringAlgorithm();


  /* Show all the test points as circles */
}

void drawCluster() {
  println("Drawing once !");
  for ( DataObject d : dataList ) {
    // Here is where to draw
    //  Convert to map coordinates (distance,speed)
    //  Draw  X  or O to represent coordinates
    print(d.xPos + " " + d.yPos + " -- ");
    d.drawDataObject(d.xPos, d.yPos, 5);
  }
}

// This function iterates over all the mediods and finds the SSE value
// Here we can identify data object that are mediods
// This is a nested loop iterating over medoids and the inner loop iterates over the data object
// We are calling this function for every swapped m (so D - M calls for this function, D = dataList.size(), M = number of mediods)
void calculateSSE() {
  float tmpSValue = 0;
  for (DataObject m : dataList) {
    if (m.isMediod == false) continue;
    for (DataObject d : dataList) {
      if (d.isMediod == true) {
        // Calculate || x[i] - Cm || * 2
        double value1 = d.scaledX - m.scaledX;
        double value2 = d.scaledY - m.scaledY;
        tmpSValue += (float) (Math.pow(value1, 2.0) + Math.pow(value2, 2.0));
      }
    }
  }
  
  if (tmpSValue < sValue) {
    sValue = tmpSValue;
  }
}

void drawCentroid() {
  print(" Draw centroid callback ! ");
  for ( CentroidObject centroidObjects : centroidList) {
    float xValue = centroidObjects.xPoint * (xMax - xMin) + xMin;
    float yValue = centroidObjects.yPoint * (xMax - xMin) + xMin;
    print(" x value " + xValue + " y value  " + yValue + "\n");
    centroidObjects.drawCentroid(xValue, yValue, 10);
  }
}


void draw() {
  // This is where the visualization is.
  if (drawOnce == true) {
    drawCluster();
    drawCentroid();
    drawOnce = false;
  }
}