int ZIP_CODE = 0;
int CITY = 1;
int STATE = 2;
int LAT = 3;
int LON = 4;

void setup() {
  String[] lines = loadStrings("zipcodes_raw.txt"); //<>//
  String[] cleaned = new String[lines.length];
  
  int placeCount = 0;
  
  float minX = 1;
  float maxX = -1;
  float minY = 1;
  float maxY = -1;
  
  for (int row = 0; row < lines.length; row++) {
    // Split row into pieces over tab
    String[] data = split(lines[row], '\t');
    
    // Remove whitespace on either side of each column
    data = trim(data);
    
    // Convert lat/long from String to float
    float lat = float(data[LAT]);
    float lon = float(data[LON]);
    
    // Albers equal-area conic projection
    // USGS uses standard parellels at 45.5 deg N and 29.5 deg N
    // with a central meridian value of 96 deg W
    // Latitude value is phi, longitutde is lambda
    
    float phi0 = 0;
    float lambda0 = radians(-96);
    float phi1 = radians(29.5f);
    float phi2 = radians(45.5f);
    
    float phi = radians(lat);
    float lambda = radians(lon);
    
    float n = 0.5f * (sin(phi1) + sin(phi2));
    float theta = n * (lambda - lambda0);
    float c = sq(cos(phi1)) + 2*n*sin(phi1);
    float rho = sqrt(c - 2*n*sin(phi)) / n;
    float rho0 = sqrt(c - 2*n*sin(phi0)) / n;
    
    float x = rho * sin(theta);
    float y = rho0 - rho*cos(theta);
    
    if (x > maxX) maxX = x;
    if (x < minX) minX = x;
    if (y > maxY) maxY = y;
    if (y < minY) minY = y;
    
    cleaned[placeCount++] = data[ZIP_CODE] + "\t" +
    x + "\t" + y + "\t" + data[CITY] + ", " + data[STATE];   
  }
  
  PrintWriter pw = createWriter("zipcodes_clean.txt");
  
  pw.println("# " + placeCount + "," + minX + "," + maxX + "," + minY + "," + maxY);
  
  for (int i = 0; i < placeCount; i++) {
    pw.println(cleaned[i]); //<>//
  }
  
  pw.flush();
  pw.close();
  
  println("Finished");
  exit();
}
