class levels {
  int nombre_level;
  int nombre_fond_level=5;
  int level;
  PImage im_level;
  Boolean im_level_load;               // fais charger l'image une seule fois et non tous le temps  (Pour ne pas faire chauffer l'ordi).
  float speed;
  float intervalle;
  float refresh_rate;
  int i;
  PImage defile;
  PImage coeur, double_fire_rate, triple_fire_rate, double_points;                                              //pv et bonus.
  int start=5000, duration=5000;
  Boolean level_process=false;
  int display_level=0;      //idée pour un mode sans fin.
  int score_;
  levels() {
    nombre_level=10;
    level=1;
    im_level_load=false;
    speed=5;                                         // vitesse de déliment.
    intervalle=0;
    refresh_rate=20;
    coeur=loadImage("sprite/coeur.png");
    double_fire_rate=loadImage("sprite/2x_fire_rate.png");
    triple_fire_rate=loadImage("sprite/3x_fire_rate.png");
    double_points=loadImage("sprite/2x_points.png");
    i=int(-2000/speed);
  }
  void defile(PImage defile) {
    if (millis()>intervalle) {
      image(defile, 0, floor(i*speed));
      i++;
      intervalle=intervalle+refresh_rate;
      if (i*speed>0) {
        i=int(-2000/speed);
      }
    }
  }
  void start_level() {
    if ( game_state=="start_level") {
      noStroke();
      if (im_level_load==false) {
        //speed+=0.5;                  // modifie la vitesse de défilement.
        //print(speed);
        // print(speed+" ");
        i=int(-2000/speed);
        display_level=level;
        if (display_level>nombre_fond_level) {
          display_level=level%nombre_fond_level;
        }
        if (display_level==0) {
          display_level++;
        }

        im_level=loadImage("sprite/level"+str(display_level)+".png");
        im_level_load=true;
        display_level++;
      }
      defile(im_level);
      if (game._lives==1) {
        image(coeur, width*0.025, height*0.05);                            // coeur.
      } else if (game._lives==2) {
        image(coeur, width*0.025, height*0.05);                            // coeur.
        image(coeur, width*0.075, height*0.05);
      } else if (game._lives==3) {
        image(coeur, width*0.025, height*0.05);                            // coeur.
        image(coeur, width*0.075, height*0.05);
        image(coeur, width*0.125, height*0.05);
      }
      if ( millis()>start) {
        start+=duration;
      }
      display_bonus();
      fill(255);
      textSize(40);
      text("level "+str(level), width*0.850, height*0.050);
      text(Main_menu.name, width*0.05, height*0.05);
      textSize(60);
      text(game._score, width*0.5, height*0.1);
    }
  }

  void fin_level() {
    if (game_state=="fin_level") {
      score_=game._score;
      background(0, 0, 0);
      noFill();
      textSize(75);
      textAlign(CENTER);
      text(game._score, width*0.5, height*0.4);
      textSize(30);
      text("score : ", width*0.5, height*0.3);
      text("niveau "+level+" terminé", width*0.5, height*0.5);
      text("Appuyer sur entrée pour continuer", width*0.5, height*0.6);
      noFill();
      strokeWeight(3);
      stroke(255);
      if (key==10 && keyPressed) {
        game_state="start_level";
        if (level==nombre_level) {
          save_score();
          highscore();
          game_state="win_game";                                                                //gagner.
        }
        if (level<nombre_level) {
          level++;
          next_level();
        }
      }
    }
  }
  void next_level() {
    initGame("level"+str(level));
    game._score=score_;
  }
  void display_bonus() {
    if (bonus._bonus_type == TypeBonus.DOUBLE_FIRE_RATE&&bonus.collected==true && millis()<start) {
      image(double_fire_rate, width*0.875, height*0.075, 60, 60);
      start+=duration;
    }
    if (bonus._bonus_type == TypeBonus.TRIPLE_FIRE_RATE&&bonus.collected==true && millis()<start) {
      image(triple_fire_rate, width*0.875, height*0.075, 60, 60);
      start+=duration;
    }
    if (bonus._bonus_type == TypeBonus.DOUBLE_SCORE&&bonus.collected==true && millis()<start) {
      image(double_points, width*0.875, height*0.075, 60, 60);
      start+=duration;
    }
  }
}

void reset() {
  levels.speed=1;
  levels.level=1;
  levels.im_level_load=false;
  game._score=0;
  initGame("level1");
  launch_profil();
}

void save_score() {
  String[] score=new String[2];
  score[0]=Main_menu.name;
  score[1]=str(game._score);
  saveStrings("data/highscore/current_score.txt", score);
}


void read_highscore() {
  String[] read_highscore=loadStrings("data/highscore/highscores.txt");

  h1[0]=read_highscore[0];
  h1[1]=read_highscore[1];
  h2[0]=read_highscore[2];
  h2[1]=read_highscore[3];
  h3[0]=read_highscore[4];
  h3[1]=read_highscore[5];
  h4[0]=read_highscore[6];
  h4[1]=read_highscore[7];
  h5[0]=read_highscore[8];
  h5[1]=read_highscore[9];
}
void highscore() {
  String[] read_highscore=loadStrings("data/highscore/highscores.txt");
  Boolean new_highscore=false;
  int  p1=0, p2=0;
  int k=7;
  int nbr_changement=0;
  for (int i =0; i<=read_highscore.length-1; i+=2) {
    if (!new_highscore) {
      if (game._score>=int(read_highscore[i+1])) {
        new_highscore=true;
        p1=i;
        p2=i+1;
        nbr_changement=read_highscore.length/2- i/2-1;
      }
    }
  }
  if (new_highscore) {
    for (int j=0; j<nbr_changement; j++) {
      read_highscore[k+2]=read_highscore[k];
      read_highscore[k+1]=read_highscore[k-1];
      k-=2;
    }
    read_highscore[p2]=str(game._score);
    read_highscore[p1]=Main_menu.name;
  }
  saveStrings("data/highscore/highscores.txt", read_highscore);
}
