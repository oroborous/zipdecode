class Place {
  int code;
  String name;
  float x, y;
  
  // Refine and Interact
  int partial[];
  int matchDepth;
  
  public Place(int code, String name, float x, float y) {
    this.code = code;
    this.name = name;
    this.x = x;
    this.y = y;
    
    // Refine and Interact
    partial = new int[6];
    partial[5] = code;            // 53186
    partial[4] = partial[5] / 10; // 5318
    partial[3] = partial[4] / 10; // 531
    partial[2] = partial[3] / 10; // 53
    partial[1] = partial[2] / 10; // 5
  }
  
  void draw() {
    int xx = (int)TX(x); 
    int yy = (int)TY(y);
    //set(xx, yy, #000000);
    
    // Refine and Interact
    color c = dormantColor;
    if (typedCount != 0) {
      if (matchDepth == typedCount) {
        c = highlightColor; 
      } else {
        c = unhighlightColor; 
      }
    }
    
    set(xx, yy, c);
  }
  
  // Refine and Interact
  void check() {
    // Default to zero levels of depth that match
    matchDepth = 0;
    
    if (typedCount != 0) {
      // Start from the greatest depth and work backwards to see how many
      // items match. Want to figure out the maximum match, so better to
      // begin from the end.
      for (int j = typedCount; j > 0; --j) {
        if (typedPartials[j] == partial[j]) {
          matchDepth = j;
          break; // Since starting at end, can stop now
        }
      }
    }
    
    if (matchDepth == typedCount) {
      foundCount++;
    }
    
    // Refine
    if (matchDepth == typedCount && typedCount == 5) {
      chosen = this; 
    }
  }
  
  // Refine
  void drawChosen() {
    noStroke();
    fill(highlightColor);
    int size = 4;
    rect(TX(x), TY(y), size, size);
    
    // Calc position to draw the text, offset slightly from main point
    float textX = TX(x);
    float textY = TY(y) - size - 4;
    
    // Don't go off the top
    if (textY < 20) {
      textY = TY(y) + 20; 
    }
    
    // Don't go off the bottom
    if (textY > height - 5) {
      textY = TY(y) - 20; 
    }
    
    String location = name + " " + nf(code, 5); // num format
    float wide = textWidth(location);
    
    if (textX > width / 3) {
       textX -= wide + 8; 
    } else {
       textX += 8; 
    }
    
    textAlign(LEFT);
    fill(highlightColor);
    text(location, textX, textY);
  }
}
