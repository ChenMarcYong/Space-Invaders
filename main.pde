class Main_menu {
  PImage im_Main_menu;
  PImage im_Main_screen;
  String name;
  String profil1, profil2, profil3, profil4;
  String scorep1, scorep2, scorep3, scorep4;
  String levelp1, levelp2, levelp3, levelp4;
  //Boolean have_a_profil1=false, have_a_profil2=false, have_a_profil3=false, have_a_profil4=false;
  int which_profil;
  String which_profil_delete="";
  boolean delete_profil=false;
  Main_menu() {
    im_Main_screen=loadImage("sprite/title_main_screen.png");
    im_Main_menu=loadImage("sprite/title_main_menu.png");
    name="";
    profil1="new";
    profil2="new";
    profil3="new";
    profil4="new";
    which_profil=0;
  }
  void contour(float x, float y, float largeur, float longueur) {        // Pour faire les contours de chaque options.
    noFill();
    stroke(255);
    strokeWeight(3);
    rect(x, y, largeur, longueur);
  }

  void display_Main_screen() {               // écran titre.
    if (game_state=="main_screen") {
      image(im_Main_screen, 0, 0, width, height);
      textSize(25);
      fill(255);
      text("Appuyer sur entrée pour commencer", width*0.31, height*0.56);
      if (key==10 && keyPressed) {
        game_state="main_menu";
      }
    }
  }
  //void display_Main_menu(){



  //}

  void display_Main_menu() {              // menu principal.
    if (game_state=="main_menu") {
      image(im_Main_menu, 0, 0, width, height);
      initGame("level1");                                      // réinitialiser le board
      fill(255);                              // Pour qu'il reste afficher même dans le menu pause.
      rectMode(CORNER);
      textSize(30);
      textAlign(CENTER);
      text("Charger un profil", width*0.5, height*0.4);
      text(profil1, width*0.5, height*0.5);
      textSize(20);
      text("level "+levelp1+"     "+scorep1, width*0.5, height*0.53);
      if (mouseX>width*0.35 &&mouseX<width*0.615 && mouseY>height*0.465 && mouseY<height*0.535) {
        contour(width*0.368, height*0.47, width*0.265, height*0.075);
        if (mousePressed) {
          which_profil=1;
          read_profil();
          menu_theme_sound.stop();
          Sound.in_game();
        }
      }
      textSize(30);
      text(profil2, width*0.5, height*0.6);
      textSize(20);
      text("level "+levelp2+"     "+scorep2, width*0.5, height*0.63);
      if (mouseX>width*0.35 &&mouseX<width*0.615 && mouseY>height*0.565 && mouseY<height*0.635) {
        contour(width*0.368, height*0.57, width*0.265, height*0.075);
        if (mousePressed) {
          which_profil=2;
          read_profil();
          menu_theme_sound.stop();
           Sound.in_game();
        }
      }
      textSize(30);
      text(profil3, width*0.5, height*0.7);
      textSize(20);
      text("level "+levelp3+"     "+scorep3, width*0.5, height*0.73);
      if (mouseX>width*0.35 &&mouseX<width*0.615 && mouseY>height*0.665 && mouseY<height*0.735) {
        contour(width*0.368, height*0.67, width*0.265, height*0.075);
        if (mousePressed) {
          game_state="name";
          which_profil=3;
          read_profil();
          menu_theme_sound.stop();
           Sound.in_game();
        }
      }
      textSize(30);
      text(profil4, width*0.5, height*0.8);
      textSize(20);
      text("level "+levelp4+"     "+scorep4, width*0.5, height*0.83);
      if (mouseX>width*0.35 &&mouseX<width*0.615 && mouseY>height*0.765 && mouseY<height*0.835) {
        contour(width*0.368, height*0.77, width*0.265, height*0.075);
        if (mousePressed) {
          game_state="name";
          which_profil=4;
          read_profil();
          menu_theme_sound.stop();
           Sound.in_game();
        }
      }
      textAlign(LEFT);
      textSize(30);
      text("effacer une sauvegarde", width*0.1, height*0.9);
      if (mouseX>width*0.085 &&mouseX<width*0.395 && mouseY>height*0.865 && mouseY<height*0.915) {
        contour(width*0.085, height*0.865, width*0.32, height*0.05);
        if (mousePressed) {
          game_state="delete_profile";                                           //supprimer des sauvegardes.
        }
      }
    }
  }
  void choose_a_name() {
    if (game_state=="name") {
      background(0);
      textSize(30);
      text("name : ", width*0.100, height*0.400);
      text(name, width*0.2, height*0.400);
      textSize(20);
      text("10 charactères max", width*0.125, height*0.50);
      text("Appuyer sur entrée pour continuer", width*0.125, height*0.450);
      if (key==10 && keyPressed) {
        game_state="start_level";
      }
    }
  }
  void loose_game() {                                      // Fin de partie.
    if (game_state=="loose_game") {
      String level=str(levels.level-1);
      //println(total_score);
      fill(255);
      background(0);
      read_highscore();
      display_highscores();
      textSize(50);
      rectMode(CORNER);
      textAlign(CENTER);
      text(Main_menu.name, width*0.5, height*0.1);
      text("GAME OVER", width*0.5, height*0.175);
      textSize(30);
      text("vous avez survécu : "+level+" niveaux", width*0.5, height*0.25);
      text("score final : ", width*0.5, height*0.3);
      textSize(75);
      text(game._score, width*0.5, height*0.4);
      textAlign(LEFT);
      textSize(30);
      text("Retour au menu principal", width*0.6, height*0.9);
      if (mouseX>width*0.585&&mouseX<width*0.935&&mouseY>height*0.865&&mouseY<height*0.915) {
        contour(width*0.585, height*0.865, width*0.35, height*0.05);
        if (mousePressed) {
          reset();
          menu_theme_sound.loop();
          game_state="main_menu";
        }
      }
    }
  }
  void win_game() {                                      // Fin de partie.
    if (game_state=="win_game") {
      //initGame("level1");
      String level=str(levels.level);
      fill(255);
      background(0);
      read_highscore();
      display_highscores();
      textSize(50);
      rectMode(CORNER);
      textAlign(CENTER);  //Main_menu.name+
      text(Main_menu.name, width*0.5, height*0.1);
      text("Vous avez gagné !", width*0.5, height*0.175);
      textSize(30);
      text("vous avez survécu : "+level+" niveaux", width*0.5, height*0.25);
      text("score final : ", width*0.5, height*0.3);
      textSize(75);
      text(game._score, width*0.5, height*0.4);
      textAlign(LEFT);
      textSize(30);
      text("Retour au menu principal", width*0.6, height*0.9);
      if (mouseX>width*0.585&&mouseX<width*0.935&&mouseY>height*0.865&&mouseY<height*0.915) {
        contour(width*0.585, height*0.865, width*0.35, height*0.05);
      }
      if (mousePressed) {
        reset();
        Main_menu.name="";
        menu_theme_sound.loop();
        game_state="main_menu";
      }
    }
  }
  void delete_profile() {
    if (game_state=="delete_profile") {
      image(im_Main_menu, 0, 0, width, height);
      fill(255);
      textSize(30);
      textAlign(LEFT);
      text("choisir quel profil à supprimer", width*0.1, height*0.4);
      textAlign(CENTER);
      text(profil1, width*0.25, height*0.5);
      if (mouseX>width*0.125&&mouseX<width*0.393&&mouseY>height*0.465&&mouseY<height*0.525) {
        contour(width*0.125, height*0.465, width*0.268, height*0.05);
        if (mousePressed) {
          menu_theme_sound.stop();
          which_profil_delete="1";
        }
      }
      text(profil2, width*0.25, height*0.6);
      if (mouseX>width*0.125&&mouseX<width*0.393&&mouseY>height*0.565&&mouseY<height*0.625) {
        contour(width*0.125, height*0.565, width*0.268, height*0.05);
        if (mousePressed) {
          which_profil_delete="2";
        }
      }
      text(profil3, width*0.25, height*0.7);
      if (mouseX>width*0.125&&mouseX<width*0.393&&mouseY>height*0.665&&mouseY<height*0.725) {
        contour(width*0.125, height*0.665, width*0.268, height*0.05);
        if (mousePressed) {
          which_profil_delete="3";
        }
      }
      text(profil4, width*0.25, height*0.8);
      if (mouseX>width*0.125&&mouseX<width*0.393&&mouseY>height*0.765&&mouseY<height*0.825) {
        contour(width*0.125, height*0.765, width*0.268, height*0.05);
        if (mousePressed) {
          which_profil_delete="4";
        }
      }
      fill(255);
      textSize(30);
      textAlign(LEFT);
      text("Supprimer le profil "+ which_profil_delete, width*0.5, height*0.6);
      if (mouseX>width*0.475&&mouseX<width*0.775&&mouseY>height*0.565&&mouseY<height*0.615) {
        contour(width*0.475, height*0.565, width*0.3, height*0.05);
        if (mousePressed && which_profil_delete!="") {
          new_profil(which_profil_delete);
          launch_profil();
          which_profil_delete="";
        }
      }
      text("Retourner au menu principal", width*0.5, height*0.9);
      if (mouseX>width*0.475&&mouseX<width*0.875&&mouseY>height*0.865&&mouseY<height*0.915) {
        contour(width*0.475, height*0.865, width*0.4, height*0.05);
        if (mousePressed) {
          game_state="main_menu";
        }
      }
    }
  }
}
void save_profil() {
  String[] profil=new String[5];
  profil[0]=Main_menu.name;
  profil[1]=str(levels.level);
  profil[2]=str(game._score);
  profil[3]=str(game._lives);
  profil[4]="true";                                      //détermine si un fichier est sauvegardé ou non.
  saveStrings("data/profil/profil"+str(Main_menu.which_profil)+".txt", profil);
}


