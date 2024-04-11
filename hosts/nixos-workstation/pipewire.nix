{ inputs, ... }:

{
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # make pipewire realtime-capable
  security.rtkit.enable = true;

  # disable the default sound server
  hardware.pulseaudio.enable = false;
}
