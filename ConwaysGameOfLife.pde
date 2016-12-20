  int fieldSize = 0;
  int boxSize = 25;
  color[][]colorField;
  boolean play = false;
  int generation = 1;
  int speed = 6;
  int maxSpeed = 100;

void setup(){
  frameRate(60);
  size(500,500);
  
  //load font
  PFont mono;
  mono = loadFont("CourierNewPS-BoldMT-48.vlw");
  textFont(mono);
  
  //init 2d color array with all fields white
  colorField = new color[ ( width / boxSize )][ ( height / boxSize ) ];
  for( int i = 0; i < colorField.length; ++i){
    for( int j = 0; j < colorField[i].length; ++j){
      colorField[i][j] = color(255);
    }
  }
}

void keyPressed() {
   final int k = key;
   if( k == ENTER || k == RETURN){
      if( play ) play = false;
      else play = true;
   }
   if( speed < maxSpeed && k == 45 ){ //-
      ++speed;
   }
   if( speed > 1 && k == 43 ) { //+
      --speed;
   }
   if (k == CODED) {
     if (keyCode == RIGHT) {
        gameLogic();
        updateCells();
        drawGUI();
     }
   }
   if( k == ' '){
     //make all fields white
     colorField = new color[ ( width / boxSize )][ ( height / boxSize ) ];
     for( int i = 0; i < colorField.length; ++i){
       for( int j = 0; j < colorField[i].length; ++j){
         colorField[i][j] = color(255);
       }
     }
   }
}

void mousePressed() {
   if( colorField[ mouseX / boxSize ][ mouseY / boxSize ] == color(255) ){
     colorField[ mouseX / boxSize ][ mouseY / boxSize ] = color(0);
   }else{
     colorField[ mouseX / boxSize ][ mouseY / boxSize ] = color(255);
   };
   redraw();
}

void gameLogic(){
      System.out.println( frameCount );
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
  
  /*//help text
  textSize( 20 );
  noStroke();
  fill(255);
  rect( 10, height - 100, 400, 90);
  fill( #304CE3 );
  text( "Mouselick: put living cell onto grid", 15, height - 80 );
  stroke(1);*/
}

void draw() {
  if( play ){
     if( frameCount % speed == 0 ) { 
       gameLogic();
     }
  }
  updateCells();
  drawGUI();
}

/*THE GAME OF LIFE RULES:
  (black cell = alive | white cell = dead)
  1. Any live cell with fewer than two live neighbours dies, as if caused by underpopulation.
  2. Any live cell with two or three live neighbours lives on to the next generation.
  3. Any live cell with more than three live neighbours dies, as if by overpopulation.
  4. Any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction.
*/