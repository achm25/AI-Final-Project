import 'dart:math';

class Children{
  List<Chromosome> groupe1 = new List();
  List<Chromosome> groupe2 = new List();
  List<Chromosome> groupe3 = new List();
  List<Chromosome> groupe4 = new List();
  Random random = new Random();

  generateGroupe(){
    for(int i = 0 ; i < 40 ; i++){
      if(i % 4 == 0){
        groupe1.add(Chromosome(gene: generateChild(),score: 0));
      }else if ( i % 4 == 1){
        groupe2.add(Chromosome(gene: generateChild(),score: 0));
      }else if(i % 4 == 2){
        groupe3.add(Chromosome(gene: generateChild(),score: 0));
      }else{
        groupe4.add(Chromosome(gene: generateChild(),score: 0));
      }
    }
  }

 List generateChild(){
    List child = new List();
    for(int i = 0 ; i < 8 ; i++ ){
      List row = new List();
      for( int j = 0 ; j < 8 ; j++){
        int randomNumber = random.nextInt(100);
        row.add(randomNumber);
      }
      child.add(row);
    }
    return child;
  }

 Chromosome motive(groupeNumber){
   int randomChromosomeNumber = random.nextInt(7);
   Chromosome chromosome = new Chromosome();
   if(groupeNumber == 1){
     chromosome = groupe1[randomChromosomeNumber];
      for(int i = 0; i < 8 ; i++){
        int randomRowNumber = random.nextInt(8);
        int randomGenNumber = random.nextInt(8);
        int randomNumber = random.nextInt(5);
        chromosome.gene[randomRowNumber][randomGenNumber] += randomNumber;
      }
   }else if ( groupeNumber == 2){
     chromosome = groupe2[randomChromosomeNumber];
     for(int i = 0; i < 8 ; i++){
       int randomRowNumber = random.nextInt(8);
       int randomGenNumber = random.nextInt(8);
       int randomNumber = random.nextInt(10);
       chromosome.gene[randomRowNumber][randomGenNumber] += randomNumber;
     }
   }else if (groupeNumber == 3){
     chromosome = groupe3[randomChromosomeNumber];
     for(int i = 0; i < 8 ; i++){
       int randomRowNumber = random.nextInt(8);
       int randomGenNumber = random.nextInt(8);
       int randomNumber = random.nextInt(10);
       chromosome.gene[randomRowNumber][randomGenNumber] += randomNumber;
     }
   }else{
     chromosome = groupe4[randomChromosomeNumber];
     for(int i = 0; i < 8 ; i++){
       int randomRowNumber = random.nextInt(8);
       int randomGenNumber = random.nextInt(8);
       int randomNumber = random.nextInt(10);
       chromosome.gene[randomRowNumber][randomGenNumber] += randomNumber;
     }
   }
   return chromosome;
 }

  List<Chromosome> recombination(int groupeNumber){
    int randomNumber = random.nextInt(4);
    int parent1 = random.nextInt(7);
    int parent2 = random.nextInt(7);
    int parent3 = random.nextInt(7);
    int parent4 = random.nextInt(7);
    Chromosome chromosome12 = Chromosome(gene: generateChild(),score: 0);
    Chromosome chromosome34 = Chromosome(gene: generateChild(),score: 0);
    if(groupeNumber == 1){
      for(int i = 0 ; i<8 ; i++){
        if(i%2 ==0){
          chromosome12.gene[i] = groupe1[parent1].gene[i];
          chromosome34.gene[i] = groupe1[parent3].gene[i];
        }else{
          chromosome12.gene[i] = groupe1[parent2].gene[i];
          chromosome34.gene[i] = groupe1[parent4].gene[i];
        }
      }
    }else if ( groupeNumber == 2){
      for(int i = 0 ; i<8 ; i++){
        if(i%2 ==0){
          chromosome12.gene[i] = groupe2[parent1].gene[i];
          chromosome34.gene[i] = groupe2[parent3].gene[i];
        }else{
          chromosome12.gene[i] = groupe2[parent2].gene[i];
          chromosome34.gene[i] = groupe2[parent4].gene[i];
        }
      }
    }else if (groupeNumber == 3){
      for(int i = 0 ; i<8 ; i++){
        if(i%2 ==0){
          chromosome12.gene[i] = groupe3[parent1].gene[i];
          chromosome34.gene[i] = groupe3[parent3].gene[i];
        }else{
          chromosome12.gene[i] = groupe3[parent2].gene[i];
          chromosome34.gene[i] = groupe3[parent4].gene[i];
        }
      }
    }else{
      for(int i = 0 ; i<8 ; i++){
        if(i%2 ==0){
          chromosome12.gene[i] = groupe4[parent1].gene[i];
          chromosome34.gene[i] = groupe4[parent3].gene[i];
        }else{
          chromosome12.gene[i] = groupe4[parent2].gene[i];
          chromosome34.gene[i] = groupe4[parent4].gene[i];
        }
      }
    }
    return [chromosome12,chromosome34];
 }

