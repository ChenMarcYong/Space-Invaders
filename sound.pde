import processing.sound.*;
SoundFile spaceship_hit_sound, invader_killed_sound, menu_theme_sound, game_over_sound, shoot_sound, in_game_music, bonus_sound;
class Sound {
  Sound() {
  }

  void shoot() {
    shoot_sound.play();
  }
  void menu() {
    //Sound.volume(amplitude);
    menu_theme_sound.loop();
  }
  void spaceship_hit() {
    spaceship_hit_sound.play();
  }
  void invader_killed() {
    invader_killed_sound.play();
  }
  void game_over() {
    game_over_sound.play();
  }
  void bonus() {
    bonus_sound.play();
  }
  void in_game() {
    in_game_music.play();
  }
}

void initSounds() {
  spaceship_hit_sound = new SoundFile(this, "audio/spaceship_hit.wav");
  game_over_sound = new SoundFile(this, "audio/game_over.wav");
  invader_killed_sound = new SoundFile(this, "audio/invader_killed.wav");
  menu_theme_sound = new SoundFile(this, "audio/menu_theme.wav");
  shoot_sound = new SoundFile(this, "audio/shoot.wav");
  bonus_sound = new SoundFile(this, "audio/bonus_collected.mp3");
  in_game_music = new SoundFile(this, "audio/in_game_music.wav");
}
