class DataObject {

  public float xPos;   // x value
  public float yPos;  //  y value

  // Scaled values
  public float scaledX;  // scaled x value 
  public float scaledY;  // scaled y value

  public int colorVal;
  public boolean moved;
  public int centroidId;
  public float minDistance;
  public color[] dataColorValues = { #8000ff, #FF0000, #FFFF00, #0000FF};
  public boolean isMediod;
  public boolean isSwappedItem;


  DataObject(float xParam, float yParam) {
    xPos = xParam;
    yPos = yParam;
    moved = false;
    centroidId = -1;
    minDistance = MAX_FLOAT;
    isMediod = false;
  }

  void applyScale(float xMinValue, float xMaxValue, float yMinValue, float yMaxValue) {
    // scaledX = map(xPos, xMinValue,xMaxValue,0,1);
    scaledX = ( xPos - xMinValue ) / (xMaxValue - xMinValue);


    scaledY = ( yPos - yMinValue) / (yMaxValue - yMinValue);
    // scaledSpeed =  ( speed - xMinValue ) / (xMaxValue - xMinValue);
    // scaledDist =  ( dist - yMinValue) / (yMaxValue - yMinValue); 
    // print("(" + scaledX + "," + scaledY + ") " );
  }

  void setDataObjectColor(int value) {
    color[] colorValues = new color[5];
    colorValues[0] = #000000;  // Black
    colorValues[1] = #FF0000;  // Red
    colorValues[2] = #FFFF00;  // Yellow
    colorValues[3] = #0000FF; // Blue
    colorValues[4] = #00FF00; // Lime

    colorVal = colorValues[value];
  }

  void drawDataObject(float xVal, float yVal, int radius) {
    fill(dataColorValues[centroidId]);
    ellipse(xVal, yVal, radius, radius);
  }
}