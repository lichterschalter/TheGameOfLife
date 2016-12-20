  int fieldSize = 0;
  int boxSize = 20; //working are: 10, 20, 25
  color[][]colorField;
  boolean play = false;
  boolean initFlag = false;
  boolean manual1Seen = true;
  boolean manual2Seen = false;
  int generation = 1;
  int speed = 6;
  int maxSpeed = 100;
  PFont mono, bold;

void setup(){
  frameRate(60);
  size(500,500);
  
  //load font
  mono = loadFont("CourierNewPS-BoldMT-48.vlw");
  bold = loadFont("MicrosoftPhagsPa-Bold-48.vlw");
  textFont(mono);
  
}

void keyPressed() {
   final int k = key;
   if( k == ENTER || k == RETURN){
      if( play ) play = false;
      else play = true;
   }
   if( speed < maxSpeed && k == '-' ){ //-
      ++speed;
   }
   if( speed > 1 && k == '+' ) { //+
      --speed;
   }
   if (k == CODED) {
     if (keyCode == RIGHT) {
        gameLogic();
        updateCells();
        drawGUI();
     }
   }
   if( k == '?' || k == 'h' ){ //? and h
     if( manual2Seen == false ){
       manual2Seen = true;
       loop();
     }else{
       manual2Seen = false;
       drawManual2();
       noLoop();
     }
   }
   if( k == ' '){ //spacebar
     drawEmptyGrid();
     generation = 1;
   }
}

void drawEmptyGrid() {
   //make all fields white
   colorField = new color[ ( width / boxSize )][ ( height / boxSize ) ];
   for( int i = 0; i < colorField.length; ++i){
     for( int j = 0; j < colorField[i].length; ++j){
       colorField[i][j] = color(255);
     }
   }
}

void mousePressed() {
   if( manual1Seen == true && manual2Seen == true ){
     if( colorField[ mouseX / boxSize ][ mouseY / boxSize ] == color(255) ){
       colorField[ mouseX / boxSize ][ mouseY / boxSize ] = color(0);
     }else{
       colorField[ mouseX / boxSize ][ mouseY / boxSize ] = color(255);
     };
     redraw();
   }else{
     if( manual1Seen == false ){
       manual1Seen = true;
     }else{
       manual2Seen = true; 
     }
   }
}

void gameLogic(){
      color[][] colorFieldTmp = new color[ ( width / boxSize )][ ( height / boxSize ) ];
      int fieldChanges = 0;
      for( int i = 0; i < colorField.length; ++i){
        for( int j = 0; j < colorField[i].length; ++j){
          
          //count living neighbours ([i] = vertical or column)
          int alive = 0;
          
          //three cells above
          if( j > 0 ){
            if( i + 1 < colorField.length ){
              if( colorField[i+1][j-1] == color(0) ) ++alive;
            }
            if( colorField[ i ][j-1] == color(0) ) ++alive;
            if( i > 0 ){
              if( colorField[i-1][j-1] == color(0) ) ++alive;
            }
          }
      
          //the cell left and right
          if( i + 1 < colorField.length ){
            if( colorField[i+1][ j ] == color(0) ) ++alive;
          }
          if( i > 0 ){
            if( colorField[i-1][ j ] == color(0) ) ++alive;
          }
          
          //three cells below
          if( j + 1 < colorField[i].length ){
            if( i + 1 < colorField.length ){
              if( colorField[i+1][j+1] == color(0) ) ++alive;
            }
            if( colorField[ i ][j+1] == color(0) ) ++alive;
            if( i > 0 ){
              if( colorField[i-1][j+1] == color(0) ) ++alive;
            }
          }
          
          //apply rules
          if( colorField[i][j] == color(0) ){
            if( alive < 2 ){
              colorFieldTmp[i][j] = color(255);
              ++fieldChanges;
            }
            if( alive == 2 || alive == 3 ) colorFieldTmp[i][j] = color(0); 
            if( alive > 3 ){
              colorFieldTmp[i][j] = color(255);
              ++fieldChanges;
            }
          }else{
            if( alive == 3 ){
              colorFieldTmp[i][j] = color(0);
              ++fieldChanges;
            }else{
              colorFieldTmp[i][j] = color(255);
            }
          }      
          alive = 0;
          
        }
      }
      if( fieldChanges == 0 ){
        play = false;
      }else{
      colorField = colorFieldTmp;
      ++generation;
      }
      fieldChanges = 0;
}

