import 'file:///D:/release/ai/lib/impleament/block_unit.dart';

class Wieght{
 static List valueOfBlocks = [[100,-20,10,5,5,10,-20,100],
                        [-20,-50,-2,-2,-2,-2,-50,-20],
                        [10,-2,-1,-1,-1,-1,-2,10],
                        [5,-2,-1,-1,-1,-1,-2,5],
                        [5,-2,-1,-1,-1,-1,-2,5],
                        [10,-2,-1,-1,-1,-1,-2,-50,-20],
                        [-20,-50,-2,-2,-2,-2,-50,-20],
                        [100,-20,10,5,5,10,-20,100],];

  static int getPositionalValue(int i , int j){
    return valueOfBlocks[i][j];
  }


  static double getMobityValue(List<List<BlockUnit>> table){
   int blackCornerScore = 0;
   int whiteCornerScore = 0;
   int blackMobityScore = 0 ;
   int whitekMobityScore = 0 ;

    if(table[0][0] == 2)
      blackCornerScore++;
    else if(table[0][0] == 1)
      whiteCornerScore++;

   if(table[0][7] == 2)
     blackCornerScore++;
   else if(table[0][7] == 1)
     whiteCornerScore++;

   if(table[7][0] == 2)
     blackCornerScore++;
   else if(table[7][0] == 1)
     whiteCornerScore++;

   if(table[7][7] == 2)
     blackCornerScore++;
   else if(table[7][7] == 1)
     whiteCornerScore++;


// +1 باید حدف شه

    return (10*(blackCornerScore-whiteCornerScore) + ((blackMobityScore - whitekMobityScore+1)/(blackMobityScore + whitekMobityScore+1)));
  }




 static int getNumbers(List<List<BlockUnit>> table){
   int blackScore = 0;
   int whiteScore = 0;

   for(int i=0; i<8 ; i++)
     for(int j=0 ; j<8 ; j++)
       if(table[i][j]==1)
         whiteScore++;
       else if(table[i][j]==2)
         blackScore++;

       return blackScore - whiteScore;
 }






}