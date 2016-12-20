  int fieldSize = 0;
  int boxSize = 25;
  color[][]colorField;

void setup(){
  frameRate(0.75);
  size(500,500);
  
  //init 2d color array with all fields white
  colorField = new color[ ( width / boxSize )][ ( height / boxSize ) ];
  for( int i = 0; i < colorField.length; ++i){
    for( int j = 0; j < colorField[i].length; ++j){
      colorField[i][j] = color(255);
    }
  }
  
  //seeds: set which cells are alive at the beginning
  colorField[9][11] = color(0);
  colorField[10][11] = color(0);
  colorField[11][11] = color(0);  
}

void draw() {
  
  //GAME LOGIC
  color[][] colorFieldTmp = new color[ ( width / boxSize )][ ( height / boxSize ) ];
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
        if( alive < 2 ) colorFieldTmp[i][j] = color(255); 
        if( alive == 2 || alive == 3 ) colorFieldTmp[i][j] = color(0); 
        if( alive > 3 ) colorFieldTmp[i][j] = color(255);
      }else{
        if( alive == 3 ){
          colorFieldTmp[i][j] = color(0);
        }else{
          colorFieldTmp[i][j] = color(255);
        }
      }      
      alive = 0;
      
    }
  }
  
  //update cell color
  colorField = colorFieldTmp;
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

/*THE GAME OF LIFE RULES:
  (black cell = alive | white cell = dead)
  1. Any live cell with fewer than two live neighbours dies, as if caused by underpopulation.
  2. Any live cell with two or three live neighbours lives on to the next generation.
  3. Any live cell with more than three live neighbours dies, as if by overpopulation.
  4. Any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction.
*/