void updateCells(){
  //updates cell color
  for( int i = 0; i < width; i = i + boxSize){
    for( int j = 0; j < height; j = j + boxSize){
     fill( colorField[ i / boxSize ][ j / boxSize ] );
     rect(i, j, boxSize, boxSize); 
     
     /*//cell numbers for debugging
     fill(0);
     textSize(200 / boxSize);
     text( str( i / boxSize ) + "," + str( j / boxSize ), i , j + ( boxSize / 2 ) ); */
          
    }
  } 
}

void drawGUI(){
  //start and stop label
  textSize( 20 );
  if(play){
      stroke( #34C92B );
      fill(255);
      rect( width - 73, height - 40, 65, 30);
  }else{
      stroke( #E33054 );
      fill(255);
      rect( width - 73, height - 40, 65, 30);
  }
  if(play){
    fill( #34C92B );
    text( "Play", width - 65, height - 20 );
    stroke( #34C92B );
  }else{
    fill( #E33054 );
    text( "Stop", width - 65, height - 20 );
    stroke( #E33054);
  }
  stroke(1);
  
  //print generation
  textSize( 20 );
  noStroke();
  fill(#E33054);
  rect( 10, height - 40, 250, 30);
  fill(255);
  text( "Generation: " + str(generation), 17, height - 20 );
  stroke(1);
  
  //print speed
  textSize( 20 );
  noStroke();
  fill(#E33054);
  rect( 270, height - 40, 132, 30);
  fill(255);
  text( "Speed: " + str( maxSpeed - speed + 1 ), 277, height - 20 );
  stroke(1);

}

void drawManual1(){
  noStroke();
  fill(255);
  rect( 0, 0, width, height);
  textSize( 30 );
  fill( #E33054 );
  text( "Conways Game of Life", 20, 40 );
  fill( 0 );
  textSize(17);
  text( "The 4 Rules:", 20, 120 ); 
  text( "1. Any living cell with < 2 live", 20, 160 ); 
  text( "   neighbours dies,", 20, 180 ); 
  text( "   as if caused by underpopulation.", 20, 200 ); 
  text( "2. Any living cell with 2 or 3 live", 20, 240 ); 
  text( "   neighbours lives on to the next generation.", 20, 260 );
  text( "3. Any living cell with > 3 live", 20, 300 ); 
  text( "   neighbours dies, as if by overpopulation.", 20, 320 ); 
  text( "4. Any dead cell with exactly 3 live", 20, 360 ); 
  text( "   neighbours becomes a live cell,", 20, 380 );
  text( "   as if by reproduction.", 20, 400 );
  stroke(1);
}

void drawManual2(){
  noStroke();
  fill(255);
  rect( 0, 0, width, height);
  textSize( 30 );
  fill( #E33054 );
  text( "G A M E   O F   L I F E", 20, 40 );
  fill( 0 );
  text( "CLICK: set living cells", 20, 120 ); 
  text( "ENTER: start / stop", 20, 160 ); 
  text( "SPACE: clear grid", 20, 200 ); 
  text( "--> : one step forward", 20, 240 ); 
  text( "+ and - : set speed", 20, 280 ); 
  text( "? and 'h' : help page", 20, 320 ); 
  text( "This is a very simple", 20, 400 ); 
  text( "simulation based on the", 20, 440 );
  text( "four rules of Conway.", 20, 480 );
  stroke(1);
}

void draw() {
  if( manual1Seen == false ){
    drawManual1();
  }
  else if( manual2Seen == false ){
    drawManual2();
  }
  else if( initFlag == false ){
    drawEmptyGrid();
    initFlag = true;
  }
  else if( play ){
     if( frameCount % speed == 0 ) { 
       gameLogic();
     }
  }
  if( manual1Seen == true && manual2Seen == true && initFlag == true ){
    updateCells();
    drawGUI();
  }
}

/*THE GAME OF LIFE RULES:
  (black cell = alive | white cell = dead)
  1. Any live cell with fewer than two live neighbours dies, as if caused by underpopulation.
  2. Any live cell with two or three live neighbours lives on to the next generation.
  3. Any live cell with more than three live neighbours dies, as if by overpopulation.
  4. Any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction.
*/