void read_profil() {
  String[] read=loadStrings("data/profil/profil"+str(Main_menu.which_profil)+".txt");
  initGame("saved_game/"+str(Main_menu.which_profil));
  Main_menu.name=read[0];
  levels.level=int(read[1]);
  game._score=int(read[2]);
  game._lives=int(read[3]);
  levels.im_level_load=false;
  if (read.length==5) {                                                      // regarde si un pofil à dejà été sauvegardé.
    game_state="start_level";
  }
  if (read.length==4) {
    game_state="name";
  }
}


void launch_profil() {
  String[]readp1=loadStrings("data/profil/profil1.txt");
  String[]readp2=loadStrings("data/profil/profil2.txt");
  String[]readp3=loadStrings("data/profil/profil3.txt");
  String[]readp4=loadStrings("data/profil/profil4.txt");
  Main_menu.profil1=readp1[0];
  Main_menu.profil2=readp2[0];
  Main_menu.profil3=readp3[0];
  Main_menu.profil4=readp4[0];
  Main_menu.scorep1=readp1[2];
  Main_menu.levelp1=readp1[1];
  Main_menu.scorep2=readp2[2];
  Main_menu.levelp2=readp2[1];
  Main_menu.scorep3=readp3[2];
  Main_menu.levelp3=readp3[1];
  Main_menu.scorep4=readp4[2];
  Main_menu.levelp4=readp4[1];
}


void new_profil(String profiles) {
  String[] new_profil=new String[4];
  String[] read =loadStrings("levels/level1.txt");
  String[] new_level=new String[read.length];
  new_profil[0]="new";                                         //name
  new_profil[1]="1";                                          //level
  new_profil[2]="0";                                          //score
  new_profil[3]="3";                                       //pv
  saveStrings("levels/saved_game/"+profiles+".txt", read);


  saveStrings("data/profil/profil"+profiles+".txt", new_profil);
}

void display_highscores() {
  textAlign(LEFT);
  textSize(50);
  fill(#ffd700);                                      // couleur or.
  text("1  :     "+h1[0]+ "     "+h1[1], width*0.3, height*0.5);
  fill(#c0c0c0);                                     // couleur argent.
  text("2  :     "+h2[0]+ "     "+h2[1], width*0.3, height*0.58);
  fill(#614e1a);                                   // couleur bronze.
  text("3  :     "+h3[0]+ "     "+h3[1], width*0.3, height*0.66);
  fill(255);
  text("4  :     "+h4[0]+ "     "+h4[1], width*0.3, height*0.74);
  text("5  :     "+h5[0]+ "     "+h5[1], width*0.3, height*0.82);
}
