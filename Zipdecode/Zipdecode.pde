static final int CODE = 0;
static final int X = 1;
static final int Y = 2;
static final int NAME = 3;

int totalCount;
Place[] places;
int placeCount;

float minX, maxX;
float minY, maxY;
float mapX1, mapY1;
float mapX2, mapY2;

// Refine and Interact
color backgroundColor = #333333;
color dormantColor = #999966;
color highlightColor = #CBCBCB;
color unhighlightColor = #66664C;
color badColor = #FFFF66;

PFont font;
String typedString = "";
char[] typedChars = new char[5];
int typedCount;
int[] typedPartials = new int[6];
float messageX, messageY;
int foundCount;

// Refine
Place chosen;


public void setup() {
  size(720, 453, P3D);
  
  mapX1 = 30;
  mapX2 = width - mapX1;
  mapY1 = 20;
  mapY2 = height - mapY1;
  
  readData(); 
  
  // Refine and Interact
  font = loadFont("Georgia-14.vlw");
  textFont(font);
  
  messageX = 40;
  messageY = height - 40;
}

void draw() {
  // background(255);
  background(backgroundColor);
  
  for (int i  = 0; i < placeCount; i++) {
    places[i].draw(); 
  }
  
  // Refine
  if (typedCount != 0) {
     if (foundCount > 0) {
       if (typedCount == 4) {
          // Redraw the chosen ones to not be occluded by non-selected points
          for (int i = 0; i < placeCount; i++) {
            if (places[i].matchDepth == typedCount) {
              places[i].draw(); 
            }
          }
       }
       
       if (chosen != null) {
         chosen.drawChosen(); 
       }
       
       fill(highlightColor);
       textAlign(LEFT);
       text(typedString, messageX, messageY);
       
     } else {
       fill(badColor);
       text(typedString, messageX, messageY);
     }
  }
}

float TX(float x) {
  return map(x, minX, maxX, mapX1, mapX2); 
}

float TY(float y) {
  return map(y, minY, maxY, mapY2, mapY1); 
}

void readData() {
  String lines[] = loadStrings("zipcodes_clean.txt");
  parseInfo(lines[0]);
  
  places = new Place[totalCount];
  for (int i = 1; i < lines.length; i++) {
    places[placeCount] = parsePlace(lines[i]);
    placeCount++;
  }
}

void parseInfo(String line) {
  String infoString = line.substring(2);
  String[] infoPieces = split(infoString, ',');
  totalCount = int(infoPieces[0]);
  
  minX = float(infoPieces[1]);
  minY = float(infoPieces[2]);
  maxX = float(infoPieces[3]);
  maxY = float(infoPieces[4]);
}

Place parsePlace(String line) {
  String[] pieces = split(line, TAB);
  
  int zip = int(pieces[CODE]);
  float x = float(pieces[X]);
  float y = float(pieces[Y]);
  String name = pieces[NAME];
  
  return new Place(zip, name, x, y);
}

// Refine and Interact
void updateTyped() {
  // Create string from all typed chars
  typedString = new String(typedChars, 0, typedCount);
  // Fill in the largest partial zip code (e.g. 5318)
  typedPartials[typedCount] = int(typedString);
  // Fill in the smaller partials (e.g. 531, 53, 5)
  for (int j = typedCount - 1; j > 0; --j) {
    typedPartials[j] = typedPartials[j + 1] / 10; 
  }
  
  // Clear count
  foundCount = 0;
  // Refine
  chosen = null;
  // Search each place
  for (int i = 0; i < placeCount; i++) {
    // Update boundaries of selection and identify
    // whether a particular Place is chosen
    places[i].check();
  }
}

void keyPressed() {
  if ((key == BACKSPACE) || (key == DELETE)) {
    if (typedCount > 0) {
      typedCount--; 
    }
  } else if ((key >= '0') && (key <= '9')) {
    if (typedCount != 5) { // Stop at 5 digits
      if (foundCount > 0) { // Nothing found, ignore more typing
        typedChars[typedCount++] = key;
      }
    }
  }
  updateTyped();
}