  resetScore(int groupNumber){
    if(groupNumber==1){
      for(int i = 0 ; i < 8 ; i++){
        groupe1[i].score = 0;
      }
    }else if(groupNumber ==2 ){
      for(int i = 0 ; i < 8 ; i++){
        groupe2[i].score = 0;
      }
    }else if(groupNumber == 3){
      for(int i = 0 ; i < 8 ; i++){
        groupe3[i].score = 0;
      }
    }else{
      for(int i = 0 ; i < 8 ; i++){
        groupe4[i].score = 0;
      }
    }
  }

  makeChild(int groupNumber){
    if(groupNumber==1){
      bubbleSort( groupe1);
      printBest(groupe1[0]);
      print('ffffff 1');
      groupe1.removeLast();
      print('ffffff 2');
      groupe1.removeLast();
      print('ffffff 3');
      groupe1.removeLast();
      print('ffffff 4');
      groupe1.addAll(recombination(groupNumber));
      print('ffffff 5');
      groupe1.add(motive(groupNumber));
      print('ffffff 6');
      resetScore(groupNumber);
      print('ffffff 7');
    }else if ( groupNumber == 2){
      bubbleSort( groupe2);
      printBest(groupe2[0]);
      groupe2.removeLast();
      groupe2.removeLast();
      groupe2.removeLast();
      groupe2.addAll(recombination(groupNumber));
      groupe2.add(motive(groupNumber));
      resetScore(groupNumber);
    }else if(groupNumber == 3){
      bubbleSort( groupe3);
      printBest(groupe3[0]);
      groupe3.removeLast();
      groupe3.removeLast();
      groupe3.removeLast();
      groupe3.addAll(recombination(groupNumber));
      groupe3.add(motive(groupNumber));
      resetScore(groupNumber);
    }else{
      bubbleSort( groupe4);
      printBest(groupe4[0]);
      groupe4.removeLast();
      groupe4.removeLast();
      groupe4.removeLast();
      groupe4.addAll(recombination(groupNumber));
      groupe4.add(motive(groupNumber));
      resetScore(groupNumber);
    }

  }

  printBest(Chromosome chromosome){
    print("score in groupe : " + chromosome.score.toString());
    for(int i = 0 ; i < 8 ; i++ ){
      for( int j = 0 ; j < 8 ; j++){
          print(chromosome.gene[i][j].toString() + " ");
      }
     print("\n");
    }
  }

  void bubbleSort(List<Chromosome> groupe)
  {
  int i, j;
  int n = 10;
  for (i = 0; i < n-1; i++){
      for (j = 0; j < n-i-1; j++){
            if(groupe[j].score<groupe[j+1].score){
              Chromosome temp = groupe[j];
              groupe[j] = groupe[j+1];
              groupe[j+1] = temp;
            }
       }
  }

  }


}


class Chromosome{
  int score ;
  List gene;

  Chromosome({this.gene,this.score});
}