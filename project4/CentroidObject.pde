class CentroidObject {

  // x,y points of the centroid
  // public float dist;
  // public float speed;
  public float xPoint;
  public float yPoint;
  public float xAccum; 
  public float yAccum;
  public int count;

  // Color of the centroid
  public int colorVal;

  // Every centroid must have its own centroid id
  public int centroidId;


  public float minDistance;
  public color assignedColor;
  public ArrayList<DataObject> dataObjectList;

  public color[] colorValues = { #8000ff, #FF0000, #FFFF00, #0000FF};




  //   colorList[0] = #00FF00; // green
  //   colorList[1] = #8000ff; // purple


  CentroidObject(float xParam, float yParam, int id) {
    xPoint = xParam;
    yPoint = yParam;
    /// moved = false;
    centroidId = id;
    minDistance = MAX_FLOAT;
    count = 0;
    assignedColor = colorValues[id];
  }

  void drawCentroid(float xValue, float yValue, int radius) {
    fill(assignedColor);
    ellipse(xValue, yValue, radius, radius);
  }

  void clearAccum() {
    xAccum = 0;
    yAccum = 0;
    count = 0;
  }

  void addDataObject(DataObject d) {
    boolean inList = true;
    for (DataObject dataObject : dataObjectList) {
      // Check if its in the list, if so add the data
    }
    
    if (inList == false) {
      // Add d to the dataObjectList
    }
  }

  void setCentroidObjectColor(int value) {
    //color[] colorValues = new color[5];
    colorValues[0] = #000000; // Black
    colorValues[1] = #FF0000; // Red
    colorValues[2] = #FFFF00; // Yellow
    colorValues[3] = #0000FF; // Blue
    colorValues[4] = #00FF00; // Lime

    colorVal = colorValues[value];
  }
}