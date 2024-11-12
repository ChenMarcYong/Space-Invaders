class Menu {
  Boolean pause;
  Boolean highscore;
  Boolean regle;
  PImage back;
  PImage rules;
  Boolean im_load;    //fais charger l'image une seule fois et non tous le temps  (Pour ne pas faire chauffer l'ordi).
  Menu() {
    pause=false;
    highscore=false;
    regle=false;
    back=loadImage("sprite/frame.png");           // image d'arrière plan du menu pause.
    rules=loadImage("sprite/regle.png");
    im_load=false;
  }
  void contour(float x, float y, float largeur, float longueur) {        // Pour faire les contours de chaque options.
    if (mouseX>x && mouseX<x+largeur && mouseY>y && mouseY<y+longueur) {
      noFill();
      stroke(255);
      strokeWeight(3);
      rect(x, y, largeur, longueur);
    }
  }

  void drawIt() {
    if (pause) {
      if (im_load==false) {
        back=loadImage("pause_back/frame.png");
        im_load=true;
      }
      rectMode(CORNER);
      image(back, 0, 0);
      fill(0, 0, 0, 200);
      noStroke();
      rect(0, 0, width, height);

      fill(255);
      textSize(40);
      textAlign(CENTER);
      text("score  :  "+game._score, width*0.5, height*0.15);
      textAlign(LEFT);
      textSize(50);
      text("Pause", width*0.42, height*0.3);
      textSize(30);
      text("Reprendre la partie", width*0.1, height*0.4);                               // Pour reprendre la partie.
      contour(width*0.075, height*0.365, width*0.29, height*0.05);
      if (mousePressed && mouseX>0.075*width && mouseX<0.365*width && mouseY>0.365*height && mouseY<0.415*height ) {
        pause=false;
      }

      text("Recommencer la partie", width*0.1, height*0.5);                          // Recommencer la partie.
      contour(width*0.075, height*0.465, width*0.335, height*0.05);
      if (mouseX>width*0.075 && mouseX<width*0.41 && mouseY>height*0.465 && mouseY<height*0.515 && mousePressed) {
        // méthode recommencer.
        initGame("level1");
        reset();
        pause=false;
      }

      text("Sauvegarder", width*0.1, height*0.6);                                       // Pour sauvegarder la partie.
      contour(width*0.075, height*0.565, width*0.2, height*0.05);
      if (mouseX>width*0.075 && mouseX<width*0.295 && mouseY>height*0.565 && mouseY<height*0.615 && mousePressed) {
        saveBoard(str(levels.level));
        save_profil();
        text("Partie sauvegardée", width*0.4, height*0.6);
      }
      text("Consulter les meilleurs scores", width*0.1, height*0.7);                    // Pour consulter les meilleurs scores.
      contour(width*0.075, height*0.665, width*0.42, height*0.05);
      if (mouseX>width*0.075 && mouseX<width*0.495 && mouseY>height*0.665 && mouseY<height*0.715 && mousePressed) {
        // méthode highscore.
        read_highscore();
        pause=false;
        highscore=true;
      }
      text("Charger un profil", width*0.1, height*0.8);                                    // Pour revenir au menu principal.
      contour(width*0.075, height*0.765, width*0.26, height*0.05);
      if (mouseX>width*0.075 && mouseX<width*0.335 && mouseY>height*0.765 && mouseY<height*0.815 && mousePressed) {
        if (mouseButton==LEFT) {
          Main_menu.name="";                                                           // Pour vider le nom.
          //rénitialiser le board.
          pause=false;
          reset();
          menu_theme_sound.loop();
          game_state="main_menu";
        }
      }
      text("Quitter le jeu", width*0.1, height*0.9);                                       // Pour quitter le jeu.
      contour(width*0.075, height*0.865, width*0.2, height*0.05);
      if (mouseX>width*0.075 && mouseX<width*0.275 && mouseY>height*0.865 && mouseY<height*0.915 && mousePressed) {
        exit();
      }
      text("Règles", width*0.7, height*0.4);
      contour(width*0.675, height*0.365, width*0.125, height*0.05);
      if (mouseX>width*0.675 && mouseX<width*0.8 && mouseY>height*0.365 && mouseY<height*0.415 && mousePressed) {
        pause=false;
        regle=true;
        image(Main_menu.im_Main_menu, width, height);
      }
    }
  }
  void saveBoard(String level) {
    String[] saved_file = new String[board._cells.length + 1];
    saved_file[0] = "Niveau "+level;
    for (int i = 1; i < saved_file.length; ++i) {
      switch (board._cells[i-1][0]) {
      case INVADER :
        saved_file[i] = "I";
        break;
      case EMPTY :
        saved_file[i] = "E";
        break;
      case OBSTACLE :
        saved_file[i] = "X";
        break;
      case SPACESHIP :
        saved_file[i] = "S";
        break;
      }
    }
    for (int i = 0; i < board._cells.length; ++i) {
      for (int j = 0; j < board._cells[i].length; ++j) {
        switch (board._cells[i][j]) {
        case INVADER :
          saved_file[i+1] += "I";
          break;
        case EMPTY :
          saved_file[i+1] += "E";
          break;
        case OBSTACLE :
          saved_file[i+1] += "X";
          break;
        case SPACESHIP :
          saved_file[i+1] += "S";
          break;
        }
      }
    }
    saveStrings("levels/saved_game/"+str(Main_menu.which_profil)+".txt", saved_file);                                                   //"data/profil/profil"+str(Main_menu.which_profil)+"/level_save.txt"
  }

  void display_highscore() {
    if (highscore) {
      image(back, 0, 0);
      rectMode(CORNER);
      fill(0, 0, 0, 200);
      noStroke();
      rect(0, 0, width, height);
      fill(255);
      textSize(65);
      textAlign(CENTER);
      text("HIGHSCORE", width*0.5, height*0.25);
      textAlign(LEFT);
      textSize(50);
      fill(#ffd700);                                      // couleur or.
      text("1  :     "+h1[0]+ "     "+h1[1], width*0.3, height*0.4);
      fill(#c0c0c0);                                     // couleur argent.
      text("2  :     "+h2[0]+ "     "+h2[1], width*0.3, height*0.48);
      fill(#614e1a);                                   // couleur bronze.
      text("3  :     "+h3[0]+ "     "+h3[1], width*0.3, height*0.56);
      fill(255);
      text("4  :     "+h4[0]+ "     "+h4[1], width*0.3, height*0.64);
      text("5  :     "+h5[0]+ "     "+h5[1], width*0.3, height*0.72);
      textSize(30);
      textAlign(LEFT);
      text("retour", width*0.8, height*0.9);
      strokeWeight(3);
      stroke(255);
      contour(width*0.789, height*0.867, width*0.105, height*0.05);
      if (mouseX>0.789*width && mouseX<0.894*width && mouseY>height*0.867 && mouseY<height*0.917 && mousePressed) {
        highscore=false;
        pause=true;
      }
    }
  }

  void display_rules() {
    if (regle) {
      image(rules, 0, 0);
      textSize(20);
      text("Vous venez de vous faire appelez à l'aide part l'empire galactique\n vous êtes le dernier espoir face à l'invasion des terribles invaders.\n Votre mission est d'éliminer tous les ennemis. \n", width*0.1, height*0.4);
      text("bonus :", width*0.1, height* 0.55);
      image(levels.coeur, width*0.25, height*0.485);
      textSize(20);
      text("+1 coeurs\n +150 points si max pv", width*0.2, height*0.6);
      image(levels.double_points, width*0.45, height*0.5, 60, 60);
      text("x2 points \npendant 5 secondes", width*0.425, height*0.6);
      image(levels.double_fire_rate, width*0.65, height*0.525, 40, 40);            // double_fire_rate, triple_fire_rate, double_points;
      text("x2 cadence de tir\npendant 5 secondes", width*0.625, height*0.6);
      image(levels.triple_fire_rate, width*0.85, height*0.525, 40, 40);            // double_fire_rate, triple_fire_rate, double_points;
      text("x3 cadence de tir\npendant 5 secondes", width*0.825, height*0.6);
      text("contrôle : q/flèche de droite pour aller à droite", width*0.1, height*0.7);
      text("d/flèche de gauche pour aller à gauche", width*0.18, height*0.725);
      textSize(30);
      text("Retourner au jeu", width*0.7, height*0.8);
      contour(width*0.685, height*0.765, width*0.24, height*0.05);
      if (mouseX>0.685*width && mouseX<0.925*width && mouseY>height*0.765 && mouseY<height*0.83 && mousePressed) {
        regle=false;
        pause=true;
      }
    }
  }
}
